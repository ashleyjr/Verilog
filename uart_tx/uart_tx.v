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
   output   wire        o_tx,
   input    wire        i_valid,
   output   wire        o_accept
);

   parameter   SAMPLE   =  1,
               TX1      =  4'h0,
               TX2      =  4'h1,
               TX3      =  4'h2,
               TX4      =  4'h3,
               TX5      =  4'h4,
               TX6      =  4'h5,
               TX7      =  4'h6,
               TX8      =  4'h7,
               TX_END   =  4'h8,
               TX_IDLE  =  4'h9,
               TX_START =  4'hA;

   reg   [3:0]                   state;
   reg   [$clog2(SAMPLE)-1:0]    count;
  
   assign   full_sample =  (count == SAMPLE  );
   assign   o_accept    =  (state == TX_END  );
   assign   o_tx        =  (state == TX_IDLE )  ?  1'b1                 :
                           (state == TX_START)  ?  1'b0                 :
                           (state == TX_END  )  ?  1'b1                 :
                                                   i_data[state[2:0]]   ;  // TX? 
   
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         state    <= TX_IDLE;  
         count    <= 'b0;
		end else begin
         if(full_sample) begin
            count <= 'b0;
         end else begin
            count <= count + 'b1;
         end
	      case(state)
            TX_IDLE:    if(i_valid & full_sample)  
                           state    <= TX_START;
            TX_START:   if(full_sample)   
                           state     <= TX1;
            TX1,
            TX2,
            TX3,
            TX4,
            TX5,
            TX6,
            TX7,
            TX8:        if(full_sample)   
                           state    <= state + 4'h1;  
            TX_END:     if(!i_valid)      
                           state    <= TX_IDLE;  
         endcase
		end
	end
endmodule
