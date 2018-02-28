///////////////////////////////////////////////////////////
// uart_tx.v
// Transmit only 8-bit UART with fixed baud rate
// 
//    - i_valid   - Raise when data is valid on i_data
//                  After accept has been returned valid 
//                  must be driven low before returning 
//                  high to transmit again
//
//    - o_accept  - Raised when data has been transmitted
//
///////////////////////////////////////////////////////////

`timescale 1ns/1ps

module uart_tx(
   input    wire        i_clk,
   input    wire        i_nrst,
   input    wire  [7:0] i_data,
   output   reg         o_tx,
   input    wire        i_valid,
   output   reg         o_accept
);

   parameter   SAMPLE   = 1,
               TX_IDLE  = 2'b00,
               TX       = 2'b01,
               TX_END_1 = 2'b10,
               TX_END_2 = 2'b11;

   reg   [1:0]                   state;
   reg   [2:0]                   ptr;
   reg   [$clog2(SAMPLE)-1:0]    count;
  
   assign full_sample = (count == SAMPLE);

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         state    <= TX_IDLE;
         o_tx     <= 1'b1;
         ptr      <= 3'h0;
         o_accept <= 1'b0;
         count    <= 'b0;
		end else begin
         count <= count + 'b1;
	      case(state)
            TX_IDLE:    if(i_valid) begin
                           o_tx     <= 1'b0;
                           count    <= 'b0;
                           state    <= TX;
                           ptr      <= 3'b0;
                        end
            TX:         if(full_sample) begin
                           ptr   <= ptr   + 3'h1;
                           o_tx  <= i_data[ptr];
                           if(ptr == 7) begin
                              state    <= TX_END_1;
                              o_accept <= 1'b1;
                              o_tx     <= 1'b1;
                           end
                        end
            TX_END_1,
            TX_END_2:   if(!i_valid) begin
                           state <= TX_IDLE; 
                           o_accept <= 1'b0;
                        end  
         endcase
		end
	end
endmodule
