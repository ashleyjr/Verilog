module ice_uart_autobaud(
	input	   wire  i_clk,
   input    wire  i_rx,
   input    wire  i_nrst,
   output   wire  o_tx,
   output   wire  o_led0,   
   output   wire  o_led1,
   output   wire  o_led2,
   output   wire  o_led3,
   output   wire  o_led4
);
   wire [7:0]  data;
   wire        loopback;

   assign { led4,
            led3,
            led2,
            led1,
            led0  } = data[4:0];

   uart_autobaud uart_autobaud(
      .i_clk         (i_clk      ),
      .i_nrst        (i_nrst     ),
      .i_transmit    (loopback   ),
      .i_data_tx     (data       ),
      .i_rx          (i_rx       ),
      .o_busy_rx     (           ),
      .o_busy_tx     (           ),
      .o_recieved    (loopback   ),
      .o_data_rx     (data       ),
      .o_tx          (o_tx       )
   );


endmodule
