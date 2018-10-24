`timescale 1ns/1ps
module sin_lut_tb;

   reg   [6-1:0]   theta;
   wire  [10-1:0]   sin;

	sin_lut sin_lut(
		.i_theta (theta   ),
		.o_sin	(sin     )
	);
	
   initial begin
			$dumpfile("sin_lut.vcd");
			$dumpvars(0,sin_lut_tb);
		$display("                  TIME    theta   sin");		
      $monitor("%tps       %d,%d",$time,theta,sin);
	end

	initial begin
      theta = 0;
      repeat(1000) begin
         #10   theta = theta + 1;
      end
      $finish;
	end

endmodule
