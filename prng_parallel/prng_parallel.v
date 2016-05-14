module prng_parallel(
	input	         clk,
	input	         nRst,
   input          update,
   input          reseed,
   input    [7:0] seed,
   output   [7:0] rand
);

   prng #(8,1,2)  prng(
      .clk     (clk     ),
      .nRst    (nRst    ),
      .update  (update  ),
      .reseed  (reseed  ),
      .seed    (seed    ),
      .rand    (rand    )
   );

endmodule
