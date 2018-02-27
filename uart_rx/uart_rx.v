///////////////////////////////////////////////////////////
// uart_rx.v
// Recieve only 8-bit UART with fixed baud rate
//
///////////////////////////////////////////////////////////

`timescale 1ns/1ps

module uart_rx(
   input    wire           i_clk,
	input    wire		      i_nrst,
   output   reg   [7:0]    o_data,
   input    wire           i_rx,
	output   reg            o_valid
);

    parameter  SAMPLE      = 1,  
               SM_IDLE     = 2'b00,
               SM_RX_START = 2'b01,
               SM_RX       = 2'b11,
               SM_WAIT     = 2'b10,
               START_BIT   = 8'h80;

   reg [1:0]                   state;
   reg [$clog2(SAMPLE)-1:0]    count;

   assign full_sample = (count == SAMPLE);
   assign half_sample = (count == (SAMPLE >> 1));

   // MSb is set and shifted as a counter for the 8 bits
   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         state    <= SM_IDLE;	
         count    <= 'b0;
         o_valid  <= 1'b0;
         o_data   <= 8'h0;
      end else begin
         count <= count + 'b1;
         case(state)
            SM_IDLE:       if(!i_rx) begin
                              state       <= SM_RX_START;
                              count       <= 'b0;
                              o_valid     <= 1'b0;
                              o_data      <= START_BIT;
                           end
            SM_RX_START:   if(half_sample) begin
                              state       <= SM_RX;
                              count       <= 'b0;
                           end
            SM_RX:         if(full_sample) begin
                              o_data      <= {i_rx,o_data[7:1]}; 
                              count       <= 'b0;
                              if(o_data[0]) begin
                                 state    <= SM_WAIT;
                                 o_valid  <= 1'b1;
                              end
                           end
            SM_WAIT:       if(full_sample) begin
                              state       <= SM_IDLE;  
                           end
         endcase
      end
   end
endmodule
