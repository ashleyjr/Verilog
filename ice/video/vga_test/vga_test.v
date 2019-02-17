`timescale 1ns/1ps
module vga_test(
	input	   wire           i_clk,
   input    wire           i_nrst,	
	output	wire	         o_hs,
	output	wire	         o_vs,
	output	wire  [1:0]    o_r,
	output	wire	[1:0]    o_g,
	output	wire	[1:0]    o_b
);

   parameter   V_WIDTH  = 10;
   parameter   H_WIDTH  = 11;

   // PLL
   wire        pll_clk;

   // VGA
   wire  [V_WIDTH-1:0]  v;
   wire  [H_WIDTH-1:0]  h;
   wire                 valid;
   wire  [5:0]          rgb; 


   ///////////////////////////////////////////////////
   // PLL out is 76.5 MHz
   ice_pll #(
      .p_divr     (4'd0             ),
      .p_divf     (7'd50            ),
      .p_divq     (3'd3             )
   
   )ice_pll(
	   .i_clk	   (i_clk            ),
	   .i_nrst	   (i_nrst           ),
	   .i_bypass   (1'b0             ),
      .o_clk      (pll_clk          ),
      .o_lock     (                 )	
	);
   
   ///////////////////////////////////////////////////
   // VGA
   vga #(
      .R_WIDTH    (2                ),
      .G_WIDTH    (2                ),
      .B_WIDTH    (2                )
   ) vga (
      .i_clk      (pll_clk          ), 
      .i_nrst     (i_nrst           ),      
      .o_v_next   (v                ),
      .o_h_next   (h                ),
      .i_rgb      (rgb              ),
      .i_valid    (valid            ),
      .o_hs       (o_hs             ),
      .o_vs       (o_vs             ),
      .o_rgb      ({o_r, o_g, o_b}  )
   );
   ///////////////////////////////////////////////////
   // TESTGEN
   vga_testgen #(
      .V_WIDTH    (V_WIDTH          ),
      .H_WIDTH    (H_WIDTH          ),
      .R_WIDTH    (2                ),
      .G_WIDTH    (2                ),
      .B_WIDTH    (2                )
   ) vga_testgen (
      .i_clk      (pll_clk          ), 
      .i_nrst     (i_nrst           ),  
      .i_v        (v                ),
      .i_h        (h                ),
      .o_valid    (valid            ),
      .o_rgb      (rgb              ) 
   );

endmodule
