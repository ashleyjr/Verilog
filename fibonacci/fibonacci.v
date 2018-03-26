///////////////////////////////////////////////////////////
// fibonacci.v
// Generates a fibonacci sequence to write to memory.
// Ouput o_write_valid is always valid as addition 
// happens on a single cycle. Updated when i_write_accept
// is returned.
//
///////////////////////////////////////////////////////////

`timescale 1ns/1ps
module fibonacci(
	input	   wire			               i_clk,
	input	   wire			               i_nrst,
   output   reg   [VALUE_WIDTH-1:0]    o_value,
   output   reg   [SEQUENCE_WIDTH-1:0] o_sequence,
   output   wire                       o_write_valid,
   input    wire                       i_write_accept	
);

   parameter   VALUE_WIDTH    = 0,
               SEQUENCE_WIDTH = 0;

   reg   [VALUE_WIDTH-1:0] last_value;

   assign o_write_valid = 1'b1;

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
		   o_value        <= 'b1;
         last_value     <= 'b0;
         o_sequence     <= 'b0;
      end else begin
         if(i_write_accept) begin
            o_value        <= o_value + last_value;
            last_value     <= o_value;
            o_sequence     <= o_sequence + 'b1; 
         end 
      end
	end
endmodule
