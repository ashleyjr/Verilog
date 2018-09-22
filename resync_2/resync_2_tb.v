`timescale 1ns/1ps
module resync_2_tb;

	parameter CLK_PERIOD = 83;

	reg	clk;
	reg	nrst; 
   reg   d;
   wire  q;

	resync_2 resync_2(
      .i_clk   (clk  ),
      .i_nrst  (nrst ),
      .i_d     (d    ),
      .o_q     (q    )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("resync_2.vcd");
		$dumpvars(0,resync_2_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,nrst);
	end

	initial begin
					nrst		= 1;
		#170		nrst		= 0;
		#170		nrst		= 1;
		repeat(1000)
               #1 d     = $random; 
		$finish;
	end

endmodule
