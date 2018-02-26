`timescale 1ns/1ps

module uart_rx_tb;

	parameter   CLK_PERIOD_NS  = 20;
   parameter   SAMPLE         = 5208;     // SAMPLE = CLK_HZ   /  BAUDRATE
   parameter   SAMPLE_TB      = 104166;   // SAMPLE_TB = 1e9 / BAUDRATE
	
   reg	      i_clk;
	reg	      i_nrst;
   wire  [7:0] o_data;
   reg         i_rx;
   wire        o_valid;
   reg         i_accept;

   uart_rx #(
      .SAMPLE     (SAMPLE     )
   
   ) uart_rx (
      .i_clk      (i_clk      ),
      .i_nrst     (i_nrst     ),
      .o_data     (o_data     ),
      .i_rx       (i_rx       ),
      .o_valid    (o_valid    ),
      .i_accept   (i_accept   )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD_NS/2)   i_clk = 0;
			#(CLK_PERIOD_NS/2)   i_clk = 1;
		end
	end

	initial begin
		$dumpfile("uart_rx.vcd");
	   $dumpvars(0,uart_rx_tb);
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


	initial begin
					i_nrst		= 1;
               i_accept    = 1;
      #17      i_nrst      = 0;
      #17      i_nrst      = 1;
      #1000000  uart_send(8'h11);
      #1000000  uart_send(8'hAA);
      #1000000  uart_send(8'h11);
      #1000000  uart_send(8'hAA);
		$finish;
	end

endmodule
