`timescale 1ns/1ps
module mandelbrot_tb;

	parameter   CLK_PERIOD  = 20;
   parameter   WIDTH       = 16;
   parameter   ITERS       = 256;
	
   reg	                     i_clk;
	reg	                     i_nrst;
	reg   [WIDTH-1:0]          i_c_re;
	reg   [WIDTH-1:0]          i_c_im;
	reg	                     i_valid;
	wire	[$clog2(ITERS)-1:0]  o_iter;
	wire                       o_done;	

	mandelbrot #(
      .WIDTH   (WIDTH   ),
      .ITERS   (ITERS   )
   ) mandelbrot (
		.i_clk	(i_clk   ),
		.i_nrst	(i_nrst  ),
		.i_c_re  (i_c_re  ),
		.i_c_im	(i_c_im  ),
		.i_valid	(i_valid ),
		.o_iter	(o_iter  ),
		.o_done  (o_done  )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
		$dumpfile("mandelbrot.vcd");
		$dumpvars(0,mandelbrot_tb);
	   $display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

   initial begin
      #100000
		$finish;
	end

   task compute;
      input [WIDTH-1:0] re;
      input [WIDTH-1:0] im;
      begin
         i_valid  = 1;
         i_c_re   = re;
         i_c_im   = im;
         while(0 == o_done) begin 
            @(posedge i_clk);
         end
         i_valid   = 0;
      end
   endtask
	
   initial begin
               i_c_re   = 0;
               i_c_im   = 0;
               i_valid  = 0;
					i_nrst   = 1;	
		#17		i_nrst	= 0;
      #17      i_nrst   = 1;
		
      #1000    compute(1,1);
      #1000    compute(0,0);
      #1000    compute(1,1);

	end

endmodule
