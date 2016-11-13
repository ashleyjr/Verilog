`timescale 1ns/1ps
module spi_slave_tb;

	parameter CLK_PERIOD = 20;

	reg	      clk;
	reg	      nRst;
	reg   	   nCs;
	reg	      sclk;
	reg	      mosi;
   reg   [7:0] txData;
   reg         tx;
	wire	      miso;
   wire  [7:0] rxData;
   wire        rx;

	spi_slave spi_slave(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst),
			.nCs	(nCs),
			.sclk	(sclk),
			.mosi	(mosi),
			.miso	(miso)
		`else
			.clk	   (clk     ),
			.nRst	   (nRst    ),
			.nCs	   (nCs     ),
			.sclk	   (sclk    ),
			.mosi	   (mosi    ),
         .txData  (txData  ),
         .tx      (tx      ),
			.miso	   (miso    ),
         .rxData  (rxData  ),
         .rx      (rx      )
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
      input    [7:0] put;
      output   [7:0] get;
      reg      [2:0] ptr;
      begin
         #100  sclk  = 0;
               nCs   = 1;
         #100  nCs   = 0;
         ptr = 7;
         repeat(8) begin   
                  mosi     = put[ptr];
            #100  sclk     = ~sclk;
                  get[ptr] = miso;
            #100  sclk     = ~sclk;
                  ptr      = ptr - 1;
         end
         #100  nCs   = 1;
      end
   endtask

   reg   [7:0] j;
   reg   [7:0] k;

	initial begin
					nRst		= 1;
	   #100     nRst     = 0;
      #100     nRst     = 1;
               tx       = 0;
               j = 0;
               repeat(500) begin
                  #1000 swap(j,k);        // get fresh data
                  #500  txData = 8'h01 + k;
                  #100  tx = 1;
                  #100  tx = 0;
                        j = j + 1;
               end	
		#1000
      $finish;
	end

endmodule
