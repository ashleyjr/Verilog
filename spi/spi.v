`timescale 1ns/1ps
module spi(
	input				         clk,
	input				         nRst,
   input                   start_swap,
   input          [7:0]    data_tx,
	input				         spi_miso,
	output	reg            spi_mosi,
	output	reg	         spi_cs,
	output	reg	         spi_clk,
   output         [7:0]    data_rx,
   output   reg            data_good
);
   
   parameter IDLE = 4'h0;

   reg [7:0]   data;
   reg [3:0]   state;

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         state    <= IDLE;
		   data     <= 8'h00;			
         spi_cs   <= 1'b1;
      end else begin
		   case(state)
            IDLE: if(start_swap) begin
                     data     <= data_tx;   
                     spi_cs   <= 1'b0;
                     state    <= BIT_0;

                  end
         endcase
      end
	end
endmodule
