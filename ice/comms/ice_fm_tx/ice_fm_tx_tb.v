`timescale 1ns/1ps
module ice_fm_tx_tb;

	parameter CLK_PERIOD = 5;  // 200MHz

	reg	clk;
	reg	nrst;
	wire	fm;

	ice_fm_tx ice_fm_tx(
		.i_clk	(clk  ),
		.i_nrst	(nrst ),
	   .o_fm    (fm   )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
			$dumpfile("ice_fm_tx.vcd");
			$dumpvars(0,ice_fm_tx_tb);
		   $display("                  TIME    nrst");		
         $monitor("%tps       %d",$time,nrst);
	end

	initial begin
					nrst		= 1;
		#17      nrst     = 0;
      #17      nrst     = 1;
      #100
		$finish;
	end

endmodule

