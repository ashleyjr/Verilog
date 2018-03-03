///////////////////////////////////////////////////////////
// uart_loopback.v
// Return UART traffic after passing through a FIFO
// 
// Baudrate = 9600
//
// Tested on icestick. Deeper FIFO breaks, perhaps timing?
//
///////////////////////////////////////////////////////////

`timescale 1ns/1ps
module uart_loopback(
	input    wire  i_clk,
	input    wire  i_nrst,
	input	   wire  i_rx,
	output	wire	o_tx
);

   parameter   DEPTH    = 10;
   parameter   WIDTH    = 8;
   parameter   SAMPLE   = 1250;   // SAMPLE = CLK_HZ / BAUDRATE

   wire                       rx_2_fifo_valid;
   wire  [7:0]                rx_2_fifo_data;
   wire  [7:0]                fifo_2_tx_data;
   wire                       fifo_2_tx_accept;

   wire                       valid_tx;
   wire  [$clog2(DEPTH)-1:0]  level;
   
   assign valid_tx = (level > 10);

   uart_rx #(
      .SAMPLE     (SAMPLE           )   
   ) uart_rx (
      .i_clk      (i_clk            ),
      .i_nrst     (i_nrst           ),
      .o_data     (rx_2_fifo_data   ),
      .i_rx       (i_rx             ),
      .o_valid    (rx_2_fifo_valid  ),
      .i_accept   (1'b1             )
	);

   fifo #(
      .DEPTH      (DEPTH            ),
      .WIDTH      (WIDTH            )
   ) fifo(
	   .i_clk      (i_clk            ),
		.i_nrst     (i_nrst           ),
		.i_data	   (rx_2_fifo_data   ),
      .o_data     (fifo_2_tx_data   ),
      .i_write    (rx_2_fifo_valid  ),
      .i_read     (tx_2_fifo_accept ),
      .o_level    (level            )
   );

   uart_tx #(
      .SAMPLE     (SAMPLE           )
   ) uart_tx (
	   .i_clk      (i_clk            ),
      .i_nrst     (i_nrst           ),
      .i_data     (fifo_2_tx_data   ),
      .o_tx       (o_tx             ),
      .i_valid    (valid_tx         ),
      .o_accept   (tx_2_fifo_accept )
   );

endmodule
