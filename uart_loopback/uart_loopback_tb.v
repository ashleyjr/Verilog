`timescale 1ns/1ps
module uart_loopback_tb;

   // CLK = 12 MHz
	parameter   CLK_PERIOD_NS  = 83;

   // BAUD = 9600
   parameter   SAMPLE_TB      = 104167;     // SAMPLE_TB   = 1e9       / BAUDRATE
	
	reg	i_clk;
	reg	i_nrst;
   reg   i_rx;
   wire  o_tx;

	uart_loopback uart_loopback(
      .i_clk   (i_clk   ),
      .i_nrst  (i_nrst  ),
      .i_rx    (i_rx    ),
      .o_tx    (o_tx    )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD_NS/2) i_clk = 0;
			#(CLK_PERIOD_NS/2) i_clk = 1;
		end
	end

	initial begin
		$dumpfile("uart_loopback.vcd");
	   $dumpvars(0,uart_loopback_tb);	
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,i_nrst);
	end
   
   task uart_send;
      input [7:0] send;
      integer i;
      begin
         i_rx = 0;
         for(i=0;i<=7;i=i+1) begin
            #SAMPLE_TB  i_rx = send[i];
         end
         #SAMPLE_TB  i_rx = 1;
      end
   endtask

   integer i;

	initial begin
                  i_rx     = 1;
	   #100        i_nrst   = 1;
		#170		   i_nrst   = 0;
		#170		   i_nrst   = 1;	
      for(i=0;i<256;i=i+1) begin
         #100000 uart_send(i); 
      end      
      $finish;
	end

endmodule
