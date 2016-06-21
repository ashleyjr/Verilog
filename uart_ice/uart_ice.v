module uart_ice(
	input	   clk,
   input    rx,
   input    nRst,
   output   led 
);
   wire [7:0] data_rx;

   assign led = data_rx[0];

   uart_autobaud uart_autobaud(
        .clk           (clk        ),
         .nRst          (nRst      ),
         .transmit      (     ),
         .data_tx       (   ),
         .rx            (rx         ),
         .busy_rx       (    ),
         .busy_tx       (    ),
         .recieved      (  ),
         .data_rx       ( data_rx  ),
         .tx            (         )
   );


endmodule
