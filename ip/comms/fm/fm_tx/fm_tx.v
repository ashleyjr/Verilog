`timescale 1ns/1ps
module fm_tx(
	input	   wire  i_clk,
	input    wire  i_nrst,
	output   wire  o_fm
);

   reg count;

   assign o_fm = count;

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
			count    <= 1'b0;
		end else begin
         count    <= count + 'b1;	
		end
	end
endmodule
