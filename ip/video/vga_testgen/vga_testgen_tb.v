`timescale 1ns/1ps
module vga_testgen_tb;

	parameter CLK_PERIOD = 20;

	reg	         i_clk;
	reg	         i_nrst;	
	wire  [14:0]   o_rgb;

	vga_testgen vga_testgen(
      .i_clk   (i_clk   ),
      .i_nrst  (i_nrst  ),
	   .o_rgb   (o_rgb   )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
		$dumpfile("vga_testgen.vcd");
	   $dumpvars(0,vga_testgen_tb);
	   $display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
					i_nrst   = 1;
		#17		i_nrst   = 0;
		#17		i_nrst   = 1;	
		#100
		$finish;
	end

endmodule
