`timescale 1ns/1ps
module multiply_mem_uart(
	input				i_clk,
	input				i_nrst,
   input          i_rx,
   output         o_tx
);

   parameter   SAMPLE            = 1250,           // BAUD = 9600 with 12MHz clk
               DATA_WIDTH        = 128,
               HALF_DATA_WIDTH   = DATA_WIDTH/2,
               ADDR_WIDTH        = 8,
               SM_READ           = 2'b00,
               SM_MUL            = 2'b01,
               SM_WRITE          = 2'b10;

   wire  [DATA_WIDTH-1:0]  mul_to_mem,
                           mem_to_mul;
   
   reg   [ADDR_WIDTH-1:0]  addr;

   reg   [1:0]             state;
   
   wire                    i_read_valid,
                           o_read_accept,
                           i_mul_read,
                           o_mul_accept,
                           i_write_valid,
                           o_write_accept;

   assign   i_read_valid   = (state == SM_READ);
   assign   i_mul_valid    = (state == SM_MUL);
   assign   i_write_valid  = (state == SM_WRITE);

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
	      addr     <= 'b0;	
         state    <= SM_READ;
		end else begin
	      case(state)
            SM_READ:    if(o_read_accept)
                           state <= SM_MUL;
            SM_MUL:     if(o_mul_accept)
                           state <= SM_WRITE;
            SM_WRITE:   if(o_write_accept) begin
                           state <= SM_READ;
                           addr  <= addr + 'b1;
                        end
         endcase
      end
	end

   mem_uart #(
      .DATA_WIDTH       (DATA_WIDTH                               ),
      .ADDR_WIDTH       (ADDR_WIDTH                               ),
      .SAMPLE           (SAMPLE                                   )
   ) mem_uart(
		.i_clk	         (i_clk                                    ),
		.i_nrst           (i_nrst                                   ),
      .i_data           (mul_to_mem                               ),
      .i_addr           (addr                                     ),
      .o_data           (mem_to_mul                               ),
      .i_read_valid     (i_read_valid                             ),
      .o_read_accept    (o_read_accept                            ),
      .i_write_valid    (i_write_valid                            ),
      .o_write_accept   (o_write_accept                           ),
      .i_uart_rx        (i_rx                                     ),
      .o_uart_tx        (o_tx                                     )
	);

   shift_and_add_multiplier #(
      .DATA_WIDTH_A     (HALF_DATA_WIDTH                          ),
      .DATA_WIDTH_B     (HALF_DATA_WIDTH                          )
   ) shift_and_add_multiplier(
      .i_clk            (i_clk                                    ),
      .i_nrst           (i_nrst                                   ),
      .i_a              (mem_to_mul[HALF_DATA_WIDTH-1:0]          ),
      .i_b              (mem_to_mul[DATA_WIDTH-1:HALF_DATA_WIDTH] ),
      .o_c              (mul_to_mem                               ),
      .i_valid          (i_mul_valid                              ),
      .o_accept         (o_mul_accept                             )
	);
  
endmodule
