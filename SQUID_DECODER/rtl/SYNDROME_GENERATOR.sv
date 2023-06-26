module SYNDROME_GENERATOR(
    input [3:0] vp[7:0],
    input [3:0] pp[3:0], 
    output [3:0] syn[3:0]
);

    wire [3:0] syn_ac_3[11:0];
    wire [3:0] syn_ac_2[11:0];
    wire [3:0] syn_ac_1[11:0];
    wire [3:0] syn_ac_0[11:0];


    GFMULT gmult_00(vp[0] ,4'd14,syn_ac_3[11]);
    GFMULT gmult_01(vp[1] ,4'd11,syn_ac_3[10]);
    GFMULT gmult_02(vp[2] ,4'd8 ,syn_ac_3[9]);
    GFMULT gmult_03(vp[3] ,4'd9 ,syn_ac_3[8]);
    GFMULT gmult_04(vp[4] ,4'd7 ,syn_ac_3[7]);
    GFMULT gmult_05(vp[5] ,4'd12,syn_ac_3[6]);
    GFMULT gmult_06(vp[6] ,4'd4 ,syn_ac_3[5]);
    GFMULT gmult_07(vp[7] ,4'd13,syn_ac_3[4]);
    GFMULT gmult_08(pp[0] ,4'd10,syn_ac_3[3]);
    GFMULT gmult_09(pp[1] ,4'd6 ,syn_ac_3[2]);
    GFMULT gmult_0a(pp[2] ,4'd2 ,syn_ac_3[1]);
    GFMULT gmult_0b(pp[3] ,4'd15,syn_ac_3[0]);

    GFMULT gmult_10(vp[0] ,4'd15,syn_ac_2[11]);
    GFMULT gmult_11(vp[1] ,4'd10,syn_ac_2[10]);
    GFMULT gmult_12(vp[2] ,4'd12,syn_ac_2[9]);
    GFMULT gmult_13(vp[3] ,4'd8 ,syn_ac_2[8]);
    GFMULT gmult_14(vp[4] ,4'd1 ,syn_ac_2[7]);
    GFMULT gmult_15(vp[5] ,4'd15,syn_ac_2[6]);
    GFMULT gmult_16(vp[6] ,4'd10,syn_ac_2[5]);
    GFMULT gmult_17(vp[7] ,4'd12,syn_ac_2[4]);
    GFMULT gmult_18(pp[0] ,4'd8 ,syn_ac_2[3]);
    GFMULT gmult_19(pp[1] ,4'd1 ,syn_ac_2[2]);
    GFMULT gmult_1a(pp[2] ,4'd15,syn_ac_2[1]);
    GFMULT gmult_1b(pp[3] ,4'd10,syn_ac_2[0]);


    GFMULT gmult_20(vp[0], 4'd13,syn_ac_1[11]);
    GFMULT gmult_21(vp[1], 4'd14,syn_ac_1[10]);
    GFMULT gmult_22(vp[2], 4'd10,syn_ac_1[9]);
    GFMULT gmult_23(vp[3], 4'd11,syn_ac_1[8]);
    GFMULT gmult_24(vp[4], 4'd6 ,syn_ac_1[7]);
    GFMULT gmult_25(vp[5], 4'd8,syn_ac_1[6]);
    GFMULT gmult_26(vp[6], 4'd2 ,syn_ac_1[5]);
    GFMULT gmult_27(vp[7], 4'd9 ,syn_ac_1[4]);
    GFMULT gmult_28(pp[0], 4'd15,syn_ac_1[3]);
    GFMULT gmult_29(pp[1], 4'd7 ,syn_ac_1[2]);
    GFMULT gmult_2a(pp[2], 4'd5 ,syn_ac_1[1]);
    GFMULT gmult_2b(pp[3], 4'd12,syn_ac_1[0]);

    GFMULT gmult_30(vp[0] ,4'd9 ,syn_ac_0[11]);
    GFMULT gmult_31(vp[1] ,4'd13,syn_ac_0[10]);
    GFMULT gmult_32(vp[2] ,4'd15,syn_ac_0[9]);
    GFMULT gmult_33(vp[3] ,4'd14,syn_ac_0[8]);
    GFMULT gmult_34(vp[4] ,4'd7 ,syn_ac_0[7]);
    GFMULT gmult_35(vp[5] ,4'd10,syn_ac_0[6]);
    GFMULT gmult_36(vp[6] ,4'd5 ,syn_ac_0[5]);
    GFMULT gmult_37(vp[7] ,4'd11,syn_ac_0[4]);
    GFMULT gmult_38(pp[0] ,4'd12,syn_ac_0[3]);
    GFMULT gmult_39(pp[1] ,4'd6 ,syn_ac_0[2]);
    GFMULT gmult_3a(pp[2] ,4'd3 ,syn_ac_0[1]);
    GFMULT gmult_3b(pp[3] ,4'd8 ,syn_ac_0[0]);

    assign syn[0] = syn_ac_0[11] ^ syn_ac_0[10] ^ syn_ac_0[9] ^ syn_ac_0[8] ^ syn_ac_0[7] ^ syn_ac_0[6] ^ syn_ac_0[5] ^ syn_ac_0[4] ^ syn_ac_0[3] ^ syn_ac_0[2] ^ syn_ac_0[1] ^ syn_ac_0[0];
    assign syn[1] = syn_ac_1[11] ^ syn_ac_1[10] ^ syn_ac_1[9] ^ syn_ac_1[8] ^ syn_ac_1[7] ^ syn_ac_1[6] ^ syn_ac_1[5] ^ syn_ac_1[4] ^ syn_ac_1[3] ^ syn_ac_1[2] ^ syn_ac_1[1] ^ syn_ac_1[0];
    assign syn[2] = syn_ac_2[11] ^ syn_ac_2[10] ^ syn_ac_2[9] ^ syn_ac_2[8] ^ syn_ac_2[7] ^ syn_ac_2[6] ^ syn_ac_2[5] ^ syn_ac_2[4] ^ syn_ac_2[3] ^ syn_ac_2[2] ^ syn_ac_2[1] ^ syn_ac_2[0];
    assign syn[3] = syn_ac_3[11] ^ syn_ac_3[10] ^ syn_ac_3[9] ^ syn_ac_3[8] ^ syn_ac_3[7] ^ syn_ac_3[6] ^ syn_ac_3[5] ^ syn_ac_3[4] ^ syn_ac_3[3] ^ syn_ac_3[2] ^ syn_ac_3[1] ^ syn_ac_3[0];

endmodule