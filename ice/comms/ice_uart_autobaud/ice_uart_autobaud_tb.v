`timescale 1ns/1ps
module ice_uart_autobaud_tb;

	parameter CLK_PERIOD = 20;

	reg   clk;
	reg   nrst;
   reg   rx;
   wire  tx;
   wire  led0;
   wire  led1;
   wire  led2;
   wire  led3;
   wire  led4;

	ice_uart_autobaud 
   ice_uart_autobaud(	
	   .i_clk   (clk     ),
      .i_nrst  (nrst    ),
      .i_rx    (rx      ),
      .o_tx    (tx      ),
      .o_led0  (led0    ),     
      .o_led1  (led1    ),
      .o_led2  (led2    ),
      .o_led3  (led3    ),
      .o_led4  (led4    )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin	
		$dumpfile("ice_uart_autobaud.vcd");
		$dumpvars(0,ice_uart_autobaud_tb);
		$display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,nrst);	
   end

	initial begin
					nrst = 1;
		#100		nrst = 0;
		#100		nrst = 1;
		#10000
		$finish;
	end

endmodule
