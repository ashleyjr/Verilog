///////////////////////////////////////////////////////////
// shift_and_add_multiplier.v
// Perform multiplication of binary numbers using shift 
// and add algorithm. Raise i_valid to begin and 
// multiplication ready when o_accept asserted,
//
///////////////////////////////////////////////////////////


`timescale 1ns/1ps

module sequential_multiplier(
	input	   wire                       i_clk,
	input    wire                       i_nrst,
	input		wire  [DATA_WIDTH_A-1:0]   i_a,
	input    wire  [DATA_WIDTH_B-1:0]   i_b,
   output   reg   [DATA_WIDTH_C-1:0]   o_c,
	input	   wire                       i_valid,
	output	wire	                     o_accept
);

   parameter   DATA_WIDTH_A   = 0,
               DATA_WIDTH_B   = 0,
               DATA_WIDTH_C   = DATA_WIDTH_A + DATA_WIDTH_B,
               SM_IDLE        = 1'b0,
               SM_MUL         = 1'b1;

   reg   [DATA_WIDTH_A-1:0]   a;
   reg   [DATA_WIDTH_C-1:0]   b_ext;
   reg                        state;

   assign o_accept = ((a == 0) && (state == SM_MUL));

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         o_c      <= 'b0;
         state    <= SM_IDLE;
		end else begin    
         case(state)
            SM_IDLE: if(i_valid) begin
                        state    <= SM_MUL;
                        a        <= i_a;
                        b_ext    <= i_b;
                        o_c      <= 'b0;
                     end else begin
                        state    <= SM_IDLE;
                     end
            SM_MUL:  begin
                        a        <= a >> 1;
                        b_ext    <= b_ext << 1;
                        if(a[0]) begin
                           o_c   <= o_c + b_ext;
                        end else begin
                           if(o_accept)
                              state <= SM_IDLE;
                        end
                     end
         endcase 
		end
	end
endmodule
