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
   wire        rx_s;

   assign { o_led4,
            o_led3,
            o_led2,
            o_led1,
            o_led0  }   = data[4:0];

   resync_3 resync_3(
      .i_clk   (i_clk   ),
      .i_nrst  (i_nrst  ),
      .i_rst_d (1'b1    ),
      .i_d     (i_rx    ),
      .o_q     (rx_s    )
	);


   uart_autobaud uart_autobaud(
      .i_clk         (i_clk      ),
      .i_nrst        (i_nrst     ),
      .i_transmit    (loopback   ),
      .i_data_tx     (data       ),
      .i_rx          (rx_s       ),
      .o_busy_rx     (           ),
      .o_busy_tx     (           ),
      .o_recieved    (loopback   ),
      .o_data_rx     (data       ),
      .o_tx          (o_tx       )
   );


endmodule
