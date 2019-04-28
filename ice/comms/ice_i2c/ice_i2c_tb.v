`timescale 1ns/1ps
module ice_i2c_tb;

	parameter CLK_PERIOD = 20;

   reg         i_clk;   
   reg         i_nrst;  
   wire        o_scl;   
   reg         i_scl;   
   wire        o_sda;   
   reg         i_sda;   
   reg   [6:0] i_addr;  
   reg   [7:0] i_data;  
   wire  [7:0] o_data;  
   reg         i_rnw;   
   reg         i_valid; 
   wire        o_accept;

	ice_i2c ice_i2c(
		.i_clk	(i_clk   ),
		.i_nrst	(i_nrst  ),
      .o_scl   (o_scl   ),
      .i_scl   (i_scl   ),
      .o_sda   (o_sda   ),
      .i_sda   (i_sda   ),         
      .i_addr  (i_addr  ),
      .i_data  (i_data  ),
      .o_data  (o_data  ),
      .i_rnw   (i_rnw   ),
      .i_valid (i_valid ),
      .o_accept(o_accept)
   );
	
   initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
	   $dumpfile("ice_i2c.vcd");
	   $dumpvars(0,ice_i2c_tb);	
	end

   initial begin
      #100000
      $finish;
	end
	
   initial begin
               i_nrst   = 1;
		#7       i_nrst   = 0;	
      #7       i_nrst   = 1;
               i_valid  = 0;
               i_rnw    = 0;
               i_data   = 8'hFF;
               i_addr   = 7'h7F;
      #5000    i_valid  = 1;
               while(!o_accept)
                  @(posedge i_clk);
               i_valid  = 0;
	end

endmodule
