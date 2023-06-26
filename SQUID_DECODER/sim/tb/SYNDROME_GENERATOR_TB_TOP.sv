module GFMULT_TOP_TB;
    reg [5:0] weight [7:0];
    reg [3:0] parity [3:0];
    wire [5:0] result [7:0];
    wire [5:0] vp_temp [7:0];  
    SQUID_DECODER dut(weight, parity, result);
    initial
    begin 
        weight[0] <= 6'd3;
        weight[1] <= 6'd23;
        weight[2] <= 6'd1 ;
        weight[3] <= 6'd10;
        weight[4] <= 6'd14;
        weight[5] <= 6'd48; // 32
        weight[6] <= 6'd60;
        weight[7] <= 6'd23; // 17
        parity[0] <= 4'd13;
        parity[1] <= 4'd6;
        parity[2] <= 4'd12;
        parity[3] <= 4'd11;
        #1
        $display(result); //'{'h11, 'h3c, 'h20, 'he, 'ha, 'h1, 'h17, 'h3} 
        //$display(vp_temp);
    end

endmodule
