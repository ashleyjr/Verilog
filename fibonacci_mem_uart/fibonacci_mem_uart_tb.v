`timescale 1ns/1ps
module fibonacci_mem_uart_tb;

	parameter CLK_PERIOD = 20;

	reg	i_clk;
	reg	i_nrst;
   wire  o_tx;

	fibonacci_mem_uart fibonacci_mem_uart(
      .i_clk   (i_clk   ),
      .i_nrst  (i_nrst  ),
      .o_tx    (o_tx    )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
	   $dumpfile("fibonacci_mem_uart.vcd");
	   $dumpvars(0,fibonacci_mem_uart_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
               i_nrst   = 1;
      #77      i_nrst   = 0;
      #77      i_nrst   = 1;
      #77777777
		$finish;
	end

endmodule
