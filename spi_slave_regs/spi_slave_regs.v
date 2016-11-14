`timescale 1ns/1ps
module spi_slave_regs(
	input				clk,
	input				nRst,
	input				nCs,
	input				sclk,
	input				mosi,
	output	      miso
);

   parameter   IDLE  = 2'b00,
               READ  = 2'b01,
               WRITE = 2'b11;

   wire  [7:0] txData;
   reg        tx;
   wire  [7:0] rxData;
   wire        rx;

   reg   [1:0] state;
   reg         rx_last;
   reg   [6:0] addr;
   reg   [7:0] mem   [1:0];

   assign txData = (state == READ) ? mem[addr] : 8'h00;

   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state    <= IDLE;
         rx_last  <= 1'b0;
      end else begin
         tx       <= 1'b0;
         rx_last  <= rx;
         if(rx && ~rx_last) begin
            tx <= 1'b1;
            case(state)
               IDLE:    begin
                           addr = rxData[6:0];
                           if(rxData[7])  state <= READ;
                           else           state <= WRITE;
                        end
               WRITE:   begin
                           mem[addr] <= rxData;
                           state <= IDLE;
                        end
               READ:    begin
                           tx       <= 1'b1;
                           state    <= IDLE;
                        end 
            endcase
         end
      end
   end

   spi_slave spi_slave(   
	   .clk	   (clk     ),
	   .nRst	   (nRst    ),
	   .nCs	   (nCs     ),
	   .sclk	   (sclk    ),
	   .mosi	   (mosi    ),
      .txData  (txData  ),
      .tx      (tx      ),
	   .miso	   (miso    ),
      .rxData  (rxData  ),
      .rx      (rx      )
   );
endmodule
