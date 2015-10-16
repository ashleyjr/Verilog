module mojo_top(
    input clk,
    input rst_n,
	 input rx,
    output [7:0]led,
	 output	tx
);


wire loop;

///////////////////////////////////////////////////
// Points to top module of perceptron code

///////////////////////////////////////////////////

uart_autobaud uart_autobaud(
   .clk        (clk),
    .nRst 		(rst_n),
   .transmit     (loop),   // Raise to trasm
   .data_tx       (led),    // Transmit this
   .rx		(rx),
   .busy_tx		(),
   .busy_rx   (),
   .recieved		(loop),   // Raised when byte recieved, zero when getting
   .data_rx   (led),    // This is recieved
   .tx  (tx)
);

endmodule
