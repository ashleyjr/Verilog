`timescale 1ns/1ps
module ram_uart_tb;

   // CLK = 12 MHz
	parameter   CLK_PERIOD_NS  = 83;

   // BAUD = 115200
   parameter   SAMPLE_TB      = 2170;     // SAMPLE_TB   = 1e9       / BAUDRATE
	
	reg	clk;
	reg	nrst;
   reg   rx;
   wire  tx;
   wire  led0;
   wire  led1;
   wire  led2;
   wire  led3;
   wire  led4;

	ram_uart ram_uart(
      .i_clk   (clk     ),
      .i_nrst  (nrst    ),
      .i_rx    (rx      ),
      .o_tx    (tx      ),
      .led0    (led0    ),
      .led1    (led1    ),
      .led2    (led2    ),
      .led3    (led3    ),
      .led4    (led4    )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD_NS/2) clk = 0;
			#(CLK_PERIOD_NS/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("ram_uart.vcd");
	   $dumpvars(0,ram_uart_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,nrst);
	end
   
   task uart_send;
      input [7:0] send;
      integer i;
      begin
         rx = 0;
         for(i=0;i<=7;i=i+1) begin
            #SAMPLE_TB  rx = send[i];
         end
         #SAMPLE_TB  rx = 1;
      end
   endtask

   integer i;

	initial begin
                  rx     = 1;
	   #100        nrst   = 1;
		#170		   nrst   = 0;
		#170		   nrst   = 1;	
      
      #500000     uart_send(8'h00); 
      #500000     uart_send(8'hFF); 
      #500000     uart_send(8'h01); 
      #500000     uart_send(8'h00); 

      $finish;
	end

endmodule
