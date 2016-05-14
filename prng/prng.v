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

   always@(posedge clk or negedge nRst ) begin	
      if(!nRst)   rand <= 0; 
      else
         casex({update,reseed}) 
            2'bx1:  rand <= seed;
            2'b10:  rand <= {(rand[TAP1] ^ rand[TAP2]),rand[(WIDTH-1):1]}; 
         endcase
   end
endmodule
