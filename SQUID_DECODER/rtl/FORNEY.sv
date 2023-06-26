module FORNEY(
    input [3:0] lambda,
    input [3:0] omega[1:0],
    output [3:0] magnitude[7:0] 
);

    wire [3:0] table_0[1:0];
    wire [3:0] table_1[1:0];
    wire [3:0] table_2[1:0];
    wire [3:0] table_3[1:0];
    wire [3:0] table_4[1:0];
    wire [3:0] table_5[1:0];
    wire [3:0] table_6[1:0];
    wire [3:0] table_7[1:0];

    wire [3:0] lambda_ov[7:0];
    wire [3:0] omega_v[7:0];

    wire [3:0] imm_0[7:0];
    wire [3:0] imm_1[7:0];
    wire [3:0] imm_2[7:0];

    assign table_0 = { 4'd6, 4'd3  };
    assign table_1 = { 4'd7, 4'd5  };
    assign table_2 = { 4'd1, 4'd15 };
    assign table_3 = { 4'd6, 4'd2  };
    assign table_4 = { 4'd7, 4'd6  };
    assign table_5 = { 4'd1, 4'd10};
    assign table_6 = { 4'd6, 4'd13};
    assign table_7 = { 4'd7, 4'd4 };

    GFMULT gmult_00(lambda, table_0[1], lambda_ov[0]);
    GFMULT gmult_01(lambda, table_1[1], lambda_ov[1]);
    GFMULT gmult_02(lambda, table_2[1], lambda_ov[2]);
    GFMULT gmult_03(lambda, table_3[1], lambda_ov[3]);
    GFMULT gmult_04(lambda, table_4[1], lambda_ov[4]);
    GFMULT gmult_05(lambda, table_5[1], lambda_ov[5]);
    GFMULT gmult_06(lambda, table_6[1], lambda_ov[6]);
    GFMULT gmult_07(lambda, table_7[1], lambda_ov[7]);

    GFMULT gmult_10(omega[0], table_0[0], imm_0[0]);
    GFMULT gmult_11(omega[0], table_1[0], imm_0[1]);
    GFMULT gmult_12(omega[0], table_2[0], imm_0[2]);
    GFMULT gmult_13(omega[0], table_3[0], imm_0[3]);
    GFMULT gmult_14(omega[0], table_4[0], imm_0[4]);
    GFMULT gmult_15(omega[0], table_5[0], imm_0[5]);
    GFMULT gmult_16(omega[0], table_6[0], imm_0[6]);
    GFMULT gmult_17(omega[0], table_7[0], imm_0[7]);    
    
    GFMULT gmult_20(omega[1], table_0[1], imm_1[0]);
    GFMULT gmult_21(omega[1], table_1[1], imm_1[1]);
    GFMULT gmult_22(omega[1], table_2[1], imm_1[2]);
    GFMULT gmult_23(omega[1], table_3[1], imm_1[3]);
    GFMULT gmult_24(omega[1], table_4[1], imm_1[4]);
    GFMULT gmult_25(omega[1], table_5[1], imm_1[5]);
    GFMULT gmult_26(omega[1], table_6[1], imm_1[6]);
    GFMULT gmult_27(omega[1], table_7[1], imm_1[7]);    

    assign omega_v[0] = imm_0[0] ^ imm_1[0];
    assign omega_v[1] = imm_0[1] ^ imm_1[1];
    assign omega_v[2] = imm_0[2] ^ imm_1[2];
    assign omega_v[3] = imm_0[3] ^ imm_1[3];
    assign omega_v[4] = imm_0[4] ^ imm_1[4];
    assign omega_v[5] = imm_0[5] ^ imm_1[5];
    assign omega_v[6] = imm_0[6] ^ imm_1[6];
    assign omega_v[7] = imm_0[7] ^ imm_1[7];

    GFDIV gdiv_0(omega_v[0], lambda_ov[0], imm_2[0]);
    GFDIV gdiv_1(omega_v[1], lambda_ov[1], imm_2[1]);
    GFDIV gdiv_2(omega_v[2], lambda_ov[2], imm_2[2]);
    GFDIV gdiv_3(omega_v[3], lambda_ov[3], imm_2[3]);
    GFDIV gdiv_4(omega_v[4], lambda_ov[4], imm_2[4]);
    GFDIV gdiv_5(omega_v[5], lambda_ov[5], imm_2[5]);
    GFDIV gdiv_6(omega_v[6], lambda_ov[6], imm_2[6]);
    GFDIV gdiv_7(omega_v[7], lambda_ov[7], imm_2[7]);

    GFMULT gmult_30(imm_2[0], table_0[1], magnitude[0]);
    GFMULT gmult_31(imm_2[1], table_1[1], magnitude[1]);
    GFMULT gmult_32(imm_2[2], table_2[1], magnitude[2]);
    GFMULT gmult_33(imm_2[3], table_3[1], magnitude[3]);
    GFMULT gmult_34(imm_2[4], table_4[1], magnitude[4]);
    GFMULT gmult_35(imm_2[5], table_5[1], magnitude[5]);
    GFMULT gmult_36(imm_2[6], table_6[1], magnitude[6]);
    GFMULT gmult_37(imm_2[7], table_7[1], magnitude[7]);

endmodule