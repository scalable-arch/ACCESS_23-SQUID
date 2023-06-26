module SECOND_LEVEL_DECODER(
    input [3:0] vp[7:0],
    input [3:0] pp[3:0], 
    output [3:0] recovered_vp[7:0]
); 
    wire [3:0] symbol [11:0];
    wire [3:0] syndrome[3:0];
    wire [3:0] lambda[2:0];
    wire [3:0] omega[1:0];
    wire [3:0] magnitude [7:0];
    wire [7:0] locator;


    assign symbol[7:0] = vp[7:0];
    assign symbol[11:8] = pp[3:0];

    SYNDROME_GENERATOR syndrome_generator(vp, pp, syndrome);
    RIBM ribm(syndrome, lambda, omega);
    CHIEN chien(lambda, locator);
    FORNEY forney(lambda[1], omega, magnitude);

    assign recovered_vp[0] = (locator[0]) ? vp[0] ^ magnitude[0] : vp[0];
    assign recovered_vp[1] = (locator[1]) ? vp[1] ^ magnitude[1] : vp[1];
    assign recovered_vp[2] = (locator[2]) ? vp[2] ^ magnitude[2] : vp[2];
    assign recovered_vp[3] = (locator[3]) ? vp[3] ^ magnitude[3] : vp[3];
    assign recovered_vp[4] = (locator[4]) ? vp[4] ^ magnitude[4] : vp[4];
    assign recovered_vp[5] = (locator[5]) ? vp[5] ^ magnitude[5] : vp[5];
    assign recovered_vp[6] = (locator[6]) ? vp[6] ^ magnitude[6] : vp[6];
    assign recovered_vp[7] = (locator[7]) ? vp[7] ^ magnitude[7] : vp[7];
endmodule