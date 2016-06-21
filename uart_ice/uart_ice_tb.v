`timescale 1ns/1ps
module uart_ice_tb;

	parameter CLK_PERIOD = 20;

	reg clk;
	reg nRst;

	uart_ice uart_ice(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst)
		`else
			.clk	(clk),
			.nRst	(nRst)
		`endif
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("uart_ice_syn.vcd");
			$dumpvars(0,uart_ice_tb);
		`else
			$dumpfile("uart_ice.vcd");
			$dumpvars(0,uart_ice_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);	end

	initial begin
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;
		#10000
		$finish;
	end

endmodule
