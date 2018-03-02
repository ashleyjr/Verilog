`timescale 1ns/1ps

module uart_tx_tb;

   // CLK = 12 MHz
	parameter   CLK_PERIOD_NS  = 83;

   // BAUD = 115200
   parameter   SAMPLE         = 104;      // SAMPLE      = CLK_HZ    / BAUDRATE
   parameter   SAMPLE_TB      = 8681;     // SAMPLE_TB   = 1e9       / BAUDRATE
	
   reg	      i_clk;
	reg	      i_nrst;
   reg   [7:0] i_data;  
   wire        o_tx;
   reg         i_valid;
   wire        o_accept;


	uart_tx #(
      .SAMPLE     (SAMPLE     )
   ) uart_tx (
	   .i_clk      (i_clk      ),
      .i_nrst     (i_nrst     ),
      .i_data     (i_data     ),
      .o_tx       (o_tx       ),
      .i_valid    (i_valid    ),
      .o_accept   (o_accept   )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD_NS/2) i_clk = 0;
			#(CLK_PERIOD_NS/2) i_clk = 1;
		end
	end

	initial begin
		$dumpfile("uart_tx.vcd");
		$dumpvars(0,uart_tx_tb);	
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,i_nrst);
	end
   
   task uart_send;
      input [7:0] send;
      integer i;
      begin 
         i_data   = send;
         i_valid  = 1;
         while(!o_accept)
            @(posedge i_clk);
         i_valid  = 0;
      end
   endtask

   integer i;

	initial begin
		#100     i_nrst   = 1;
		#170		i_nrst   = 0;
               i_valid  = 0;
		#170		i_nrst   = 1;	
      for(i=0;i<256;i=i+1) begin
         #100000  uart_send(i);
      end
      $finish;
	end

endmodule
