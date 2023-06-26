module RIBM(
    input [3:0] syndrome [3:0],
    output [3:0] lambda[2:0],
    output [3:0] omega[1:0]
);

    wire [3:0] delta_0[7:0];
    wire [3:0] delta_1[7:0];
    wire [3:0] delta_2[7:0];
    wire [3:0] delta_3[7:0];
    wire [3:0] delta_4[7:0];

    wire [3:0] theta_0[7:0];
    wire [3:0] theta_1[7:0];
    wire [3:0] theta_2[7:0];
    wire [3:0] theta_3[7:0];
    wire [3:0] theta_4[7:0];

    wire [4:0] k_0;
    wire [4:0] k_1;
    wire [4:0] k_2;
    wire [4:0] k_3;
    wire [4:0] k_4;

    wire [3:0] gamma_0;
    wire [3:0] gamma_1;
    wire [3:0] gamma_2;
    wire [3:0] gamma_3;
    wire [3:0] gamma_4;

    //Initialization
    assign delta_0[6] = 1;
    assign delta_0[5] = 0;
    assign delta_0[4] = 0;
    assign theta_0[6] = 1;
    assign theta_0[5] = 0;
    assign theta_0[4] = 0;
    assign k_0 = 8;
    assign gamma_0 = 1;

    assign delta_0[7] = 0;
    assign delta_1[7] = 0;
    assign delta_2[7] = 0;
    assign delta_3[7] = 0;
    assign delta_4[7] = 0;

    //Input
    assign delta_0[3] = syndrome[3];
    assign delta_0[2] = syndrome[2];
    assign delta_0[1] = syndrome[1];
    assign delta_0[0] = syndrome[0];

    assign theta_0[3] = syndrome[3];
    assign theta_0[2] = syndrome[2];
    assign theta_0[1] = syndrome[1];
    assign theta_0[0] = syndrome[0];

    //********* r = 0, r+1 = 1

    //Step 1
    wire [3:0] imm_0_0[6:0];
    wire [3:0] imm_1_0[6:0];

    GFMULT gfmult_000(gamma_0, delta_0[1], imm_0_0[0]);
    GFMULT gfmult_010(gamma_0, delta_0[2], imm_0_0[1]);
    GFMULT gfmult_020(gamma_0, delta_0[3], imm_0_0[2]);
    GFMULT gfmult_030(gamma_0, delta_0[4], imm_0_0[3]);
    GFMULT gfmult_040(gamma_0, delta_0[5], imm_0_0[4]);
    GFMULT gfmult_050(gamma_0, delta_0[6], imm_0_0[5]);
    GFMULT gfmult_060(gamma_0, delta_0[7], imm_0_0[6]);

    GFMULT gfmult_001(delta_0[0], theta_0[0], imm_1_0[0]);
    GFMULT gfmult_011(delta_0[0], theta_0[1], imm_1_0[1]);
    GFMULT gfmult_021(delta_0[0], theta_0[2], imm_1_0[2]);
    GFMULT gfmult_031(delta_0[0], theta_0[3], imm_1_0[3]);
    GFMULT gfmult_041(delta_0[0], theta_0[4], imm_1_0[4]);
    GFMULT gfmult_051(delta_0[0], theta_0[5], imm_1_0[5]);
    GFMULT gfmult_061(delta_0[0], theta_0[6], imm_1_0[6]);

    assign delta_1[0] = imm_0_0[0] ^ imm_1_0[0];
    assign delta_1[1] = imm_0_0[1] ^ imm_1_0[1];
    assign delta_1[2] = imm_0_0[2] ^ imm_1_0[2];
    assign delta_1[3] = imm_0_0[3] ^ imm_1_0[3];
    assign delta_1[4] = imm_0_0[4] ^ imm_1_0[4];
    assign delta_1[5] = imm_0_0[5] ^ imm_1_0[5];
    assign delta_1[6] = imm_0_0[6] ^ imm_1_0[6];

    //Step 2
    assign cond_0 = (delta_0[0] != 0) && (k_0[3] == 1);
    assign theta_1[0] = cond_0 ? delta_0[1] : theta_0[0];
    assign theta_1[1] = cond_0 ? delta_0[2] : theta_0[1];
    assign theta_1[2] = cond_0 ? delta_0[3] : theta_0[2];
    assign theta_1[3] = cond_0 ? delta_0[4] : theta_0[3];
    assign theta_1[4] = cond_0 ? delta_0[5] : theta_0[4];
    assign theta_1[5] = cond_0 ? delta_0[6] : theta_0[5];
    assign theta_1[6] = cond_0 ? delta_0[7] : theta_0[6];
    assign gamma_1 = cond_0 ? delta_0[0] : gamma_0;
    assign k_1 = cond_0? ~k_0 : k_0 + 1;


    //********* r = 1, r+1 = 2

    //Step 1
    wire [3:0] imm_0_1[6:0];
    wire [3:0] imm_1_1[6:0];

    GFMULT gfmult_100(gamma_1, delta_1[1], imm_0_1[0]);
    GFMULT gfmult_110(gamma_1, delta_1[2], imm_0_1[1]);
    GFMULT gfmult_120(gamma_1, delta_1[3], imm_0_1[2]);
    GFMULT gfmult_130(gamma_1, delta_1[4], imm_0_1[3]);
    GFMULT gfmult_140(gamma_1, delta_1[5], imm_0_1[4]);
    GFMULT gfmult_150(gamma_1, delta_1[6], imm_0_1[5]);
    GFMULT gfmult_160(gamma_1, delta_1[7], imm_0_1[6]);

    GFMULT gfmult_101(delta_1[0], theta_1[0], imm_1_1[0]);
    GFMULT gfmult_111(delta_1[0], theta_1[1], imm_1_1[1]);
    GFMULT gfmult_121(delta_1[0], theta_1[2], imm_1_1[2]);
    GFMULT gfmult_131(delta_1[0], theta_1[3], imm_1_1[3]);
    GFMULT gfmult_141(delta_1[0], theta_1[4], imm_1_1[4]);
    GFMULT gfmult_151(delta_1[0], theta_1[5], imm_1_1[5]);
    GFMULT gfmult_161(delta_1[0], theta_1[6], imm_1_1[6]);

    assign delta_2[0] = imm_0_1[0] ^ imm_1_1[0];
    assign delta_2[1] = imm_0_1[1] ^ imm_1_1[1];
    assign delta_2[2] = imm_0_1[2] ^ imm_1_1[2];
    assign delta_2[3] = imm_0_1[3] ^ imm_1_1[3];
    assign delta_2[4] = imm_0_1[4] ^ imm_1_1[4];
    assign delta_2[5] = imm_0_1[5] ^ imm_1_1[5];
    assign delta_2[6] = imm_0_1[6] ^ imm_1_1[6];

    //Step 2
    assign cond_1 = (delta_1[0] != 0) && (k_1[3] == 1);
    assign theta_2[0] = cond_1 ? delta_1[1] : theta_1[0];
    assign theta_2[1] = cond_1 ? delta_1[2] : theta_1[1];
    assign theta_2[2] = cond_1 ? delta_1[3] : theta_1[2];
    assign theta_2[3] = cond_1 ? delta_1[4] : theta_1[3];
    assign theta_2[4] = cond_1 ? delta_1[5] : theta_1[4];
    assign theta_2[5] = cond_1 ? delta_1[6] : theta_1[5];
    assign theta_2[6] = cond_1 ? delta_1[7] : theta_1[6];
    assign gamma_2 = cond_1 ? delta_1[0] : gamma_1;
    assign k_2 = cond_1? ~k_1 : k_1 + 1;


    //********* r = 2, r+1 = 3

    //Step 1
    wire [3:0] imm_0_2[6:0];
    wire [3:0] imm_1_2[6:0];

    GFMULT gfmult_200(gamma_2, delta_2[1], imm_0_2[0]);
    GFMULT gfmult_210(gamma_2, delta_2[2], imm_0_2[1]);
    GFMULT gfmult_220(gamma_2, delta_2[3], imm_0_2[2]);
    GFMULT gfmult_230(gamma_2, delta_2[4], imm_0_2[3]);
    GFMULT gfmult_240(gamma_2, delta_2[5], imm_0_2[4]);
    GFMULT gfmult_250(gamma_2, delta_2[6], imm_0_2[5]);
    GFMULT gfmult_260(gamma_2, delta_2[7], imm_0_2[6]);

    GFMULT gfmult_201(delta_2[0], theta_2[0], imm_1_2[0]);
    GFMULT gfmult_211(delta_2[0], theta_2[1], imm_1_2[1]);
    GFMULT gfmult_221(delta_2[0], theta_2[2], imm_1_2[2]);
    GFMULT gfmult_231(delta_2[0], theta_2[3], imm_1_2[3]);
    GFMULT gfmult_241(delta_2[0], theta_2[4], imm_1_2[4]);
    GFMULT gfmult_251(delta_2[0], theta_2[5], imm_1_2[5]);
    GFMULT gfmult_261(delta_2[0], theta_2[6], imm_1_2[6]);

    assign delta_3[0] = imm_0_2[0] ^ imm_1_2[0];
    assign delta_3[1] = imm_0_2[1] ^ imm_1_2[1];
    assign delta_3[2] = imm_0_2[2] ^ imm_1_2[2];
    assign delta_3[3] = imm_0_2[3] ^ imm_1_2[3];
    assign delta_3[4] = imm_0_2[4] ^ imm_1_2[4];
    assign delta_3[5] = imm_0_2[5] ^ imm_1_2[5];
    assign delta_3[6] = imm_0_2[6] ^ imm_1_2[6];

    //Step 2
    assign cond_2 = (delta_2[0] != 0) && (k_2[3] == 1);
    assign theta_3[0] = cond_2 ? delta_2[1] : theta_2[0];
    assign theta_3[1] = cond_2 ? delta_2[2] : theta_2[1];
    assign theta_3[2] = cond_2 ? delta_2[3] : theta_2[2];
    assign theta_3[3] = cond_2 ? delta_2[4] : theta_2[3];
    assign theta_3[4] = cond_2 ? delta_2[5] : theta_2[4];
    assign theta_3[5] = cond_2 ? delta_2[6] : theta_2[5];
    assign theta_3[6] = cond_2 ? delta_2[7] : theta_2[6];
    assign gamma_3 = cond_2 ? delta_2[0] : gamma_2;
    assign k_3 = cond_2? ~k_2 : k_2 + 1;


    //********* r = 3, r+1 = 4

    //Step 1
    wire [3:0] imm_0_3[6:0];
    wire [3:0] imm_1_3[6:0];

    GFMULT gfmult_300(gamma_3, delta_3[1], imm_0_3[0]);
    GFMULT gfmult_310(gamma_3, delta_3[2], imm_0_3[1]);
    GFMULT gfmult_320(gamma_3, delta_3[3], imm_0_3[2]);
    GFMULT gfmult_330(gamma_3, delta_3[4], imm_0_3[3]);
    GFMULT gfmult_340(gamma_3, delta_3[5], imm_0_3[4]);
    GFMULT gfmult_350(gamma_3, delta_3[6], imm_0_3[5]);
    GFMULT gfmult_360(gamma_3, delta_3[7], imm_0_3[6]);

    GFMULT gfmult_301(delta_3[0], theta_3[0], imm_1_3[0]);
    GFMULT gfmult_311(delta_3[0], theta_3[1], imm_1_3[1]);
    GFMULT gfmult_321(delta_3[0], theta_3[2], imm_1_3[2]);
    GFMULT gfmult_331(delta_3[0], theta_3[3], imm_1_3[3]);
    GFMULT gfmult_341(delta_3[0], theta_3[4], imm_1_3[4]);
    GFMULT gfmult_351(delta_3[0], theta_3[5], imm_1_3[5]);
    GFMULT gfmult_361(delta_3[0], theta_3[6], imm_1_3[6]);

    assign delta_4[0] = imm_0_3[0] ^ imm_1_3[0];
    assign delta_4[1] = imm_0_3[1] ^ imm_1_3[1];
    assign delta_4[2] = imm_0_3[2] ^ imm_1_3[2];
    assign delta_4[3] = imm_0_3[3] ^ imm_1_3[3];
    assign delta_4[4] = imm_0_3[4] ^ imm_1_3[4];
    assign delta_4[5] = imm_0_3[5] ^ imm_1_3[5];
    assign delta_4[6] = imm_0_3[6] ^ imm_1_3[6];

    //Step 2
    assign cond_3 = (delta_3[0] != 0) && (k_3[3] == 1);
    assign theta_4[0] = cond_3 ? delta_3[1] : theta_3[0];
    assign theta_4[1] = cond_3 ? delta_3[2] : theta_3[1];
    assign theta_4[2] = cond_3 ? delta_3[3] : theta_3[2];
    assign theta_4[3] = cond_3 ? delta_3[4] : theta_3[3];
    assign theta_4[4] = cond_3 ? delta_3[5] : theta_3[4];
    assign theta_4[5] = cond_3 ? delta_3[6] : theta_3[5];
    assign theta_4[6] = cond_3 ? delta_3[7] : theta_3[6];
    assign gamma_4 = cond_3 ? delta_3[0] : gamma_3;
    assign k_4 = cond_3? ~k_3 : k_3 + 1;

    assign lambda[0] = delta_4[2];
    assign lambda[1] = delta_4[3];
    assign lambda[2] = delta_4[4];

    assign omega[0] = delta_4[0];
    assign omega[1] = delta_4[1];

endmodule