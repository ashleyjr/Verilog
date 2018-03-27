`timescale 1ns/1ps
module fibonacci_mem_uart_tb;

   // CLK = 12MHz
   parameter CLK_PERIOD    = 83;

   // BAUD = 9600
   parameter   SAMPLE_TB   = 104167;   // SAMPLE_TB   = 1e9       / BAUDRATE

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

   task uart_get;
      output [7:0]   get;    
      integer        i;
      begin
         while(o_tx == 1) 
            @(posedge i_clk);  
         #(SAMPLE_TB*1.5)
         get = 0;
         for(i=0;i<8;i=i+1) begin 
            get[i]   = o_tx;
            #SAMPLE_TB; 
         end
         $display("%tps       uart_get = %x",$time,get); 
      end
   endtask

   reg   [7:0]    uart;

	initial begin
		while(1)
         uart_get(uart);
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
      #777777777
		$finish;
	end

endmodule
