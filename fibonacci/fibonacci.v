///////////////////////////////////////////////////////////
// fibonacci.v
// Generates a fibonacci sequence to write to memory.
// Ouput o_write_valid is always valid as addition 
// happens on a single cycle. Updated when i_write_accept
// is returned.
//
///////////////////////////////////////////////////////////

`timescale 1ns/1ps
module fibonacci(
	input	   wire			               i_clk,
	input	   wire			               i_nrst,
   output   reg   [ADDR_WIDTH-1:0]     o_addr,
   output   reg   [DATA_WIDTH-1:0]     o_data,
   input    wire  [DATA_WIDTH-1:0]     i_data,
   output   wire                       o_read_valid,
   input    wire                       i_read_accept,
   output   wire                       o_write_valid,
   input    wire                       i_write_accept	
);

   parameter   ADDR_WIDTH  = 0,
               DATA_WIDTH  = 0,
               SM_READ1    = 2'b00,
               SM_READ2    = 2'b01,
               SM_WRITE    = 2'b10;

   reg   [1:0]             state;

   assign o_read_valid  = (state == SM_READ1) || (state == SM_READ2);
   assign o_write_valid = (state == SM_WRITE);

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
		   state    <= SM_READ1;
         o_addr   <= 'b0;
      end else begin
         case(state)
            SM_READ1:   if(i_read_accept) begin
                           state    <= SM_READ2;
                           o_addr   <= o_addr + 'b1;
                           o_data   <= i_data;
                        end
            SM_READ2:   if(i_read_accept) begin
                           state    <= SM_WRITE;
                           o_addr   <= o_addr + 'b1;
                           o_data   <= o_data + i_data;
                        end
            SM_WRITE:   if(i_write_accept) begin
                           state    <= SM_READ1;
                           o_addr   <= o_addr - 'b1;
                        end
         endcase
      end
	end
endmodule
