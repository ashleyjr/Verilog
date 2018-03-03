`timescale 1ns/1ps
module fifo_tb;

	parameter   CLK_PERIOD  = 20,
               WIDTH       = 4,
               DEPTH       = 10;

	reg	                     i_clk;
	reg	                     i_nrst;
   reg   [WIDTH-1:0]          i_data;
   wire  [WIDTH-1:0]          o_data;
   reg                        i_write;
   reg                        i_read;
   wire  [$clog2(DEPTH)-1:0]  o_level;

	fifo #(
      .DEPTH   (DEPTH   ),
      .WIDTH   (WIDTH   )
   ) fifo(
	   .i_clk   (i_clk   ),
		.i_nrst  (i_nrst  ),
		.i_data	(i_data  ),
      .o_data  (o_data  ),
      .i_write (i_write ),
      .i_read  (i_read  ),
      .o_level (o_level )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
	   $dumpfile("fifo.vcd");
	   $dumpvars(0,fifo_tb);	
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
					i_nrst   = 1;
		#17		i_nrst   = 0;
		#17		i_nrst   = 1;
		#10
      repeat(1000) begin
               i_data = $random;
               i_write = $random;
               i_read = $random;
               #20;
      end
		$finish;
	end

endmodule
