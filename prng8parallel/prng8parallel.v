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

   assign rand =  {  
                     pass[7][7],
                     pass[7][6],
                     pass[7][5],
                     pass[7][4],
                     pass[7][3],
                     pass[7][2],
                     pass[7][1],
                     pass[7][0]
                  };
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
