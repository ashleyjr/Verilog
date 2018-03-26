`timescale 1ns/1ps
module fibonacci_tb;

	parameter CLK_PERIOD = 20;

	reg	clk;
	reg	nRst;
	reg	rx;
	reg	sw2;
	reg	sw1;
	reg	sw0;
	wire	tx;
	wire	led4;
	wire	led3;
	wire	led2;
	wire	led1;
	wire	led0;

	fibonacci fibonacci(
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
			$dumpfile("fibonacci_syn.vcd");
			$dumpvars(0,fibonacci_tb);
		`else
			$dumpfile("fibonacci.vcd");
			$dumpvars(0,fibonacci_tb);
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
