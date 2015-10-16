module mojo_top(
    input clk,
    input rst_n,
	 input int,
	 input rx,
    output[7:0]led,
	 output	tx
);

wire rst = ~rst_n; // make reset active high


///////////////////////////////////////////////////
// Points to top module of perceptron code
up up(
   .clk     	(clk),
   .nRst    	(rst_n),
   .int 			(int),
	.rx			(rx),
	.led 			(led),
	.tx			(tx)
);
///////////////////////////////////////////////////



endmodule
