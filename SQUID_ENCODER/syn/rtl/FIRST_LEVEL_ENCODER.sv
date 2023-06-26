module FIRST_LEVEL_ENCODER(weight, vp);
    input [5:0] weight;
    output [3:0]vp; 

    assign vp = {4{weight[5]}} ^ weight[4:1];

endmodule