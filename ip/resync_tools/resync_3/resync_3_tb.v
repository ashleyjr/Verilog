`timescale 1ns/1ps
module resync_3_tb;

	parameter CLK_PERIOD = 83;

	reg	clk;
	reg	nrst; 
   reg   d;
   wire  q;

	resync_3 resync_3(
      .i_clk   (clk  ),
      .i_nrst  (nrst ),
      .i_rst_d (1'b0 ),
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
		$dumpfile("resync_3.vcd");
		$dumpvars(0,resync_3_tb);	
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
