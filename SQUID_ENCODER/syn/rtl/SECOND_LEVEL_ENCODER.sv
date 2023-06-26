module SECOND_LEVEL_ENCODER(
    input [3:0] vp[7:0], 
    output [3:0] pp[3:0]
); 

    wire [3:0] pp_ac_0[7:0];
    wire [3:0] pp_ac_1[7:0];
    wire [3:0] pp_ac_2[7:0];
    wire [3:0] pp_ac_3[7:0];

    GFMULT gmult_00(vp[7],4'd6 ,pp_ac_0[7]);
    GFMULT gmult_01(vp[6],4'd5 ,pp_ac_0[6]);
    GFMULT gmult_02(vp[5],4'd13,pp_ac_0[5]);
    GFMULT gmult_03(vp[4],4'd6 ,pp_ac_0[4]);
    GFMULT gmult_04(vp[3],4'd14,pp_ac_0[3]);
    GFMULT gmult_05(vp[2],4'd14,pp_ac_0[2]);
    GFMULT gmult_06(vp[1],4'd5 ,pp_ac_0[1]);
    GFMULT gmult_07(vp[0],4'd7 ,pp_ac_0[0]);

    GFMULT gmult_10(vp[7],4'd8 ,pp_ac_1[7]);
    GFMULT gmult_11(vp[6],4'd15,pp_ac_1[6]);
    GFMULT gmult_12(vp[5],4'd10,pp_ac_1[5]);
    GFMULT gmult_13(vp[4],4'd3 ,pp_ac_1[4]);
    GFMULT gmult_14(vp[3],4'd13,pp_ac_1[3]);
    GFMULT gmult_15(vp[2],4'd6 ,pp_ac_1[2]);
    GFMULT gmult_16(vp[1],4'd5 ,pp_ac_1[1]);
    GFMULT gmult_17(vp[0],4'd8 ,pp_ac_1[0]);

    GFMULT gmult_20(vp[7],4'd13,pp_ac_2[7]);
    GFMULT gmult_21(vp[6],4'd9 ,pp_ac_2[6]);
    GFMULT gmult_22(vp[5],4'd9 ,pp_ac_2[5]);
    GFMULT gmult_23(vp[4],4'd15,pp_ac_2[4]);
    GFMULT gmult_24(vp[3],4'd13,pp_ac_2[3]);
    GFMULT gmult_25(vp[2],4'd14,pp_ac_2[2]);
    GFMULT gmult_26(vp[1],4'd11,pp_ac_2[1]);
    GFMULT gmult_27(vp[0],4'd12,pp_ac_2[0]);

    GFMULT gmult_30(vp[7],4'd12,pp_ac_3[7]);
    GFMULT gmult_31(vp[6],4'd7 ,pp_ac_3[6]);
    GFMULT gmult_32(vp[5],4'd13,pp_ac_3[5]);
    GFMULT gmult_33(vp[4],4'd8 ,pp_ac_3[4]);
    GFMULT gmult_34(vp[3],4'd7 ,pp_ac_3[3]);
    GFMULT gmult_35(vp[2],4'd2 ,pp_ac_3[2]);
    GFMULT gmult_36(vp[1],4'd2 ,pp_ac_3[1]);
    GFMULT gmult_37(vp[0],4'd13,pp_ac_3[0]);

    assign pp[0] = pp_ac_0[7] ^ pp_ac_0[6] ^ pp_ac_0[5] ^ pp_ac_0[4] ^ pp_ac_0[3] ^ pp_ac_0[2] ^ pp_ac_0[1] ^ pp_ac_0[0];
    assign pp[1] = pp_ac_1[7] ^ pp_ac_1[6] ^ pp_ac_1[5] ^ pp_ac_1[4] ^ pp_ac_1[3] ^ pp_ac_1[2] ^ pp_ac_1[1] ^ pp_ac_1[0];
    assign pp[2] = pp_ac_2[7] ^ pp_ac_2[6] ^ pp_ac_2[5] ^ pp_ac_2[4] ^ pp_ac_2[3] ^ pp_ac_2[2] ^ pp_ac_2[1] ^ pp_ac_2[0];
    assign pp[3] = pp_ac_3[7] ^ pp_ac_3[6] ^ pp_ac_3[5] ^ pp_ac_3[4] ^ pp_ac_3[3] ^ pp_ac_3[2] ^ pp_ac_3[1] ^ pp_ac_3[0];

endmodule