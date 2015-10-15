module mojo_top(
    input clk,
    input rst_n,
	 input int,
    output[7:0]led
);

wire rst = ~rst_n; // make reset active high


///////////////////////////////////////////////////
// Points to top module of perceptron code
up up(
   .clk     	(clk),
   .nRst    	(rst_n),
   .int 			(itn),
	.led 			(led)
);
///////////////////////////////////////////////////



endmodule
