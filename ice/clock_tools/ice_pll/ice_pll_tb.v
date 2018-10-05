`timescale 1ns/1ps
module ice_pll_tb;

	parameter CLK_PERIOD = 83; // 12Mhz

	reg	i_clk;
	reg	nrst;
   reg   bypass;
   wire  o_clk;
   wire  o_lock;	

	ice_pll ice_pll(
	   .i_clk	   (i_clk   ),
	   .i_nrst	   (nrst    ),
	   .i_bypass   (bypass  ),
      .o_clk      (o_clk   ),
      .o_lock     (lock    )	
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
		$dumpfile("ice_pll.vcd");
		$dumpvars(0,ice_pll_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,nrst);
	end

	initial begin
					nrst		= 1;
		         bypass   = 0;
      #17		nrst		= 0;
		#17		nrst		= 1;
		#400     bypass   = 1;
      #400     bypass   = 0;
      #400     bypass   = 1;
      #400
		$finish;
	end

endmodule
