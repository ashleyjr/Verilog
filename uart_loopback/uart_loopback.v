`timescale 1ns/1ps
module uart_loopback(
	input    wire  i_clk,
	input    wire  i_nrst,
	input	   wire  i_rx,
	output	wire	o_tx
);

   parameter   SAMPLE   = 104;   // SAMPLE = CLK_HZ / BAUDRATE

   wire        valid_rx_2_tx;
   wire  [7:0] data_rx_2_tx;

   uart_rx #(
      .SAMPLE     (SAMPLE        )   
   ) uart_rx (
      .i_clk      (i_clk         ),
      .i_nrst     (i_nrst        ),
      .o_data     (data_rx_2_tx  ),
      .i_rx       (i_rx          ),
      .o_valid    (valid_rx_2_tx )
	);

   uart_tx #(
      .SAMPLE     (SAMPLE        )
   ) uart_tx (
	   .i_clk      (i_clk         ),
      .i_nrst     (i_nrst        ),
      .i_data     (data_rx_2_tx  ),
      .o_tx       (o_tx          ),
      .i_valid    (valid_rx_2_tx ),
      .o_accept   (              )
   );


	
endmodule
