`timescale 1ns/1ps
module adder(
	input    wire  [DATA_WIDTH-1:0]  i_a,
	input	   wire  [DATA_WIDTH-1:0]  i_b,
	output   wire  [DATA_WIDTH-1:0]  o_q,
   output   wire                    o_ovf
);

   parameter   DATA_WIDTH = 0;

   wire  [DATA_WIDTH:0] q;

   assign q       = i_a + i_b;   
   assign o_q     = q[DATA_WIDTH-1:0];
   assign o_ovf   = q[DATA_WIDTH];

endmodule
