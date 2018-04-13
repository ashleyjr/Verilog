///////////////////////////////////////////////////////////
// mem_uart.v
// Memory emulator. Provides design with large memory
// through a UART connection.
// Script provides memory and allows debug.
// DUT <-Parallel-> mem_uart <-UART-> Script
//
//
// UART
//    Baud = 9600
//    [7 6 5 4 3 2 1 0]
//    [D D D D 0 0 0 0] - Mid transmission
//    [D D D D 0 0 0 1] - Start of data
//    [D D D D 0 0 1 0] - Start of address
//    [D D D D 0 1 0 0] - End of data/address and write 
//    [D D D D 1 0 0 0] - End of data/address and read
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
   output   reg                     o_write_accept,

   // UART
   input    wire                    i_uart_rx,
   output   wire                    o_uart_tx	
);

   parameter   DATA_WIDTH        = 0;
   parameter   ADDR_WIDTH        = 0;
   parameter   DATA_NIBBLE_WIDTH = DATA_WIDTH >> 2;
   parameter   ADDR_NIBBLE_WIDTH = ADDR_WIDTH >> 2;
   parameter   NIBBLE_WIDTH      = DATA_NIBBLE_WIDTH + ADDR_NIBBLE_WIDTH;
   parameter   DATA_BYTE_WIDTH   = DATA_WIDTH >> 3;
   parameter   SAMPLE            = 0;             

   parameter   SM_IDLE           = 3'h0, 
               SM_WRITE_VALID    = 3'h1,
               SM_WRITE_ACCEPT   = 3'h2,
               SM_READ_VALID     = 3'h3,
               SM_READ_ACCEPT    = 3'h4,
               SM_READ_RX        = 3'h5;

   parameter   CMD_TRANS         = 4'b0000,
               CMD_DATA_START    = 4'b0001,
               CMD_ADDR_START    = 4'b0010,
               CMD_END_WRITE     = 4'b0100,
               CMD_END_READ      = 4'b1000;

   reg      [2:0]                               state;
   reg      [$clog2(DATA_WIDTH+ADDR_WIDTH)-1:0] nibble_ptr;
   wire     [DATA_WIDTH+ADDR_WIDTH-1:0]         data_addr;
   wire     [3:0]                               cmd,
                                                write_cmd,
                                                read_cmd;
   wire     [7:0]                               uart_rx_o_data;
   wire     [3:0]                               uart_tx_i_data;

   assign   cmd         =  (  (state == SM_WRITE_VALID   )  ||
                              (state == SM_WRITE_ACCEPT  )  )?        write_cmd         : 
                                                                     read_cmd;
   
   assign   write_cmd   =  (nibble_ptr == 'b0                  )  ?  CMD_ADDR_START    :
                           (nibble_ptr == ADDR_NIBBLE_WIDTH-1  )  ?  CMD_END_WRITE     :
                           (nibble_ptr == NIBBLE_WIDTH-1       )  ?  CMD_END_WRITE     :
                           (nibble_ptr == ADDR_NIBBLE_WIDTH    )  ?  CMD_DATA_START    :
                                                                     CMD_TRANS;

   assign   read_cmd    =  (nibble_ptr == 'b0                  )  ?  CMD_ADDR_START    :
                           (nibble_ptr == ADDR_NIBBLE_WIDTH-1  )  ?  CMD_END_READ      :
                                                                     CMD_TRANS;


   assign   uart_tx_i_valid = (state == SM_WRITE_ACCEPT) | (state == SM_READ_ACCEPT);

   assign   data_addr = {i_data,i_addr};

   assign   uart_tx_i_data[0] = data_addr[      (nibble_ptr << 2)];
   assign   uart_tx_i_data[1] = data_addr[1 +   (nibble_ptr << 2)];
   assign   uart_tx_i_data[2] = data_addr[2 +   (nibble_ptr << 2)];
   assign   uart_tx_i_data[3] = data_addr[3 +   (nibble_ptr << 2)];


   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         o_data         <= 'b0;
         o_read_accept  <= 1'b0;
         o_write_accept <= 1'b0;
         state          <= SM_IDLE;
		end else begin
	      case(state)
            SM_IDLE:          begin
                                 o_write_accept <= 1'b0;
                                 o_read_accept <= 1'b0;
                                 nibble_ptr  <= 'b0;
                                 if(i_read_valid)
                                     state   <= SM_READ_VALID;
                                 if(i_write_valid)
                                     state   <= SM_WRITE_VALID; 
                              end

            // Write sequence
            SM_WRITE_VALID:   begin 
                                 state       <= SM_WRITE_ACCEPT; 
                              end                     
            SM_WRITE_ACCEPT:  if(uart_tx_o_accept)
                                 if(nibble_ptr == NIBBLE_WIDTH-1) begin
                                    state    <= SM_IDLE;
                                    o_write_accept  <= 1'b1;
                                 end else begin
                                    state    <= SM_WRITE_VALID;
                                    nibble_ptr  <= nibble_ptr + 'b1; 
                                 end
            // Read sequence
            SM_READ_VALID:    begin
                                 state       <= SM_READ_ACCEPT;
                                 nibble_ptr  <= nibble_ptr;
                              end
            SM_READ_ACCEPT:   if(uart_tx_o_accept) begin
                                 nibble_ptr  <= nibble_ptr + 'b1; 
                                 if(nibble_ptr == ADDR_NIBBLE_WIDTH-1) begin
                                    state       <= SM_READ_RX;
                                    nibble_ptr  <= 'b0;
                                 end else
                                    state       <= SM_READ_VALID;
                              end
            SM_READ_RX:       if(uart_rx_o_valid) begin
                                 o_data <= {o_data[DATA_WIDTH-9:0], uart_rx_o_data};
                                 if(nibble_ptr == (DATA_BYTE_WIDTH-1)) begin
                                    state          <= SM_IDLE;
                                    o_read_accept  <= 1'b1;
                                 end
                                 nibble_ptr <= nibble_ptr + 'b1;
                              end
         endcase
      end
	end

   uart_rx #(
      .SAMPLE     (SAMPLE                 )   
   ) uart_rx (
      .i_clk      (i_clk                  ),
      .i_nrst     (i_nrst                 ),
      .o_data     (uart_rx_o_data         ),
      .i_rx       (i_uart_rx              ),
      .o_valid    (uart_rx_o_valid        ),
      .i_accept   (1'b1                   )
	);

   uart_tx #(
      .SAMPLE     (SAMPLE                 )
   ) uart_tx (
	   .i_clk      (i_clk                  ),
      .i_nrst     (i_nrst                 ),
      .i_data     ({uart_tx_i_data,cmd}   ),
      .o_tx       (o_uart_tx              ),
      .i_valid    (uart_tx_i_valid        ),
      .o_accept   (uart_tx_o_accept       )
   );


endmodule
