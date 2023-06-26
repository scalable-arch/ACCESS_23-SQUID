module FIRST_LEVEL_DECODER(
    input [5:0] weight_input,
    input [3:0] vp,
    output [5:0] weight_output
); 
    wire [3:0] syndrome;
    reg [5:0] error;
    assign syndrome[3] = weight_input[5] ^ weight_input[4] ^ vp[3];
    assign syndrome[2] = weight_input[5] ^ weight_input[3] ^ vp[2];
    assign syndrome[1] = weight_input[5] ^ weight_input[2] ^ vp[1];
    assign syndrome[0] = weight_input[5] ^ weight_input[1] ^ vp[0];

    always_comb
    case (syndrome)
        'd0:  error <= 0; 
        'd1:  error <= 2;
        'd2:  error <= 4;
        'd3:  error <= 6;
        'd4:  error <= 8;
        'd5:  error <= 10;
        'd6:  error <= 12;
        'd7:  error <= 48;
        'd8:  error <= 16;
        'd9:  error <= 18;
        'd10: error <= 20;
        'd11: error <= 40;
        'd12: error <= 24;
        'd13: error <= 36;
        'd14: error <= 34;
        'd15: error <= 32;
    endcase

    assign weight_output = weight_input ^ error;

endmodule