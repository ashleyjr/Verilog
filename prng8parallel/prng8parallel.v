module prng8parallel(
	input	                        clk,
	input	                        nRst,
   input                         update,
   input                         reseed,
   input          [WIDTH-1:0]    seed,
   output         [WIDTH-1:0]    rand
);
   
   parameter WIDTH = 8;

   wire  [WIDTH-1:0] pass  [WIDTH:0];

   assign pass[0] = seed;

   genvar i;
   generate
      for(i=0;i<WIDTH;i=i+1) begin:prng8
         prng8 prng8(
            .clk     (clk        ),
            .nRst    (nRst       ),
            .update  (update     ),
            .reseed  (reseed     ),
            .seed    (pass[i]    ),
            .rand    (pass[i+1]  )
         );
      end
   endgenerate
endmodule
