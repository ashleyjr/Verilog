`timescale 1ns/1ps
module ashley_tb;

	parameter CLK_PERIOD = 20;

	reg   clk;
   wire  led_d1_top;
   wire  led_d2_right;
   wire  led_d3_bottom;
   wire  led_d4_left;
   wire  led_d5_middle;

	ashley ashley(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst)
		`else
			.clk	         (clk           ),
         .led_d1_top    (led_d1_top    ),
         .led_d2_right  (led_d2_right  ),
         .led_d3_bottom (led_d3_bottom ),
         .led_d4_left   (led_d4_left   ),
         .led_d5_middle (led_d5_middle )
		`endif
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("ashley_syn.vcd");
			$dumpvars(0,ashley_tb);
		`else
			$dumpfile("ashley.vcd");
			$dumpvars(0,ashley_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,clk);	end

	initial begin	
		#10000
		$finish;
	end

endmodule
