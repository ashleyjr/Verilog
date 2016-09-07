`timescale 1ns/1ps
module pid_tb;

	parameter CLK_PERIOD = 10;

	reg	                  clk;
	reg	                  nRst;
	reg   signed   [31:0]   target; 
	reg   signed   [31:0]   process;
   reg   signed   [31:0]   Kp;
   reg   signed   [31:0]   Ki;
   reg   signed   [31:0]   Kd;
   wire  signed   [31:0]   drive;


   integer           seed;
   reg      [31:0]   rand;
   reg      [31:0]   tune;

	pid pid(
		`ifdef POST_SYNTHESIS
		   
		`else
			.clk	   (clk     ),
			.nRst	   (nRst    ),
			.target	(target  ),
			.process	(process ),
			.Kp	   (Kp      ),
			.Ki	   (Ki      ),
			.Kd	   (Kd      ),
			.drive	(drive   )	
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
			$dumpfile("pid_syn.vcd");
			$dumpvars(0,pid_tb);
		`else
			$dumpfile("pid.vcd");
			$dumpvars(0,pid_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

   task pidTest;
      input [31:0]   p;
      input [31:0]   i;
      input [31:0]   d;
      begin
         Kp = p;
         Ki = i;
         Kd = d;
         seed = $time;
         repeat(1000) begin
            #1    rand = $random(seed);
                  rand = rand >> 30;
                  process = (process/1.1) + (drive/100) + rand;
         end
      end
   endtask

	initial begin
      nRst		= 1'b1;
      target   = 32'd10000; 
      
      // Sweep the I only
      tune   = 32'd0;
      repeat(21) begin
                  process = 32'd0;
         #1000    pidTest(tune,0,0);
                  tune = tune + 32'd1;
      end

      // Sweep I with P fixed
      tune   = 32'd0;
      repeat(10) begin
                  process = 32'd0;
         #1000    pidTest(32'd10,tune,0);
                  tune = tune + 32'd1;
      end


      $finish;
	end

endmodule
