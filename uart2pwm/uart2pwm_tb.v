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
   reg   [4:0]    set_compare8;
   reg            rx;
	wire  [4:0]    pwm;
   wire           tx;
		
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
			.rx               (rx            ),
         .div              (div           ),
         .duty             (duty          ),
         .set_clk_div8     (set_clk_div8  ),
         .set_compare8     (set_compare8  ),
         .pwm              (pwm           ),
         .tx               (tx            )
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


      #1000000   set_compare8   = 5'b00001;
               duty           = 8'h11;
      #100     set_compare8   = 5'd0;
      

      #1000000   set_compare8   = 5'b00010;
               duty           = 8'h22;
      #100     set_compare8   = 5'd0;
		
      
      #1000000   set_compare8   = 5'b00100;
               duty           = 8'h33;
      #100     set_compare8   = 5'd0;
      
      #1000000   set_compare8   = 5'b01000;
               duty           = 8'h44;
      #100     set_compare8   = 5'd0;
      
      #1000000   set_compare8   = 5'b10000;
               duty           = 8'h55;
      #100     set_compare8   = 5'd0;
      
      #1000000   set_compare8   = 5'b00001;
               duty           = 8'h66;
      #100     set_compare8   = 5'd0;
      
      #1000000   set_compare8   = 5'b00010;
               duty           = 8'h77;
      #100     set_compare8   = 5'd0;
     












      $finish;
	end

endmodule
