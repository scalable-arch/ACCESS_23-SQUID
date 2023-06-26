module GFDIV(a, b, c);
  input [3:0] a;
  input [3:0] b;
  output [3:0] c;
  
  reg [3:0] binv;
  wire [3:0] imm;
  always_comb
    case (b)
      'd0:  binv = 0; 
      'd1:  binv = 1;
      'd2:  binv = 9;
      'd3:  binv = 14;
      'd4:  binv = 13;
      'd5:  binv = 11;
      'd6:  binv =  7;
      'd7:  binv =  6;
      'd8:  binv = 15;
      'd9:  binv = 2;
      'd10: binv = 12;
      'd11: binv =  5;
      'd12: binv = 10;
      'd13: binv = 4;
      'd14: binv = 3;
      'd15: binv = 8;
    endcase

    GFMULT gfmult(a, binv, imm);
    assign c = imm;

endmodule
