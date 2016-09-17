`timescale 1ns/1ps
module counter8_tb;

	parameter CLK_PERIOD = 20;

	reg	      clk;
	reg	      nRst;
	wire  [7:0] count;
		
   
   counter8 counter8(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst),
			.rx	(rx),
			.sw2	(sw2),
			.sw1	(sw1),
			.sw0	(sw0),
			.tx	(tx),
			.led4	(led4),
			.led3	(led3),
			.led2	(led2),
			.led1	(led1),
			.led0	(led0)
		`else
			.clk	   (clk  ),
			.nRst	   (nRst ),
			.count   (count)
		`endif
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("counter8_syn.vcd");
			$dumpvars(0,counter8_tb);
		`else
			$dumpfile("counter8.vcd");
			$dumpvars(0,counter8_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
					nRst		= 1;
	   #100     nRst     = 0;
      #100     nRst     = 1;
      #10000
		$finish;
	end

endmodule
