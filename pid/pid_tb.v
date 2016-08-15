`timescale 1ns/1ps
module pid_tb;

	parameter CLK_PERIOD = 20;

	reg	         clk;
	reg	         nRst;
	reg   [31:0]   target; 
	reg   [31:0]   process;
   reg   [31:0]   Kp;
   reg   [31:0]   Ki;
   reg   [31:0]   Kd;
   wire  [31:0]   drive;


   integer           seed;
   reg      [31:0]   rand;

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


   task plantUpdate;
      input    [31:0]   v;       // Feedback from plant
      input    [31:0]   u;       // Drive from controller
      input    [31:0]   d;       // Simulated disturbance
      output   [31:0]   next;
      begin
         next = (750*v) + (2000*u) + d;
      end
   endtask

	initial begin
					nRst		= 1;
               target   = 100;
               process  = 0;
      #100     Kp       = 100;
               Ki       = 0;
               Kd       = 0;
               seed     = $time;
               repeat(100) begin
                  #100  rand = $random(seed);
                        rand = rand >> 30;
                        plantUpdate(process,drive,rand,process);
               end
		$finish;
	end

endmodule
