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

   parameter   DATA_WIDTH        = 32;
   parameter   ADDR_WIDTH        = 32;
   parameter   DATA_NIBBLE_WIDTH = DATA_WIDTH >> 2;
   parameter   ADDR_NIBBLE_WIDTH = ADDR_WIDTH >> 2;
   parameter   NIBBLE_WIDTH      = DATA_NIBBLE_WIDTH + ADDR_NIBBLE_WIDTH;
   parameter   SAMPLE            =  1250;             // SAMPLE = CLK_HZ / BAUDRATE


   parameter   SM_IDLE
               SM_WRITE

   parameter   CMD_TRANS         = 4'b0000,
               CMD_DATA_START    = 4'b0001,
               CMD_ADDR_START    = 4'b0010,
               CMD_END_WRITE     = 4'b0100,
               CMD_END_READ      = 4'b1000;

   wire  [DATA_WIDTH+ADDR_WIDTH-1:0]         in;
   reg   [$clog2(DATA_WIDTH+ADDR_WIDTH)-1:0] nibble_ptr;
   wire  [$clog2(DATA_WIDTH+ADDR_WIDTH)+2:0] bit_ptr;
   
   assign bit_ptr = nibble_ptr << 2;
   assign in = {i_addr,i_data};
   assign tx_nibble = in[bit_ptr+3:bit_ptr];

   wire   [3:0]   cmd,
                  write_cmd,
                  read_cmd;

   assign   cmd         =  (state == SM_WRITE                  )  ?  write_cmd : 
                                                                     read_cmd;
   
   assign   write_cmd   =  (nibble_ptr == 'b0                  )  ?  CMD_ADDR_START    :
                           (nibble_ptr == ADDR_NIBBLE_WIDTH-1  )  ?  CMD_END_WRITE     :
                           (nibble_ptr == NIBBLE_WIDTH-1       )  ?  CMD_END_WRITE     :
                           (nibble_ptr == ADDR_NIBBLE_WIDTH    )  ?  CMD_DATA_START    :
                                                                     CMD_TRANS;

   assign   read_cmd    =  (nibble_ptr == 'b0                  )  ?  CMD_ADDR_START    :
                           (nibble_ptr == ADDR_NIBBLE_WIDTH-1  )  ?  CMD_END_READ      :
                                                                     CMD_TRANS;



   always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         o_data         <= 'b0;
         o_read_accept  <= 1'b0;
         o_write_accept <= 1'b0;
		end else begin
	      case(state)
            SM_IDLE:    case({i_read_valid, i_write_valid})
                           2'b10:   state <= SM_READ;
                           2'b01:   begin
                                       state             <= SM_WRITE;
                                       nibble_ptr        <= 'b0;
                                       cmd               <= CMD_ADDR_START;
                                       uart_tx_i_valid   <= 1'b1;
                                    end
                        endcase


            SM_WRITE_VALID:   begin
                                    uart_tx_i_valid   <= 1'b1;
                        
                              end
            SM_WRITE_ACCEPT:  begin
                                 nibble_ptr <= nibble_ptr + 'b1;
                                 case({nibble_ptr})
                                    ADDR_NIBBLE_WIDTH-1,
                                    NIBBLE_WIDTH-1:         cmd <= CMD_END_WRITE;
                                    ADDR_NIBBLE_WIDTH:      cmd <= CMD_START_WRITE
                                    default:                cmd <= CMD_TRANS; 
                                 endcase
                              end
                                       
            begin
                                 if(uart_tx_o_accept) begin
                                    if(nibble_ptr == ADDR_NIBBLE_WIDTH
                                 end
                              end



            SM_READ: begin 
                                                    
                     end

         endcase
      end
	end

   uart_rx #(
      .SAMPLE     (SAMPLE                    )   
   ) uart_rx (
      .i_clk      (i_clk                     ),
      .i_nrst     (i_nrst                    ),
      .o_data     (i_data[nibbl]   ),
      .i_rx       (i_uart_rx        ),
      .o_valid    (uart_rx_o_valid  ),
      .i_accept   (1'b1                      )
	);

   uart_tx #(
      .SAMPLE     (SAMPLE                    )
   ) uart_tx (
	   .i_clk      (i_clk                     ),
      .i_nrst     (i_nrst                    ),
      .i_data     ({i_data[nibble_ptr],cmd}  ),
      .o_tx       (o_uart_tx                 ),
      .i_valid    (uart_tx_i_valid           ),
      .o_accept   (uart_tx_o_accept          )
   );


endmodule
