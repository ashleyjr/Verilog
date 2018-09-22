`timescale 1ns/1ps
module pll_blink_tb;

	parameter CLK_PERIOD = 83; // 12MHz

	reg	clk;
	reg	nrst;
   wire  led;
		
   pll_blink pll_blink(
      .i_nrst  (nrst ),
      .i_clk   (clk  ),
      .o_led   (led  )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("pll_blink.vcd");
		$dumpvars(0,pll_blink_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,nrst);
	end

	initial begin
					nrst		= 1;
      #117     nrst     = 0;
      #117     nrst     = 1;
		#100000
		$finish;
	end

endmodule
