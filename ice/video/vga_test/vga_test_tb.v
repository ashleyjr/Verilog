`timescale 1ns/1ps
module vga_test_tb;
   
   parameter CLK_PERIOD    = 83; // 12Mhz

	reg	      i_clk;
	reg	      i_nrst;
   wire        o_hs;
   wire        o_vs;
   wire  [1:0] o_r;
   wire  [1:0] o_g;
   wire  [1:0] o_b;
		
   vga_test vga_test(
		.i_clk	(i_clk   ),
		.i_nrst	(i_nrst  ),
	   .o_hs    (o_hs    ),
      .o_vs    (o_vs    ),
      .o_r     (o_r     ),
      .o_g     (o_g     ),
      .o_b     (o_b     )
   );

   integer f;

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
	   $dumpfile("vga_test.vcd");
	   $dumpvars(0,vga_test_tb);
		$display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

   initial begin
      f = $fopen("output.txt","w");
      while(1) begin
         @(posedge i_clk);
         $fwrite(f, "%d,%d,%d,%d,%d\n",o_vs,o_hs,o_r,o_g,o_b);
      end
   end 

	initial begin
					i_nrst		= 1;	
		#17		i_nrst		= 0;
		#17		i_nrst		= 1;
		
		#30000000
		$fclose(f);
      $finish;
	end

endmodule
