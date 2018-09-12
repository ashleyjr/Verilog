`timescale 1ns/1ps
module cordic_tb;

	parameter CLK_PERIOD = 20;

	reg	         clk;
	reg	         nrst;
   reg   [15:0]   theta;
   reg            req;
   wire  [15:0]   sin;
   wire  [15:0]   cos;
   wire           ack;

   cordic cordic(
	   .i_clk   (clk     ),
      .i_nrst  (nrst    ),
      .i_req   (req     ),
      .i_theta (theta   ),
      .o_sin   (sin     ),
      .o_cos   (cos     ),
      .o_ack   (ack     ) 
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("cordic.vcd");
		$dumpvars(0,cordic_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,nrst);
	end

   initial begin
					
               nrst		= 1;
		         req      = 0;
      #17		nrst		= 0;
      #17      nrst     = 1;
      //for(theta=0;theta<=1;theta=theta+1) begin
         theta = 16'hFFFF;
         #1000 req      = 1;
         #1000 req      = 0;
      //end
		$finish;
	end

endmodule
