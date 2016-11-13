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
   reg   [7:0] data;

   assign miso = data[ptr];

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         data        <= 8'd0;
		   sclk_last   <= 1'b0;
         ptr         <= 3'd0; 
      end else begin
         sclk_last <= sclk;
         if(!nCs) begin 
            if(~sclk_last && sclk) begin
			      data[ptr]   <= mosi; 
               ptr         <= ptr + 3'b1;
            end
         end
		end
	end
endmodule
