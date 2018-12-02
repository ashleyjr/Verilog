`timescale 1ns/1ps
module sequential_alu_test_tb;

	parameter CLK_PERIOD = 20;
   parameter BAUD_PERIOD   = 1000;

	reg	clk;
	reg	nrst;
	reg	rx;
	wire	tx;

	sequential_alu_test sequential_alu_test(
		.i_clk	(clk  ),
		.i_nrst	(nrst ),
		.i_rx		(rx   ),
		.o_tx		(tx   )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
			$dumpfile("sequential_alu_test.vcd");
			$dumpvars(0,sequential_alu_test_tb);
		$display("                  TIME    nrst");		$monitor("%tps       %d",$time,nrst);
	end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         rx = 0;
         for(i=0;i<=7;i=i+1) begin    
            #BAUD_PERIOD rx = send[i];
         end 
         #BAUD_PERIOD rx = 1;
      end
   endtask

  	initial begin
					rx       = 1;
               nrst		= 1;
		#17		nrst		= 0;
		#17		nrst		= 1;

               // Sync
               repeat(10)
		            #5000 uart_send(8'hAA);		
     
               // Load A
               repeat(8)
      	         #5000 uart_send(8'hA0);		
              
               // Load B
               repeat(8)
      	         #5000 uart_send(8'hA1);		
      
               // Divide
               #5000    uart_send(8'h07);	
      #100000
		$finish;
	end

endmodule
