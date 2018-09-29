`timescale 1ns/1ps
module resync_3(
	input				i_clk,
   input          i_nrst,
   input          i_rst_d,
   input          i_d,
   output   reg   o_q 
);
   reg   p0,p1;

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         p0    <= i_rst_d;
         p1    <= i_rst_d;
         o_q   <= i_rst_d;
		end else begin
         o_q   <= p1;
         p1    <= p0;
         p0    <= i_d;
		end
	end
endmodule
