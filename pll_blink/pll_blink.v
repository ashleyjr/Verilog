`timescale 1ns/1ps
module pll_blink(
	input				i_clk,
	input				i_nrst,
	output	reg	o_led
);

   parameter   p_count_clks = 192000000;

   reg   [$clog2(p_count_clks)-1:0]    count;
   wire                                pll_clk; 

   pll pll(
      .i_clk      (i_clk      ),
      .i_nrst     (i_nrst     ),
      .i_bypass   (1'b0       ),
      .o_clk      (pll_clk    ),
      .o_lock     (           )
   );

   
	always@(posedge pll_clk or negedge i_nrst) begin
		if(!i_nrst) begin
		   o_led       <= 1'b0;
         count       <= 'd0;
      end else begin 
         if(count == p_count_clks) begin
            o_led    <= ~o_led;
            count    <= 'd0;
         end else begin
            count    <= count + 'd1;
         end
      end
	end
endmodule
