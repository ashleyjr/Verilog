`timescale 1ns/1ps
module counter8(
	input				      clk,
	input				      nRst,
	output   reg   [7:0] count
);
	
   always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         count    <= 8'h00;	
		end else begin
         count <= count + 8'h01;
		end
	end
endmodule
