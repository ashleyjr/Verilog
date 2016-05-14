module prng_parallel(
	input	         clk,
	input	         nRst,
   input          update,
   input          reseed,
   input    [7:0] seed,
   output   [7:0] rand
);
   
   wire [8:0]  rands [7:0];

   assign rand =  {
                     rands[7][8],
                     rands[6][8],
                     rands[5][8],
                     rands[4][8],
                     rands[3][8],
                     rands[2][8],
                     rands[1][8],
                     rands[0][8]
                  };
   genvar i;
   generate
      for(i=0;i<8;i=i+1) begin:prng
         prng #(9,(i+1),0) prng(
            .clk     (clk        ),
            .nRst    (nRst       ),
            .update  (update     ),
            .reseed  (reseed     ),
            .seed    ({seed,1'b0}),
            .rand    (rands[i]   )
         );
      end
   endgenerate



endmodule
