`timescale 1ns/1ps
module uart2pwm(
	input				clk,
	input				nRst,
	input	   [7:0] div,
	input	   [7:0] duty,
   input          set_clk_div8,
   input          set_compare8,
	output         pwm
);

   wire  [7:0] cmp;

   clk_div8 clk_div8(
      .clk        (clk              ),
      .nRst       (nRst             ),
      .div        (div              ),
      .set        (set_clk_div8     ),
      .clk_div    (clk_div          )
   );

   counter8 counter8(
      .clk        (clk_div          ),
      .nRst       (nRst             ),
      .count      (cmp              )
   );

   compare8 compare8(
      .clk        (clk              ),
      .nRst       (nRst             ),
      .set        (set_compare8     ),
      .cmp_static (duty             ),
      .cmp        (cmp              ),
      .out        (pwm              )
   );

endmodule
