`timescale 1ns/1ps
module uart2pwm_tb;

	parameter CLK_PERIOD = 20;
   parameter CLK_DIV_PERIOD = 200;

	reg	         clk;
	reg	         nRst;
	reg	         clk_div;
   reg   [7:0]    div;
   reg	[7:0]    duty;
	reg	         set_clk_div8;
   reg            set_compare8;
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
			.clk	            (clk           ),
			.nRst	            (nRst          ),
			.div              (div           ),
         .duty             (duty          ),
         .set_clk_div8     (set_clk_div8  ),
         .set_compare8     (set_compare8  ),
         .pwm              (pwm           )
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
			$dumpfile("uart2pwm_syn.vcd");
			$dumpvars(0,uart2pwm_tb);
		`else
			$dumpfile("uart2pwm.vcd");
			$dumpvars(0,uart2pwm_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
			      div            = 8'h00;
               duty           = 8'h00;
               set_clk_div8   = 1'b0;
               set_compare8   = 1'b0;
               nRst		      = 1;
	   #100     nRst           = 0;
      #100     nRst           = 1;
 

      #100     set_clk_div8   = 1;
               div            = 3;
      #100     set_clk_div8   = 0;


      repeat(300) begin
         #10000    set_compare8   = 1;
                  duty           = duty + 1;
         #100     set_compare8   = 0;
      end
		$finish;
	end

endmodule
