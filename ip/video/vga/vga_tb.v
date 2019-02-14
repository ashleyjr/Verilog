`timescale 1ns/1ps
module vga_tb;

	parameter CLK_PERIOD = 20;

   reg            i_clk;
   reg            i_nrst; 
   wire  [8:0]    o_v_next;
   wire  [9:0]    o_h_next;
   reg   [14:0]   i_rgb;
   reg            i_valid; 
   wire           o_hs;
   wire           o_vs;
   wire  [14:0]   o_rgb;
    
   vga vga (
		.i_clk	   (i_clk      ),
		.i_nrst	   (i_nrst     ),
      .o_v_next   (o_v_next   ),
      .o_h_next   (o_h_next   ),
      .i_rgb      (i_rgb      ),
      .i_valid    (i_valid    ),
      .o_hs       (o_hs       ),
      .o_vs       (o_vs       ),
      .o_rgb      (o_rgb      )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
	   $dumpfile("vga.vcd");
	   $dumpvars(0,vga_tb);
	   $display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
            i_rgb    = 0;
            i_valid  = 0;
		      i_nrst   = 1;
      #7    i_nrst   = 0;
      #7    i_nrst   = 1;
      
      repeat(20) begin
     	   #1000000 
            i_rgb    = $urandom;
            i_valid  = $urandom;
      end
		$finish;
	end

endmodule
