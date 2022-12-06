import torch 

import numpy as np

from quantize import *

def inject_no_err(weight : torch.Tensor, n: int, is_ch_quant):
    with torch.no_grad():
        if is_ch_quant:
            weight_q, scale, zero_p = quantize_channel(weight, n)
            weight[:] = dequantize_channel(weight_q, scale, zero_p)
        else:
            weight_q, scale, zero_p = quantize_layer(weight, n)
            weight[:] = dequantize_layer(weight_q, scale, zero_p)            

def inject_single_err_default(weight : torch.Tensor, p : float, n: int, is_ch_quant):
    with torch.no_grad():
        if is_ch_quant:
            weight_q, scale, zero_p = quantize_channel(weight, n)
        else:
            weight_q, scale, zero_p = quantize_layer(weight, n)
        
        weight_q_1d = weight_q.view((-1,))
        size = torch.numel(weight_q_1d)
        err = np.packbits(np.random.binomial(1, p, size * 16))
        err_to_weight = err.reshape(-1,16)[:,:8].reshape(-1)
        err_tensor = torch.tensor(err_to_weight)
        weight_q_1d.bitwise_xor_(err_tensor)

        if is_ch_quant:
            weight[:] = dequantize_channel(weight_q, scale, zero_p)
        else:
            weight[:] = dequantize_layer(weight_q, scale, zero_p)

def inject_single_err_wn(weight : torch.Tensor, p: float):
    with torch.no_grad():
        weight_1d = weight.view(torch.int16).view((-1,))
        weight_1d &= 0xfffe
        size = torch.numel(weight_1d)

        err = np.packbits(np.random.binomial(1, p, size * 16)).view(np.int16)
        
        flag = (err & 0x5555) + ((err >> 1) & 0x5555)
        flag = (flag & 0x3333) + ((flag >> 2) & 0x3333)
        flag = (flag & 0x0f0f) + ((flag >> 4) & 0x0f0f)
        flag = (flag & 0x00ff) + ((flag >> 8) & 0x00ff)
        weight_null = torch.tensor(flag & 1) ^ 1
        err = torch.tensor(err)
        weight_1d.bitwise_xor_(err)
        weight_1d.mul_(weight_null)

def inject_single_err_vapi(    weight  : torch.Tensor, 
                        p       : float, 
                        n       : int, 
                        bch, 
                        mask):
    with torch.no_grad():
        size = torch.numel(weight)
        err = np.packbits(np.random.binomial(1,p, size*16))
        err_to_weight = err.reshape(-1,16)[:,:8].reshape(-1)
        err_to_weight_unpacked = np.unpackbits(err_to_weight).reshape(-1, 8 * 8)
        err_occur = np.zeros((size // 8, 64), dtype=np.uint8)

        b = bch.decode(err_to_weight_unpacked).reshape(-1,50)
        err_occur[:,::8]         = b[:,:48:6]    # 10011111
        err_occur[:, 0+3: 0+3+5] = b[:, 0+1: 0+1+5]
        err_occur[:, 8+3: 8+3+5] = b[:, 6+1: 6+1+5]
        err_occur[:,16+3:16+3+5] = b[:,12+1:12+1+5]
        err_occur[:,24+3:24+3+5] = b[:,18+1:18+1+5]
        err_occur[:,32+3:32+3+5] = b[:,24+1:24+1+5]
        err_occur[:,40+3:40+3+5] = b[:,30+1:30+1+5]
        err_occur[:,48+3:48+3+5] = b[:,36+1:36+1+5]
        err_occur[:,56+1:64    ] = b[:,42+1:50    ]
        err_occur = np.packbits(err_occur)
        err_tensor = torch.tensor(err_occur).reshape(weight.reshape(-1,8).shape)

        scale = 128 / (2 ** n)
        weight_clip = torch.clip(weight,min=-(2 **n),max=(2 ** n)).reshape(-1,8)
        sign = (weight_clip < 0).int() ^ ((err_tensor & 0x80) >> 7)
        value = torch.abs(weight_clip).reshape(-1,8)
        value_temp = torch.round(value * scale).int() ^ (err_tensor & 0x7f)
        det  = (value_temp < 32 ) * 128 + (value_temp - 32)
        idx  = torch.argmin(det, dim=1)

        mask = torch.eye(8,dtype=torch.uint8)[idx] | (value < 0.5)
        value_temp = (value_temp & 0xfc) + (value_temp & 0x3) * mask
        weight[:] = ((sign.reshape(weight.shape) * (-2) + 1) * value_temp.reshape(weight.shape) / scale)

def inject_single_err_squid(   weight  : torch.Tensor, 
                        p       : float, 
                        n       : int, 
                        encode_lut, 
                        decode_lut, 
                        rs, 
                        mask,
                        is_ch_quant):
    with torch.no_grad():
        # Do quantization with n-bit
        if is_ch_quant:
            weight_q, scale, zero_p = quantize_channel(weight, n)
        else:
            weight_q, scale, zero_p = quantize_layer(weight, n)

        # Generate VPs and PPs
        weight_q_np = weight_q.view(torch.uint8).view(-1,8).detach().numpy()
        weight_q_unpacked = np.unpackbits(weight_q_np).reshape(-1,8)
        weight_q_weighted = weight_q_unpacked * encode_lut
        vp = np.bitwise_xor.reduce(weight_q_weighted, axis=1)
        pp = rs.encode(vp.reshape(-1,8))[:,8:]

        # Memory Error Occurred to quantized weight and PP
        size = torch.numel(weight_q)
        err = np.packbits(np.random.binomial(1, p, size * 16)) & mask
        err_to_weight = err.reshape(-1,16)[:,:8]
        err_to_pp = err.reshape(-1,16)[:,8: 24 - 2 * n]
        weight_w_err = weight_q_np ^ err_to_weight
        pp_w_err = pp ^ (err_to_pp & 0xf)

        # During Decoding, first generate VPs which might be disrupted
        received_blk = np.zeros((size // 8, 24 - 2 * n), dtype = np.uint8)   
        weight_w_err_unpacked = np.unpackbits(weight_w_err).reshape(-1,8)
        weight_w_err_weighted = weight_w_err_unpacked * encode_lut
        vp_w_err = np.bitwise_xor.reduce(weight_w_err_weighted, axis=1)
        vp_w_err = vp_w_err.reshape(-1,8)

        # With PPs, recover the VP
        received_blk[:,:8] = vp_w_err
        received_blk[:,8:] = pp_w_err
        recover_vp = rs.decode(received_blk)

        # Recover the weight
        err_predicted = decode_lut[recover_vp ^ vp_w_err]
        err_recovered = err_to_weight.reshape(-1) ^ err_predicted.reshape(-1)
        err_recovered_tensor = torch.tensor(err_recovered)
        weight_q_1d = weight_q.view(-1)
        weight_q_1d.bitwise_xor_(err_recovered_tensor)

        # Dequantize the weight for inference test for ease
        if is_ch_quant:
            weight[:] = dequantize_channel(weight_q, scale, zero_p)
        else:
            weight[:] = dequantize_layer(weight_q, scale, zero_p)

def inject_double_err_wn(weight : torch.Tensor, p: float):
    with torch.no_grad():
        weight_1d = weight.view(torch.int16).view((-1,))
        weight_1d &= 0xfffe
        size = torch.numel(weight_1d)

        err_origin = np.random.binomial(1, p, size * 16)
        err_idx = np.nonzero(err_origin)[0]
        err_unpacked = np.zeros(size * 16 + 8, dtype=np.uint8)
        err_unpacked[err_idx]   = 1
        err_unpacked[err_idx+1] = 1
        err = np.packbits(err_unpacked[:size * 16]).view(np.int16)
        
        flag = (err & 0x5555) + ((err >> 1) & 0x5555)
        flag = (flag & 0x3333) + ((flag >> 2) & 0x3333)
        flag = (flag & 0x0f0f) + ((flag >> 4) & 0x0f0f)
        flag = (flag & 0x00ff) + ((flag >> 8) & 0x00ff)
        weight_null = torch.tensor(flag & 1) ^ 1
        err = torch.tensor(err)
        weight_1d.bitwise_xor_(err)
        weight_1d.mul_(weight_null)

def inject_double_err_vapi(  weight  : torch.Tensor, 
                            p       : float, 
                            n       : int, 
                            bch, 
                            mask):
    with torch.no_grad():
        size = torch.numel(weight)
        err_origin = np.random.binomial(1, p, size * 16)
        err_idx = np.nonzero(err_origin)[0]

        err_unpacked = np.zeros(size * 16 + 8, dtype=np.uint8)

        err_unpacked[err_idx] = 1
        err_unpacked[err_idx + 1] = 1

        err = np.packbits(err_unpacked[:size * 16])
        err_to_weight = err.reshape(-1,16)[:,:8].reshape(-1)
        err_to_weight_unpacked = np.unpackbits(err_to_weight).reshape(-1, 8 * 8)
        err_occur = np.zeros((size // 8, 64), dtype=np.uint8)

        b = bch.decode(err_to_weight_unpacked).reshape(-1,50)
        err_occur[:,::8] = b[:,:48:6]    # 10011111
        err_occur[:, 0+3: 0+3+5] = b[:, 0+1: 0+1+5]
        err_occur[:, 8+3: 8+3+5] = b[:, 6+1: 6+1+5]
        err_occur[:,16+3:16+3+5] = b[:,12+1:12+1+5]
        err_occur[:,24+3:24+3+5] = b[:,18+1:18+1+5]
        err_occur[:,32+3:32+3+5] = b[:,24+1:24+1+5]
        err_occur[:,40+3:40+3+5] = b[:,30+1:30+1+5]
        err_occur[:,48+3:48+3+5] = b[:,36+1:36+1+5]
        err_occur[:,56+1:64    ] = b[:,42+1:50    ]
        err_occur = np.packbits(err_occur)
        err_tensor = torch.tensor(err_occur).reshape(weight.reshape(-1,8).shape)

        scale = 128 / (2 ** n)
        weight_clip = torch.clip(weight,min=-(2 **n),max=(2 ** n)).reshape(-1,8)
        sign = (weight_clip < 0).int() ^ ((err_tensor & 0x80) >> 7)
        value = torch.abs(weight_clip).reshape(-1,8)
        value_temp = torch.round(value * scale).int() ^ (err_tensor & 0x7f)
        det  = (value_temp < 32 ) * 128 + (value_temp - 32)
        idx  = torch.argmin(det, dim=1)

        mask = torch.eye(8,dtype=torch.uint8)[idx] | (value < 0.5)
        value_temp = (value_temp & 0xfc) + (value_temp & 0x3) * mask
        weight[:] = ((sign.reshape(weight.shape) * (-2) + 1) * value_temp.reshape(weight.shape) / scale)

def inject_double_err_squid(weight   : torch.Tensor, 
                        p       : float, 
                        n       : int, 
                        encode_lut, 
                        decode_lut, 
                        rs, 
                        mask,
                        is_ch_quant):
    with torch.no_grad():
        # Do quantization with n-bit
        if is_ch_quant:
            weight_q, scale, zero_p = quantize_channel(weight, n)
        else:
            weight_q, scale, zero_p = quantize_layer(weight, n)
        
        # Generate VPs and PPs
        weight_q_np = weight_q.view(torch.uint8).view(-1,8).detach().numpy()
        weight_q_unpacked = np.unpackbits(weight_q_np).reshape(-1,8)
        weight_q_weighted = weight_q_unpacked * encode_lut
        vp = np.bitwise_xor.reduce(weight_q_weighted, axis=1)
        pp = rs.encode(vp.reshape(-1,8))[:,8:]

        # Memory Error Occurred to quantized weight and PP
        size = torch.numel(weight_q)
        err_origin = np.random.binomial(1, p, size * 16)
        err_idx = np.nonzero(err_origin)[0]
        err_unpacked = np.zeros(size * 16 + 8, dtype=np.uint8)
        err_unpacked[err_idx] = 1
        err_unpacked[err_idx + 1] = 1
        err = np.packbits(err_unpacked[:size * 16]) & mask
        err_to_weight = err.reshape(-1,16)[:,:8]
        err_to_parity = err.reshape(-1,16)[:,8: 24 - 2 * n]
        weight_w_err = weight_q_np ^ err_to_weight
        pp_w_err = pp ^  (err_to_parity & 0xf)

        # During Decoding, first generate VPs which might be disrupted
        received_blk = np.zeros((size // 8, 24 - 2 * n), dtype = np.uint8)  
        weight_w_err_unpacked = np.unpackbits(weight_w_err).reshape(-1,8)
        weight_w_err_weighted = weight_w_err_unpacked * encode_lut
        vp_w_err = np.bitwise_xor.reduce(weight_w_err_weighted, axis=1)
        vp_w_err = vp_w_err.reshape(-1,8)

        # With PPs, recover the VP
        received_blk[:,:8] = vp_w_err
        received_blk[:,8:] = pp_w_err
        recover_vp = rs.decode(received_blk)

        # Recover the Weight
        err_predicted = decode_lut[recover_vp ^ vp_w_err]
        err_recovered = err_to_weight.reshape(-1) ^ err_predicted.reshape(-1)
        err_recovered_tensor = torch.tensor(err_recovered)
        weight_q_1d = weight_q.view(-1)
        weight_q_1d.bitwise_xor_(err_recovered_tensor)

        # Dequantize the weight for inference test for ease
        if is_ch_quant:
            weight[:] = dequantize_channel(weight_q, scale, zero_p)
        else:
            weight[:] = dequantize_layer(weight_q, scale, zero_p)

def inject_triple_err_wn(weight : torch.Tensor, p: float):
    with torch.no_grad():
        weight_1d = weight.view(torch.int16).view((-1,))
        weight_1d &= 0xfffe
        size = torch.numel(weight_1d)

        err_origin = np.random.binomial(1, p, size * 16)
        err_idx = np.nonzero(err_origin)[0]
        err_unpacked = np.zeros(size * 16 + 8, dtype=np.uint8)
        err_unpacked[err_idx]   = 1
        err_unpacked[err_idx+1] = 1
        err_unpacked[err_idx+2] = 1
        err = np.packbits(err_unpacked[:size * 16]).view(np.int16)
        
        flag = (err & 0x5555) + ((err >> 1) & 0x5555)
        flag = (flag & 0x3333) + ((flag >> 2) & 0x3333)
        flag = (flag & 0x0f0f) + ((flag >> 4) & 0x0f0f)
        flag = (flag & 0x00ff) + ((flag >> 8) & 0x00ff)
        weight_null = torch.tensor(flag & 1) ^ 1
        err = torch.tensor(err)
        weight_1d.bitwise_xor_(err)
        weight_1d.mul_(weight_null)

def inject_triple_err_vapi(  weight  : torch.Tensor, 
                            p       : float, 
                            n       : int, 
                            bch, 
                            mask):
    with torch.no_grad():
        size = torch.numel(weight)
        err_origin = np.random.binomial(1, p, size * 16)
        err_idx = np.nonzero(err_origin)[0]

        err_unpacked = np.zeros(size * 16 + 8, dtype=np.uint8)

        err_unpacked[err_idx] = 1
        err_unpacked[err_idx + 1] = 1
        err_unpacked[err_idx + 2] = 1

        err = np.packbits(err_unpacked[:size * 16])
        err_to_weight = err.reshape(-1,16)[:,:8].reshape(-1)
        err_to_weight_unpacked = np.unpackbits(err_to_weight).reshape(-1, 8 * 8)
        err_occur = np.zeros((size // 8, 64), dtype=np.uint8)

        b = bch.decode(err_to_weight_unpacked).reshape(-1,50)
        err_occur[:,::8] = b[:,:48:6]    # 10011111
        err_occur[:, 0+3: 0+3+5] = b[:, 0+1: 0+1+5]
        err_occur[:, 8+3: 8+3+5] = b[:, 6+1: 6+1+5]
        err_occur[:,16+3:16+3+5] = b[:,12+1:12+1+5]
        err_occur[:,24+3:24+3+5] = b[:,18+1:18+1+5]
        err_occur[:,32+3:32+3+5] = b[:,24+1:24+1+5]
        err_occur[:,40+3:40+3+5] = b[:,30+1:30+1+5]
        err_occur[:,48+3:48+3+5] = b[:,36+1:36+1+5]
        err_occur[:,56+1:64    ] = b[:,42+1:50    ]
        err_occur = np.packbits(err_occur)
        err_tensor = torch.tensor(err_occur).reshape(weight.reshape(-1,8).shape)

        scale = 128 / (2 ** n)
        weight_clip = torch.clip(weight,min=-(2 **n),max=(2 ** n)).reshape(-1,8)
        sign = (weight_clip < 0).int() ^ ((err_tensor & 0x80) >> 7)
        value = torch.abs(weight_clip).reshape(-1,8)
        value_temp = torch.round(value * scale).int() ^ (err_tensor & 0x7f)
        det  = (value_temp < 32 ) * 128 + (value_temp - 32)
        idx  = torch.argmin(det, dim=1)

        mask = torch.eye(8,dtype=torch.uint8)[idx] | (value < 0.5)
        value_temp = (value_temp & 0xfc) + (value_temp & 0x3) * mask
        weight[:] = ((sign.reshape(weight.shape) * (-2) + 1) * value_temp.reshape(weight.shape) / scale)

def inject_triple_err_squid(weight   : torch.Tensor, 
                        p       : float, 
                        n       : int, 
                        encode_lut, 
                        decode_lut, 
                        rs, 
                        mask,
                        is_ch_quant):
    with torch.no_grad():
        # Do quantization with n-bit
        if is_ch_quant:
            weight_q, scale, zero_p = quantize_channel(weight, n)
        else:
            weight_q, scale, zero_p = quantize_layer(weight, n)
        
        # Generate VPs and PPs
        weight_q_np = weight_q.view(torch.uint8).view(-1,8).detach().numpy()
        weight_q_unpacked = np.unpackbits(weight_q_np).reshape(-1,8)
        weight_q_weighted = weight_q_unpacked * encode_lut
        vp = np.bitwise_xor.reduce(weight_q_weighted, axis=1)
        pp = rs.encode(vp.reshape(-1,8))[:,8:]

        # Memory Error Occurred to quantized weight and PP
        size = torch.numel(weight_q)
        err_origin = np.random.binomial(1, p, size * 16)
        err_idx = np.nonzero(err_origin)[0]
        err_unpacked = np.zeros(size * 16 + 8, dtype=np.uint8)
        err_unpacked[err_idx] = 1
        err_unpacked[err_idx + 1] = 1
        err_unpacked[err_idx + 2] = 1
        err = np.packbits(err_unpacked[:size * 16]) & mask
        err_to_weight = err.reshape(-1,16)[:,:8]
        err_to_parity = err.reshape(-1,16)[:,8: 24 - 2 * n]
        weight_w_err = weight_q_np ^ err_to_weight
        pp_w_err = pp ^  (err_to_parity & 0xf)

        # During Decoding, first generate VPs which might be disrupted
        received_blk = np.zeros((size // 8, 24 - 2 * n), dtype = np.uint8)  
        weight_w_err_unpacked = np.unpackbits(weight_w_err).reshape(-1,8)
        weight_w_err_weighted = weight_w_err_unpacked * encode_lut
        vp_w_err = np.bitwise_xor.reduce(weight_w_err_weighted, axis=1)
        vp_w_err = vp_w_err.reshape(-1,8)

        # With PPs, recover the VP
        received_blk[:,:8] = vp_w_err
        received_blk[:,8:] = pp_w_err
        recover_vp = rs.decode(received_blk)

        # Recover the Weight
        err_predicted = decode_lut[recover_vp ^ vp_w_err]
        err_recovered = err_to_weight.reshape(-1) ^ err_predicted.reshape(-1)
        err_recovered_tensor = torch.tensor(err_recovered)
        weight_q_1d = weight_q.view(-1)
        weight_q_1d.bitwise_xor_(err_recovered_tensor)

        # Dequantize the weight for inference test for ease
        if is_ch_quant:
            weight[:] = dequantize_channel(weight_q, scale, zero_p)
        else:
            weight[:] = dequantize_layer(weight_q, scale, zero_p)
