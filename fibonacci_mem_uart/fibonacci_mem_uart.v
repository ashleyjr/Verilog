///////////////////////////////////////////////////////////
// fibonacci_mem_uart.v
// Uses the fibonacci sequence generator interfaced to 
// memory emulator to write the sequence to the memory.
// Rx side of the memeory emulator is unsued as nothing
// is read from memory.
//
///////////////////////////////////////////////////////////


`timescale 1ns/1ps
module fibonacci_mem_uart(
	input	   wire  i_clk,
	input    wire  i_nrst,
   output   wire  o_tx,
   input    wire  i_rx
);
   parameter   SAMPLE      = 1250,  // BAUD = 9600 with 12MHz clk
               DATA_WIDTH  = 16,
               ADDR_WIDTH  = 32;
        
   wire  [ADDR_WIDTH-1:0]     addr_f_to_m;
   wire  [DATA_WIDTH-1:0]     data_f_to_m;
   wire  [DATA_WIDTH-1:0]     data_m_to_f;
   wire                       write_valid_f_to_m;
   wire                       write_accept_m_to_f;

	mem_uart #(
      .DATA_WIDTH       (DATA_WIDTH          ),
      .ADDR_WIDTH       (ADDR_WIDTH          ),
      .SAMPLE           (SAMPLE              )
   ) m (
		.i_clk	         (i_clk               ),
		.i_nrst           (i_nrst              ),
      .i_data           (data_f_to_m         ),
      .i_addr           (addr_f_to_m         ),
      .o_data           (data_m_to_f         ),
      .i_read_valid     (read_valid          ),
      .o_read_accept    (read_accept         ),
      .i_write_valid    (write_valid         ),
      .o_write_accept   (write_accept        ),
      .i_uart_rx        (i_rx                ),
      .o_uart_tx        (o_tx                )
	);

	fibonacci #(
      .DATA_WIDTH       (DATA_WIDTH          ),
      .ADDR_WIDTH       (ADDR_WIDTH          )
   ) f (
      .i_clk            (i_clk               ),
      .i_nrst           (i_nrst              ),
      .o_addr           (addr_f_to_m         ),
      .o_data           (data_f_to_m         ),
      .i_data           (data_m_to_f         ),
      .o_read_valid     (read_valid          ),
      .i_read_accept    (read_accept         ),
      .o_write_valid    (write_valid         ),
      .i_write_accept   (write_accept        )
	);



endmodule
