module prng8(
	input	                        clk,
	input	                        nRst,
   input                         update,
   input                         reseed,
   input          [WIDTH-1:0]    seed,
   output   reg   [WIDTH-1:0]    rand
);
   
   parameter WIDTH = 8;
   
   wire top;
   
   assign top = ((rand[3] ^ rand[4]) ^ (rand[2] ^ rand[1]));
	
   always@(posedge clk or negedge nRst) begin	
      casex({nRst,update,reseed}) 
         3'b0xx:  rand <= 8'h00;
         3'b1x1:  rand <= seed;
         3'b110:  rand <= {top,rand[7:1]}; 
      endcase
   end
endmodule
