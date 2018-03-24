`timescale 1ns/1ps
module mem_uart_tb;

	parameter CLK_PERIOD = 20;

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
      .ADDR_WIDTH       (ADDR_WIDTH       )
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
		$display("                  TIME    i_nrst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
	            i_nrst = 1;
      #77      i_nrst = 0;
      #77      i_nrst = 1;
      #10000
		$finish;
	end

endmodule
