`timescale 1ns/1ps
module spi_slave_tb;

	parameter CLK_PERIOD = 20;

	reg	clk;
	reg	nRst;
	reg	nCs;
	reg	sclk;
	reg	mosi;
	wire	miso;

	spi_slave spi_slave(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst),
			.nCs	(nCs),
			.sclk	(sclk),
			.mosi	(mosi),
			.miso	(miso)
		`else
			.clk	(clk),
			.nRst	(nRst),
			.nCs	(nCs),
			.sclk	(sclk),
			.mosi	(mosi),
			.miso	(miso)
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
			$dumpfile("spi_slave_syn.vcd");
			$dumpvars(0,spi_slave_tb);
		`else
			$dumpfile("spi_slave.vcd");
			$dumpvars(0,spi_slave_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
					nRst		= 1;
	   #10
		$finish;
	end

endmodule
