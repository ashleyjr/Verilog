`timescale 1ns/1ps
module uart2gpio(
	input    clk,
	input    nRst,
	input    rx,
	input    sw2,
	input    sw1,
	input    sw0,
	output   tx,
	output   led4,
	output   led3,
	output   led2,
	output   led1,
	output   led0
);
   wire        bounce;
   wire [7:0]  data_rx;
   wire [7:0]  data_tx;

   assign led0 = data_rx[0];
   assign led1 = data_rx[1];
   assign led2 = data_rx[2];
   assign led3 = data_rx[3];
   assign led4 = data_rx[4];

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
