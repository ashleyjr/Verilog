module prng(
	input	                        clk,
	input	                        nRst,
   input                         update,
   input                         reseed,
   input          [WIDTH-1:0]    seed,
   output   reg   [WIDTH-1:0]    rand
);
   
   parameter   WIDTH = 8,
               TAP1  = 1,
               TAP2  = 0;

   always@(posedge clk or negedge nRst) begin	
      casex({nRst,update,reseed}) 
         3'b0xx:  rand <= 0;
         3'b1x1:  rand <= seed;
         3'b110:  rand <= {(rand[TAP1] ^ rand[TAP2]),rand[(WIDTH-1):1]}; 
      endcase
   end
endmodule
