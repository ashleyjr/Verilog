///////////////////////////////////////////////////////////
// mem_uart.v
// Memory emulator. Provides design with large memory.
// Script provides memory and allows debug.
// DUT <-Parallel-> mem_uart <-UART-> Script
//
//
// UART
//    Baud = 9600
//    [0 1 2 3 4 5 6 7]
//    [D D D D 0 0 0 1] - Start of data
//    [D D D D 0 0 1 0] - Start of address
//    [A A A A 0 1 0 0] - End of data/address and write 
//    [A A A A 1 0 0 0] - End of data/addredd and read
//
///////////////////////////////////////////////////////////


`timescale 1ns/1ps

module mem_uart(
	input    wire				         i_clk,
	input    wire				         i_nrst,

   // Memory
   input    wire  [DATA_WIDTH-1:0]  i_data,
   input    wire  [ADDR_WIDTH-1:0]  i_addr,
   output   reg   [DATA_WIDTH-1:0]  o_data,
   input    wire                    i_read_valid,
   output   reg                     o_read_accept,
   input    wire                    i_write_valid,
   output   reg                     o_write_accept

   // UART
   input    wire                    i_rx,
   output   wire                    o_tx	
);

   parameter   DATA_WIDTH  =  DATA_NIBBLES << 2;
   parameter   ADDR_WIDTH  =  ADDR_NIBBLES << 2;
   parameter   SAMPLE      =  1250;                 // SAMPLE = CLK_HZ / BAUDRATE


   parameter   SM_IDLE
               SM_WRITE

   wire  [DATA_WIDTH+ADDR_WIDTH-1:0]         in;
   reg   [$clog2(DATA_WIDTH+ADDR_WIDTH)-1:0] nibble_ptr;
   wire  [$clog2(DATA_WIDTH+ADDR_WIDTH)+2:0] bit_ptr;
   assign bit_ptr = nibble_ptr << 2;
   assign in = {i_addr,i_data};
   assign tx_nibble = in[bit_ptr+3:bit_ptr];

   always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         o_data         <= 'b0;
         o_read_accept  <= 1'b0;
         i_write_accept <= 1'b0;
		end else begin
	      case(state) 
            SM_IDLE: if(i_read_valid) 
      
            SM_READ  begin 
                                                
                     end

         endcase
      end
	end

   uart_rx #(
      .SAMPLE     (SAMPLE           )   
   ) uart_rx (
      .i_clk      (i_clk            ),
      .i_nrst     (i_nrst           ),
      .o_data     (i_data[]   ),
      .i_rx       (i_rx             ),
      .o_valid    (rx_2_fifo_valid  ),
      .i_accept   (1'b1             )
	);

   uart_tx #(
      .SAMPLE     (SAMPLE                    )
   ) uart_tx (
	   .i_clk      (i_clk                     ),
      .i_nrst     (i_nrst                    ),
      .i_data     ({in[ptr+3:ptr],cmd}   ),
      .o_tx       (o_tx                      ),
      .i_valid    (uart_tx_i_valid           ),
      .o_accept   (uart_tx_o_accept          )
   );


endmodule
