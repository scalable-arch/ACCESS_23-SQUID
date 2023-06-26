module GFMULT_TOP_TB;
    reg [3:0] a,b;
    wire [3:0] c;

    GFMULT gfmult(a, b, c);

    integer failures;
    initial
    begin 
        failures = 0;

        a <= 9;
        b <= 4;
        #1;
        $display(a,b,c);
        a <= 14;
        b <= 9;
        #1;
        $display(a,b,c);
        
        a <= 15;
        b <= 7;
        #1;
        $display(a,b,c);
        $display("DONE");


    end

endmodule