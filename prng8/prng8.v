module prng8(
	input	                        clk,
	input	                        nRst,
   input                         reseed,
   input          [WIDTH-1:0]    seed,
   output   reg   [WIDTH-1:0]    rand
);
   
   parameter WIDTH = 8;
   
   wire top;
   assign top = ((rand[3] ^ rand[4]) ^ (rand[2] ^ rand[1]));
	always@(posedge clk or negedge nRst) begin
		if(!nRst)   rand <= 8'h00;
      else        
         if(reseed)
            rand <= seed;
         else
            rand <= {top,rand[7:1]}; 
   end
endmodule
