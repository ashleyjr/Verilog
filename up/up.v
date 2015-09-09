module up(
	input	   wire        clk,
	input	   wire        nRst
);
  
    
   reg   [7:0] address_latch;

   up_datapath(
      .clk     (clk     ),
      .nRst    (nRst    )
     
   );

   up_controller(
      .clk     (clk     ),
      .nRst    (nRst    )

   );

   up_memory(
      .clk     (clk     ),
      .nRst    (nRst    )
 
   );

endmodule
