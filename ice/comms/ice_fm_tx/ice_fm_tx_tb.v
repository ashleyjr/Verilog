`timescale 1ns/1ps
module ice_fm_tx_tb;

	parameter CLK_PERIOD = 20;

	reg	clk;
	reg	nrst;
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

	ice_fm_tx ice_fm_tx(
		.i_clk	(clk),
		.i_nrst	(nrst),
		.i_rx		(rx),
		.i_sw2	(sw2),
		.i_sw1	(sw1),
		.i_sw0	(sw0),
		.o_tx		(tx),
		.o_led4	(led4),
		.o_led3	(led3),
		.o_led2	(led2),
		.o_led1	(led1),
		.o_led0	(led0)
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
		$display("                  TIME    nrst");		$monitor("%tps       %d",$time,nrst);
	end

	initial begin
					nrst		= 1;
					rx			= 0;
					sw2		= 0;
					sw1		= 0;
					sw0		= 0;
		#17		nrst		= 0;
		#17		nrst		= 1;
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
