`timescale 1ns/1ps
module uart2pwm(
	input				clk,
	input				nRst,
	input				clk_div,
	input	   [7:0] duty,
   input          set,
	output         pwm
);

   wire  [7:0] cmp;

   counter8 counter8(
      .clk     (clk_div ),
      .nRst    (nRst    ),
      .count   (cmp     )
   );

   compare8 compare8(
      .clk        (clk     ),
      .nRst       (nRst    ),
      .set        (set     ),
      .cmp_static (duty    ),
      .cmp        (cmp     ),
      .out        (pwm     )
   );

endmodule
