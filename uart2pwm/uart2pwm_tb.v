`timescale 1ns/1ps
module uart2pwm_tb;

	parameter CLK_PERIOD = 20;
   parameter CLK_DIV_PERIOD = 200;

	reg	         clk;
	reg	         nRst;
   reg            rx;
	wire  [4:0]    pwm;
   wire           tx;
		
   uart2pwm uart2pwm(
		.clk	            (clk           ),
			.nRst	            (nRst          ),
			.rx               (rx            ),
         .pwm              (pwm           ),
         .tx               (tx            )
  	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end
  

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("uart2pwm_syn.vcd");
			$dumpvars(0,uart2pwm_tb);
		`else
			$dumpfile("uart2pwm.vcd");
			$dumpvars(0,uart2pwm_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
			      nRst		      = 1;
	   #100     nRst           = 0;
      #100     nRst           = 1;

      $finish;
	end

endmodule
