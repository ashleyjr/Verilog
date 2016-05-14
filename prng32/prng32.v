module prng32(
	input	                  clk,
	input	                  nRst,
   input                   reseed,
   input          [31:0]   seed,
   output         [31:0]   rand
);
   parameter BLOCKS = 4;
   genvar i;
   generate
      for(i=0; i<BLOCKS; i=i+1) begin:prng8
         prng8 prng8(
            .clk     (clk                       ),
            .nRst    (nRst                      ),
            .reseed  (reseed                    ), 
            .seed    (seed[((i*8)+7):(i*8)]     ),
            .rand    (rand[((i*8)+7):(i*8)]     ) 
         );
      end
   endgenerate 
endmodule
