`timescale 1ns/1ps
module spi_slave_regs_tb;

	parameter CLK_PERIOD = 20;

	reg	clk;
	reg	nRst;
	reg	nCs;
	reg   sclk;
	reg   mosi;
	wire  miso;	

	spi_slave_regs spi_slave_regs(	
			.clk	(clk  ),
			.nRst	(nRst ),
         .nCs  (nCs  ),
         .sclk (sclk ),
         .mosi (mosi ),
         .miso (miso )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("spi_slave_regs_syn.vcd");
			$dumpvars(0,spi_slave_regs_tb);
		`else
			$dumpfile("spi_slave_regs.vcd");
			$dumpvars(0,spi_slave_regs_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
					nRst		= 1;
	   #100     nRst     = 0;
      #100     nRst     = 1;
		$finish;
	end

endmodule
