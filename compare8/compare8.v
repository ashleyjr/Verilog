`timescale 1ns/1ps
module compare8(
	input				clk,
	input				nRst,
	input          set,                          // High to set static compare reg
   input	   [7:0] cmp_static,                   // Static compare
	input	   [7:0] cmp,	                        // Moving compare (probably a counter input)
	output         out                           // Low unless static is greater than compare
);
   
   reg   [7:0] static;

   assign out = (static > cmp) ? 1'b1 : 1'b0;   // Set static to zero to freeze out low
	
   always@(posedge clk or negedge nRst) begin   // Clock in the static compare
		if(!nRst)   static <= 8'b0;         
		else
         if(set)  static <= cmp_static;
	end
endmodule
