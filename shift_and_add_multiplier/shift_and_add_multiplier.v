///////////////////////////////////////////////////////////
// shift_and_add_multiplier.v
// Perform multiplication of binary numbers using shift 
// and add algorithm. Raise i_valid to begin and 
// multiplication ready when o_accept asserted,
//
///////////////////////////////////////////////////////////


`timescale 1ns/1ps

module shift_and_add_multiplier(
	input				                     i_clk,
	input				                     i_nrst,
	input		      [DATA_WIDTH_A-1:0]   i_a,
	input    wire  [DATA_WIDTH_B-1:0]   i_b,
   output   reg   [DATA_WIDTH_C-1:0]   o_c,
	input	   wire                       i_valid,
	output	reg	                     o_accept
);

   parameter   DATA_WIDTH_A   = 0,
               DATA_WIDTH_B   = 0,
               DATA_WIDTH_C   = DATA_WIDTH_A + DATA_WIDTH_B;

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         o_accept <= 1'b0;
         o_c      <= 'b0;
		end else begin    
         if(i_valid) begin
            o_c      <= i_a * i_b;
            o_accept <= 1'b1;
         end else begin
            o_accept <= 1'b0;
         end
		end
	end
endmodule
