module SQUID_ENCODER(
    input [5:0] weight_block_input[7:0],
    output [3:0] pp[3:0]
);
    wire [3:0] vp[7:0];

    FIRST_LEVEL_ENCODER first_encoder_0(weight_block_input[0],vp[0]);
    FIRST_LEVEL_ENCODER first_encoder_1(weight_block_input[1],vp[1]);
    FIRST_LEVEL_ENCODER first_encoder_2(weight_block_input[2],vp[2]);
    FIRST_LEVEL_ENCODER first_encoder_3(weight_block_input[3],vp[3]);
    FIRST_LEVEL_ENCODER first_encoder_4(weight_block_input[4],vp[4]);
    FIRST_LEVEL_ENCODER first_encoder_5(weight_block_input[5],vp[5]);
    FIRST_LEVEL_ENCODER first_encoder_6(weight_block_input[6],vp[6]);
    FIRST_LEVEL_ENCODER first_encoder_7(weight_block_input[7],vp[7]);

    SECOND_LEVEL_ENCODER second_encoder(vp[7:0], pp[3:0]);

endmodule
