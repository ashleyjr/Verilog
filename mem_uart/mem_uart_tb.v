`timescale 1ns/1ps
module mem_uart_tb;

   // CLK = 12MHz
	parameter CLK_PERIOD = 83;

   // BAUD = 9600
   parameter   SAMPLE         = 1250;     // SAMPLE      = CLK_HZ    / BAUDRATE
   parameter   SAMPLE_TB      = 104167;   // SAMPLE_TB   = 1e9       / BAUDRATE
	

   parameter   DATA_WIDTH  = 16,
               ADDR_WIDTH  = 64;

	reg	                  i_clk;
	reg	                  i_nrst;
   reg   [DATA_WIDTH-1:0]  i_data;
   reg   [ADDR_WIDTH-1:0]  i_addr;
   wire  [DATA_WIDTH-1:0]  o_data;
   reg                     i_read_valid;
   wire                    o_read_accept;
   reg                     i_write_valid;
   wire                    o_write_accept;
   reg                     i_uart_rx;
   wire                    o_uart_tx;

	mem_uart #(
      .DATA_WIDTH       (DATA_WIDTH       ),
      .ADDR_WIDTH       (ADDR_WIDTH       ),
      .SAMPLE           (SAMPLE           )
   ) mem_uart(
		.i_clk	         (i_clk            ),
		.i_nrst           (i_nrst           ),
      .i_data           (i_data           ),
      .i_addr           (i_addr           ),
      .o_data           (o_data           ),
      .i_read_valid     (i_read_valid     ),
      .o_read_accept    (o_read_accept    ),
      .i_write_valid    (i_write_valid    ),
      .o_write_accept   (o_write_accept   ),
      .i_uart_rx        (i_uart_rx        ),
      .o_uart_tx        (o_uart_tx        )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
      $dumpfile("mem_uart.vcd");
		$dumpvars(0,mem_uart_tb);	
	end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         i_uart_rx = 0;
         repeat(8)
            #SAMPLE_TB  i_uart_rx = send[i];
         #SAMPLE_TB  i_uart_rx = 1;
      end
   endtask

   task uart_get;
      output [7:0]   get;    
      output         timeout;
      integer        count;
      begin
         while(o_uart_tx == 1) 
            @(posedge i_clk); 
           
         #(SAMPLE_TB*1.5)
         get = 0;
         repeat(7) begin 
            get[7]   = o_uart_tx;
            get      = get >> 1;
            #SAMPLE_TB;
         end
         get[7]      = o_uart_tx;
         $display("%tps       uart_get = %x",$time,get); 
      end
   endtask

   reg   [7:0]    uart;
   reg            timeout;

	initial begin
               // Initial
               i_uart_rx      = 1'b1;
               i_write_valid  = 1'b0;
               i_read_valid   = 1'b0;

               // Reset
	            i_nrst         = 1'b1;
      #77      i_nrst         = 1'b0;
      #77      i_nrst         = 1'b1;

               // Test
      #7777    i_data         = 16'hABCD;
               i_addr         = 64'h0123456789ABCDEF;
               i_write_valid  = 1'b1;

               timeout = 0;
               repeat(21)
                  uart_get(uart, timeout); 
		$finish;
	end

endmodule
