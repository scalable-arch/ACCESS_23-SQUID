module SQUID_DECODER(
    input [5:0] weight_block_input [7:0],
    input [3:0] pp [3:0],
    output [5:0] weight_block_output[7:0]
);

    wire [3:0] vp[7:0];
    wire [3:0] vp_recovered[7:0];

    FIRST_LEVEL_ENCODER first_encoder_0(weight_block_input[0],vp[0]);
    FIRST_LEVEL_ENCODER first_encoder_1(weight_block_input[1],vp[1]);
    FIRST_LEVEL_ENCODER first_encoder_2(weight_block_input[2],vp[2]);
    FIRST_LEVEL_ENCODER first_encoder_3(weight_block_input[3],vp[3]);
    FIRST_LEVEL_ENCODER first_encoder_4(weight_block_input[4],vp[4]);
    FIRST_LEVEL_ENCODER first_encoder_5(weight_block_input[5],vp[5]);
    FIRST_LEVEL_ENCODER first_encoder_6(weight_block_input[6],vp[6]);
    FIRST_LEVEL_ENCODER first_encoder_7(weight_block_input[7],vp[7]);

    SECOND_LEVEL_DECODER second_level_decoder(vp, pp, vp_recovered);

    FIRST_LEVEL_DECODER first_decoder_0(weight_block_input[0],vp_recovered[0],weight_block_output[0]);
    FIRST_LEVEL_DECODER first_decoder_1(weight_block_input[1],vp_recovered[1],weight_block_output[1]);
    FIRST_LEVEL_DECODER first_decoder_2(weight_block_input[2],vp_recovered[2],weight_block_output[2]);
    FIRST_LEVEL_DECODER first_decoder_3(weight_block_input[3],vp_recovered[3],weight_block_output[3]);
    FIRST_LEVEL_DECODER first_decoder_4(weight_block_input[4],vp_recovered[4],weight_block_output[4]);
    FIRST_LEVEL_DECODER first_decoder_5(weight_block_input[5],vp_recovered[5],weight_block_output[5]);
    FIRST_LEVEL_DECODER first_decoder_6(weight_block_input[6],vp_recovered[6],weight_block_output[6]);
    FIRST_LEVEL_DECODER first_decoder_7(weight_block_input[7],vp_recovered[7],weight_block_output[7]);

endmodule