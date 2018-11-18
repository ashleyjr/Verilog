`timescale 1ns/1ps
module adder(
	input    wire  signed [DATA_WIDTH-1:0]    i_a,
	input	   wire  signed [DATA_WIDTH-1:0]    i_b,
	output   wire  signed [DATA_WIDTH-1:0]    o_q,
   output   wire                             o_ovf
);

   parameter   DATA_WIDTH = 0;

   wire signed [DATA_WIDTH:0] q;

   assign q       = i_a + i_b;   
   assign o_q     = {q[DATA_WIDTH],q[DATA_WIDTH-2:0]};
   assign o_ovf   = q[DATA_WIDTH] ^ q[DATA_WIDTH-1];

endmodule
