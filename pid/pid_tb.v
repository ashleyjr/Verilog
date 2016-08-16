`timescale 1ns/1ps
module pid_tb;

	parameter CLK_PERIOD = 20;

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
      input    signed   [31:0]   v;       // Feedback from plant
      input    signed   [31:0]   u;       // Drive from controller
      input    signed   [31:0]   d;       // Simulated disturbance
      output   signed   [31:0]   next;
      begin
         next = (v/2) + (u/1000) + d;
      end
   endtask

   task pidTest;
      input [31:0]   p;
      input [31:0]   i;
      input [31:0]   d;
      begin
               process  = 0;
         #100  Kp       = p;
               Ki       = i;
               Kd       = d;
               seed     = $time;
               repeat(200) begin
                  #1    rand = $random(seed);
                        rand = rand >> 30;
                        plantUpdate(process,drive,rand,process);
               end
      end
   endtask

	initial begin
      nRst		= 1;
      target   = 10000;
     
      pidTest(80,0,0);      
      pidTest(100,0,0);
      pidTest(120,0,0);
      pidTest(140,0,0);
      pidTest(160,0,0);      
      pidTest(180,0,0);
      pidTest(200,0,0);
      pidTest(220,0,0);

      $finish;
	end

endmodule
