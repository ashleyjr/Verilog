`timescale 1ns/1ps
module uart2gpio(
	input    clk,
	input    nRst,
	input    rx,
	input    sw2,
	input    sw1,
	input    sw0,
	output   tx,
	output   [4:0] led
);
   wire        bounce;
   wire [7:0]  data_rx;
   wire [7:0]  data_tx;

   assign led[0] = data_rx[0];
   assign led[1] = data_rx[1];
   assign led[2] = data_rx[2];
   assign led[3] = data_rx[3];
   assign led[4] = data_rx[4];

   assign data_tx = data_rx;
   //assign data_tx[0] = sw0;
   //assign data_tx[1] = sw0;
   //assign data_tx[2] = sw0;

   uart_autobaud uart_autobaud(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .transmit      (bounce   ),
      .data_tx       (data_tx),
      .rx            (rx         ),
      .busy_rx       (  ),
      .busy_tx       (  ),
      .recieved      (bounce  ),
      .data_rx       (data_rx    ),
      .tx            (tx         )
   );

endmodule
