module prng8parallel(
	input	                        clk,
	input	                        nRst,
   input                         update,
   input                         reseed,
   input          [WIDTH-1:0]    seed,
   output         [WIDTH-1:0]    rand
);
   
   parameter WIDTH = 8;

   prng8 prng8(
      .clk     (clk     ),
      .nRst    (nRst    ),
      .update  (update  ),
      .reseed  (reseed  ),
      .seed    (seed    ),
      .rand    (rand    )
   );
endmodule
