`timescale 1ns/1ps
module spi_slave_tb;

	parameter CLK_PERIOD = 20;

	reg	      clk;
	reg	      nRst;
	reg   	   nCs;
	reg	      sclk;
	reg	      mosi;
	wire	      miso;
   reg   [7:0] rx;

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

   task swap;
      input    [7:0] tx;
      output   [7:0] rx;
      integer        i;
      begin
         #100  sclk  = 0;
               nCs   = 1;
         #100  nCs   = 0;
         for(i=0;i<=7;i=i+1) begin   
                  mosi = tx[i];
            #100  sclk = ~sclk;
                  rx[i] = miso;
            #100  sclk = ~sclk;
         end
         #100  nCs   = 1;
      end
   endtask

   integer j;

	initial begin
					nRst		= 1;
	   #100     nRst     = 0;
      #100     nRst     = 1;
               j = 0;
               repeat(500) begin
                  #100  swap(j,rx);
                        j = j + 1;
               end	
		#1000
      $finish;
	end

endmodule
