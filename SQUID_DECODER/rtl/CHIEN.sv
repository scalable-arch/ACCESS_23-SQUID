module CHIEN(
    input [3:0] lambda[2:0],
    output [7:0] locator 
);

    wire [3:0] imm_0[7:0]; //[11:0];
    wire [3:0] imm_1[7:0]; //[11:0];
    wire [3:0] imm_2[7:0]; //[11:0];

    GFMULT gfmult_000(lambda[0], 4'd1,imm_0[0]);
    GFMULT gfmult_001(lambda[1], 4'd2,imm_1[0]);
    GFMULT gfmult_002(lambda[2], 4'd4,imm_2[0]);

    GFMULT gfmult_010(lambda[0], 4'd1,imm_0[1]);
    GFMULT gfmult_011(lambda[1], 4'd4,imm_1[1]);
    GFMULT gfmult_012(lambda[2], 4'd3,imm_2[1]);

    GFMULT gfmult_020(lambda[0], 4'd1,imm_0[2]);
    GFMULT gfmult_021(lambda[1], 4'd8,imm_1[2]);
    GFMULT gfmult_022(lambda[2],4'd12,imm_2[2]);

    GFMULT gfmult_030(lambda[0], 4'd1,imm_0[3]);
    GFMULT gfmult_031(lambda[1], 4'd3,imm_1[3]);
    GFMULT gfmult_032(lambda[2], 4'd5,imm_2[3]);

    GFMULT gfmult_040(lambda[0], 4'd1,imm_0[4]);
    GFMULT gfmult_041(lambda[1], 4'd6,imm_1[4]);
    GFMULT gfmult_042(lambda[2], 4'd7,imm_2[4]);

    GFMULT gfmult_050(lambda[0], 4'd1,imm_0[5]);
    GFMULT gfmult_051(lambda[1],4'd12,imm_1[5]);
    GFMULT gfmult_052(lambda[2],4'd15,imm_2[5]);

    GFMULT gfmult_060(lambda[0], 4'd1,imm_0[6]);
    GFMULT gfmult_061(lambda[1],4'd11,imm_1[6]);
    GFMULT gfmult_062(lambda[2], 4'd9,imm_2[6]);

    GFMULT gfmult_070(lambda[0], 4'd1,imm_0[7]);
    GFMULT gfmult_071(lambda[1], 4'd5,imm_1[7]);
    GFMULT gfmult_072(lambda[2], 4'd2,imm_2[7]);

    // GFMULT gfmult_080(lambda[0], 4'd1,imm_0[8]);
    // GFMULT gfmult_081(lambda[1],4'd10,imm_1[8]);
    // GFMULT gfmult_082(lambda[2], 4'd8,imm_2[8]);

    // GFMULT gfmult_090(lambda[0], 4'd1,imm_0[9]);
    // GFMULT gfmult_091(lambda[1], 4'd7,imm_1[9]);
    // GFMULT gfmult_092(lambda[2], 4'd6,imm_2[9]);

    // GFMULT gfmult_100(lambda[0], 4'd1,imm_0[10]);
    // GFMULT gfmult_101(lambda[1],4'd14,imm_1[10]);
    // GFMULT gfmult_102(lambda[2],4'd11,imm_2[10]);

    // GFMULT gfmult_110(lambda[0], 4'd1,imm_0[11]);
    // GFMULT gfmult_111(lambda[1],4'd15,imm_1[11]);
    // GFMULT gfmult_112(lambda[2],4'd10,imm_2[11]);

    assign locator[0]  = ((imm_0[0]  ^ imm_1[0]  ^ imm_2[0] ) == 4'd0);
    assign locator[1]  = ((imm_0[1]  ^ imm_1[1]  ^ imm_2[1] ) == 4'd0);
    assign locator[2]  = ((imm_0[2]  ^ imm_1[2]  ^ imm_2[2] ) == 4'd0);
    assign locator[3]  = ((imm_0[3]  ^ imm_1[3]  ^ imm_2[3] ) == 4'd0);
    assign locator[4]  = ((imm_0[4]  ^ imm_1[4]  ^ imm_2[4] ) == 4'd0);
    assign locator[5]  = ((imm_0[5]  ^ imm_1[5]  ^ imm_2[5] ) == 4'd0);
    assign locator[6]  = ((imm_0[6]  ^ imm_1[6]  ^ imm_2[6] ) == 4'd0);
    assign locator[7]  = ((imm_0[7]  ^ imm_1[7]  ^ imm_2[7] ) == 4'd0);
    // assign locator[8]  = ((imm_0[8]  ^ imm_1[8]  ^ imm_2[8] ) == 4'd0);
    // assign locator[9]  = ((imm_0[9]  ^ imm_1[9]  ^ imm_2[9] ) == 4'd0);
    // assign locator[10] = ((imm_0[10] ^ imm_1[10] ^ imm_2[10]) == 4'd0);
    // assign locator[11] = ((imm_0[11] ^ imm_1[11] ^ imm_2[11]) == 4'd0);

endmodule