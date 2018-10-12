`timescale 1ns/1ps
module ice_fm_tx(
	input	   wire  i_clk,
	input	   wire  i_nrst,
	output   wire  o_fm
);
   wire clk;
   

   // PLL out is 192 MHz
   ice_pll #(
      .p_divr     (4'd0    ),
      .p_divf     (7'd63   ),
      .p_divq     (3'd2    )
   
   )ice_pll(
	   .i_clk	   (i_clk   ),
	   .i_nrst	   (i_nrst  ),
	   .i_bypass   (1'b0    ),
      .o_clk      (clk     ),
      .o_lock     (        )	
	);

   fm_tx fm_tx(
      .i_clk      (clk     ),
      .i_nrst     (i_nrst  ),
      .o_fm       (o_fm    )
   );

endmodule
