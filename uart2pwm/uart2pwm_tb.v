`timescale 1ns/1ps
module uart2pwm_tb;

	parameter CLK_PERIOD = 20;
   parameter CLK_DIV_PERIOD = 200;

	reg	         clk;
	reg	         nRst;
	reg	         clk_div;
	reg	[7:0]    duty;
	reg	         set;
	wire	         pwm;
		
   uart2pwm uart2pwm(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst),
			.rx	(rx),
			.sw2	(sw2),
			.sw1	(sw1),
			.sw0	(sw0),
			.tx	(tx),
			.led4	(led4),
			.led3	(led3),
			.led2	(led2),
			.led1	(led1),
			.led0	(led0)
		`else
			.clk	   (clk     ),
			.nRst	   (nRst    ),
			.clk_div (clk_div ),
         .duty    (duty    ),
         .set     (set     ),
         .pwm     (pwm     )
      `endif
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end
   
   initial begin
		while(1) begin
			#(CLK_DIV_PERIOD/2) clk_div = 0;
			#(CLK_DIV_PERIOD/2) clk_div = 1;
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
			      duty     = 8'h00;
               set      = 1'b0;
               nRst		= 1;
	   #100     nRst     = 0;
      #100     nRst     = 1;
      
      #100     duty     = 8'd128;
               set      = 1'b1;
      #100     set      = 1'b0;
	
      #1000000
		$finish;
	end

endmodule
