`timescale 1ns/1ps
module vga_test(
	input	   wire  i_clk,
	input    wire  i_nrst,
	output	wire	o_hs,
	output	wire	o_vs,
	output	wire	o_r,
	output	wire	o_g,
	output	wire	o_b
);

   wire pll_clk;

   ///////////////////////////////////////////////////
   // PLL out is 72 MHz
   ice_pll #(
      .p_divr     (4'd0             ),
      .p_divf     (7'd47            ),
      .p_divq     (3'd3             )
   
   )ice_pll(
	   .i_clk	   (i_clk            ),
	   .i_nrst	   (i_nrst           ),
	   .i_bypass   (1'b0             ),
      .o_clk      (pll_clk          ),
      .o_lock     (                 )	
	);
   
   ///////////////////////////////////////////////////
   // PLL out is 67.5 MHz
   vga #(
      .R_WIDTH    (1                ),
      .G_WIDTH    (1                ),
      .B_WIDTH    (1                )
   ) vga (
      .i_clk      (pll_clk          ), 
      .i_nrst     (i_nrst           ),
            
      .o_v_next   (),
      .o_h_next   (),
      .i_rgb      (3'b111           ),
      .i_valid    (1'b1             ),
      .o_hs       (o_hs             ),
      .o_vs       (o_vs             ),
      .o_rgb      ({o_r, o_g, o_b}  )
   );

endmodule
