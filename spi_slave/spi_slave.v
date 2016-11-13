`timescale 1ns/1ps
module spi_slave(
	input				clk,
	input				nRst,
	input				nCs,
	input				sclk,
	input				mosi,
   output   reg   miso 
);

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         miso <= 1'b1;;
		end else begin
			miso <= mosi;
		end
	end
endmodule
