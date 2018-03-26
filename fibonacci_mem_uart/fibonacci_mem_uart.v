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
   output   wire  o_tx 
);
   parameter   SAMPLE         = 104167,
               VALUE_WIDTH    = 16,
               SEQUENCE_WIDTH = 8;
        
   wire  [VALUE_WIDTH-1:0]    value_f_to_m;
   wire  [SEQUENCE_WIDTH-1:0] sequence_f_to_m;
   wire                       write_valid_f_to_m;
   wire                       write_accept_m_to_f;

	mem_uart #(
      .DATA_WIDTH       (VALUE_WIDTH         ),
      .ADDR_WIDTH       (SEQUENCE_WIDTH      ),
      .SAMPLE           (SAMPLE              )
   ) m (
		.i_clk	         (i_clk               ),
		.i_nrst           (i_nrst              ),
      .i_data           (value_f_to_m        ),
      .i_addr           (sequence_f_to_m     ),
      .o_data           (                    ),
      .i_read_valid     (1'b0                ),
      .o_read_accept    (                    ),
      .i_write_valid    (write_valid_f_to_m  ),
      .o_write_accept   (write_accept_m_to_f ),
      .i_uart_rx        (1'b1                ),
      .o_uart_tx        (o_tx                )
	);

	fibonacci #(
      .VALUE_WIDTH      (VALUE_WIDTH         ),
      .SEQUENCE_WIDTH   (SEQUENCE_WIDTH      )
   ) f (
      .i_clk            (i_clk               ),
      .i_nrst           (i_nrst              ),
      .o_value          (value_f_to_m        ),
      .o_sequence       (sequence_f_to_m     ),
      .o_write_valid    (write_valid_f_to_m  ),
      .i_write_accept   (write_accept_m_to_f )
	);



endmodule
