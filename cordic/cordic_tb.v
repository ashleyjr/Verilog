`timescale 1ns/1ps
module cordic_tb;

	parameter CLK_PERIOD = 20;

	reg	                  clk;
	reg	                  nrst;
   reg   signed   [19:0]   theta;
   reg                     req;
   reg   signed   [19:0]   pi_8;
   reg   signed   [19:0]   pi;
   wire signed    [19:0]   sin;
   wire signed    [19:0]   cos;
   wire                    ack;

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
      
      // pi/8 = 0.392 = 'd25690.11 ~= 'h645a
      //pi_8  = 19'h0645a;
      //theta = -pi_8*4;
      //repeat(9) begin 
      //   #1000 req      = 1; 
      //   #1000 
      //         $display("sin(%f) = %f\t\tcos(%f) = %f", 
      //                     ($itor(theta)/16'hFFFF),
      //                     ($itor(sin)/16'hFFFF),
      //                     ($itor(theta)/16'hFFFF),
      //                     ($itor(cos)/16'hFFFF));
      //         req      = 0;
      //   theta = theta + pi_8;
      //end


      pi = 20'd205887; 
      theta = -pi;
      while(theta < pi) begin
         #1000 req = 1;
         #1000 req = 0;
         theta = theta + 20'd100;
      end


		$finish;
	end

endmodule
