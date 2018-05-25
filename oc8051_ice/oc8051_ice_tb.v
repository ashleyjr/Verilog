`timescale 1ns/1ps
module oc8051_ice_tb;

	parameter CLK_PERIOD = 20;

	reg	i_clk;
	reg	i_nrst;	
	wire	o_led4;
	wire	o_led3;
	wire	o_led2;
	wire	o_led1;
	wire	o_led0;

	oc8051_ice oc8051_ice(	
	   .i_clk	(i_clk   ),
	   .i_nrst	(i_nrst  ),	
		.o_led4	(o_led4  ),
		.o_led3	(o_led3  ),
		.o_led2	(o_led2  ),
		.o_led1	(o_led1  ),
		.o_led0	(o_led0  )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin	
	   $dumpfile("oc8051_ice.vcd");
	   $dumpvars(0,oc8051_ice_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
	         i_nrst   = 1;
      #17   i_nrst   = 0;
      #17   i_nrst   = 1;
		#100000
		$finish;
	end

endmodule
