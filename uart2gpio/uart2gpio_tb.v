`timescale 1ns/1ps
module uart2gpio_tb;

	parameter CLK_PERIOD = 20;

	reg	clk;
	reg	nRst;
	reg	rx;
	reg	sw2;
	reg	sw1;
	reg	sw0;
	wire	tx;
	wire  [4:0] led;
   	
   uart2gpio uart2gpio(
		
			.clk	(clk),
			.nRst	(nRst),
			.rx	(rx),
			.sw2	(sw2),
			.sw1	(sw1),
			.sw0	(sw0),
			.tx	(tx),
			.led	(led)
		
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("uart2gpio_syn.vcd");
			$dumpvars(0,uart2gpio_tb);
		`else
			$dumpfile("uart2gpio.vcd");
			$dumpvars(0,uart2gpio_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
					nRst		= 1;
					rx			= 0;
					sw2		= 0;
					sw1		= 0;
					sw0		= 0;
		#17		nRst		= 0;
		#17		nRst		= 1;
		#17		sw0		= 1;
		#17		sw1		= 1;
		#17		sw2		= 1;
		#17		rx			= 1;
		#17		sw1		= 0;
		#17		sw2		= 0;
		#17		sw0		= 0;
		#17		rx			= 0;
		#10
		$finish;
	end

endmodule
