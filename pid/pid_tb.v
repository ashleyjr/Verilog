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

	initial begin
					nRst		= 1;	
		#100
		$finish;
	end

endmodule
