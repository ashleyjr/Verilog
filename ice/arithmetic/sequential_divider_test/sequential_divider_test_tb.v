`timescale 1ns/1ps
module sequential_divider_test_tb;

	parameter CLK_PERIOD    = 83; // 12Mhz
   parameter BAUD_PERIOD   = 1000;

	reg	         clk;
	reg	         nrst; 
   reg            tx;	
   wire           rx;

	sequential_divider_test
  	sequential_divider_test(
		.i_clk	   (clk           ),
		.i_nrst	   (nrst          ),
      .i_rx       (tx            ), 
      .o_tx       (rx            )
   );
 

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("sequential_divider_test.vcd");
		$dumpvars(0,sequential_divider_test_tb);
		$display("                  TIME                 freq (hz)       Avg freq (hz)");		 
 
   end
   
   task uart_send;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin    
            #BAUD_PERIOD tx = send[i];
         end 
         #BAUD_PERIOD tx = 1;
      end
   endtask

   task load;
      input [32-1:0] a;
      input [3:0]    cmd;
      reg   [32-1:0] l;
      reg   [8-1:0]  val;
      begin
         l = a;
         repeat(8) begin
                     val = {l[31:28],cmd};
            #5000    uart_send(val); 
                     l = l << 4;
         end
      end
   endtask
   

   reg   [3:0] i;

   reg   [31:0]   a,b;
   reg   [63:0]   c;
   initial begin
					nrst = 1;
		         tx   = 1;
      #100		nrst = 0;
		#100		nrst = 1;
   
      //// Sync
      repeat(10)
         #5000    uart_send(8'hAA); 
 
      repeat(5) begin
         a = $urandom;
         b = $urandom;
         c = a * b;
         load(a, 0);
         load(b, 1);     
         uart_send(8'h3);
         repeat(8)
            uart_send(8'h2);
      end
      #5000 
      $finish;

	end
endmodule

