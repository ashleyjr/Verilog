`timescale 1ns/1ps
module spi_slave(
	input				clk,
	input				nRst,
	input				nCs,
	input				sclk,
	input				mosi,
   output         miso 
);

   reg         sclk_last;
   reg   [2:0] ptr;
   reg   [7:0] tx;
   reg   [7:0] rx;

   assign miso = tx[ptr];

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         tx          <= 8'd0;
         rx          <= 8'd0;
		   sclk_last   <= 1'b0;
         ptr         <= 3'd0; 
      end else begin
         sclk_last <= sclk;
         if(!nCs) begin 
            if(~sclk_last && sclk)  rx[ptr]     <= mosi; 
            if(sclk_last && ~sclk)  ptr         <= ptr + 3'b1;
         end else begin
            tx <= rx;
         end
		end
	end
endmodule
