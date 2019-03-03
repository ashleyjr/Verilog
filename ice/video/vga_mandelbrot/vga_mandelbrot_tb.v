`timescale 1ns/1ps
module vga_mandelbrot_tb;

	parameter CLK_PERIOD = 20;

	reg	         clk;
	reg	         nrst;
	wire           hs;
   wire           vs;
   wire  [1:0]    r;
   wire  [1:0]    g;
   wire  [1:0]    b;
	
   vga_mandelbrot vga_mandelbrot(
	   .i_clk	(clk  ),
		.i_nrst	(nrst ),
		.o_hs    (hs   ),
      .o_vs    (vs   ),
      .o_r     (r    ),
      .o_g     (g    ),
      .o_b     (b    )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("vga_mandelbrot.vcd");
		$dumpvars(0,vga_mandelbrot_tb);
		$display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,nrst);
	end

	initial begin
					nrst		= 1;	
		#17		nrst		= 0;
		#17		nrst		= 1;	
		#100000
		$finish;
	end

endmodule
