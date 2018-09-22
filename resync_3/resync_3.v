`timescale 1ns/1ps
module resync_3(
	input				i_clk,
   input          i_nrst,
   input          i_d,
   output   reg   o_q 
);
   reg   p0,p1;

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         p0    <= 1'b0;
         p1    <= 1'b0;
         o_q   <= 1'b0;
		end else begin
         o_q   <= p1;
         p1    <= p0;
         p0    <= i_d;
		end
	end
endmodule
