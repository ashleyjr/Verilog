`timescale 1ns/1ps
module uart2pwm(
	input				clk,
	input				nRst,
   input          rx,
	input	   [7:0] div,
	input	   [7:0] duty,
   input          set_clk_div8,
   input    [4:0] set_compare8,
	output   [4:0] pwm,
   output         tx
);

   wire  [7:0] cmp;

   uart_autobaud uart_autobaud(
      .clk        (clk),
      .nRst       (nRst),
      .transmit   (),
      .data_tx    (),
      .rx         (rx),
      .busy_tx    (),
      .busy_tx    (),
      .recieved   (),
      .data_rx    (),
      .tx         (tx)
   );

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

   genvar i;
   generate
      for(i=0;i<5;i=i+1) begin
         compare8 compare8(
            .clk        (clk              ),
            .nRst       (nRst             ),
            .set        (set_compare8[i]  ),
            .cmp_static (duty             ),
            .cmp        (cmp              ),
            .out        (pwm[i]           )
         );
      end
   endgenerate

endmodule
