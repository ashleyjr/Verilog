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

   //initial begin
   //   #1000000
	//	$finish;
	//end

   task compute;
      input real re;
      input real im;
      begin
         i_c_re = $rtoi(re*(2 ** (WIDTH-2)));
         i_c_im = $rtoi(im*(2 ** (WIDTH-2)));
         i_valid  = 1;
         while(0 == o_done) begin 
            @(posedge i_clk);
         end
         i_valid   = 0;
      end
   endtask

   integer f;
   real i,j;

   initial begin
      f = $fopen("output.txt","w");
               i_c_re   = 0;
               i_c_im   = 0;
               i_valid  = 0;
					i_nrst   = 1;	
		#17		i_nrst	= 0;
      #17      i_nrst   = 1;
	
      
      #1000    compute(0,  0);      // Bounded
      #1000    compute(-1, 0);      // Bounded
      #1000    compute(-0.1, 0.5);  // Bounded
      #1000    compute(-0.1, -0.5); // Bounded

      
      #10000    
               compute(1, 0);    // Unbounded
      #1000    compute(2, 2);    // Unbounded
      #1000    compute(-2, 2);   // Unbounded
      #1000    compute(2, -2);   // Unbounded
      #1000    compute(-2, -2);  // Unbounded

      
      i = -1;
      repeat(50) begin 
         j = -1;
         repeat(50) begin 
            #1000 compute(i,j); 
            $fwrite(f, "%f,%f,%d\n",i,j,o_iter);
            j = j + 0.02;
         end
         i = i +  0.02;
      end
      //#1000    compute($urandom,0);
      $finish;
	end

endmodule
