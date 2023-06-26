module GFMULT_TOP_TB;
    reg [5:0] weight[7:0];
    wire [3:0] pp[3:0];
    wire [3:0] pppp[3:0];
    wire [3:0] vp[7:0];
    SQUID_ENCODER dut(weight, pp);
    FIRST_LEVEL_ENCODER enc0(weight[0], vp[0]);
    FIRST_LEVEL_ENCODER enc1(weight[1], vp[1]);
    FIRST_LEVEL_ENCODER enc2(weight[2], vp[2]);
    FIRST_LEVEL_ENCODER enc3(weight[3], vp[3]);
    FIRST_LEVEL_ENCODER enc4(weight[4], vp[4]);
    FIRST_LEVEL_ENCODER enc5(weight[5], vp[5]);
    FIRST_LEVEL_ENCODER enc6(weight[6], vp[6]);
    FIRST_LEVEL_ENCODER enc7(weight[7], vp[7]);
    SECOND_LEVEL_ENCODER enc(vp, pppp);
    initial
    begin 
        weight[0] <= 6'd3;
        weight[1] <= 6'd23;
        weight[2] <= 6'd1 ;
        weight[3] <= 6'd10;
        weight[4] <= 6'd14;
        weight[5] <= 6'd32;
        weight[6] <= 6'd60;
        weight[7] <= 6'd17;
        #1
        $display(vp);
        $display(pp);
        $display(pppp);

    end

endmodule