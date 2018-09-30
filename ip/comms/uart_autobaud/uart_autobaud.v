module uart_autobaud(
   input             i_clk,
   input             i_nrst,
   input             i_transmit,    // Raise to trasmit
   input       [7:0] i_data_tx,     // Transmit this
   input             i_rx,
   output reg        o_busy_tx,
   output reg        o_busy_rx,
   output reg        o_recieved,    // Raised when byte recieved, zero when getting
   output reg  [7:0] o_data_rx,     // This is recieved
   output reg        o_tx
);


   // Params
   parameter   RX_IDLE  = 4'h0,
               RX_START = 4'h1,
               RX_1     = 4'h2,
               RX_2     = 4'h3,
               RX_3     = 4'h4,
               RX_4     = 4'h5,
               RX_5     = 4'h6,
               RX_6     = 4'h7,
               RX_7     = 4'h8,
               RX_8     = 4'h9,
               RX_WAIT  = 4'hA,
   

               TX_IDLE  = 4'h0, 
               TX_START = 4'h1, 
               TX_1     = 4'h2,
               TX_2     = 4'h3,
               TX_3     = 4'h4,
               TX_4     = 4'h5,
               TX_5     = 4'h6,
               TX_6     = 4'h7,
               TX_7     = 4'h8,
               TX_8     = 4'h9,
               TX_WAIT  = 4'hA,
               TX_BUSY  = 4'hB;

   // Internal Regs
   reg [3:0]      state_rx;
   reg [31:0]     count_rx;

   reg [3:0]      state_tx;
   reg [31:0]     count_tx;
   reg [7:0]      shift_tx;
 
   reg            delay_1;
   reg            delay_2;
   reg [31:0]     timer;
   reg [31:0]     baud;
      
   always @(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin

         // RX
         count_rx    <= 0;
         o_data_rx     <= 0;
         o_busy_rx     <= 0;
         state_rx    <= RX_IDLE;

         // TX
         count_tx    <= 0;
         shift_tx    <= 0;
         o_busy_tx     <= 0;
         state_tx    <= TX_IDLE;
         o_tx          <= 1;

         // Autobaud
         baud        <= 32'hFFFFFFFF;
         timer       <= 32'h0;
         delay_1     <= 1'b0;
         delay_2     <= 1'b0;

      end else begin
         // Default to count
         count_rx <= count_rx + 1'b1;
         count_tx <= count_tx + 1'b1;

         
         // Autobaud 
         delay_1     <= i_rx;
         delay_2     <= delay_1;
         if( (delay_2 == delay_1) && (timer != 32'hFFFFFFFF)) begin
            timer    <= timer + 1'b1; 
         end else begin
            timer    <= 32'b0;
            if((timer < baud) && (timer > 32'd1)) begin
               baud <= timer;
               count_rx <= 1'b0;
               count_tx <= 1'b0;
            end 
         end


         // RX state machine
         case(state_rx)
            RX_IDLE:    begin                                     // Wait for incoming
                           count_rx    <= 0;
                           o_recieved    <= 0;
                           if(!i_rx) begin
                              state_rx <= RX_START;
                              o_busy_rx  <= 1; 
                           end
                        end
            RX_START:   if(count_rx == (baud >> 1)) begin             // Half sample
                           state_rx    <= RX_1;
                           count_rx    <= 0;
                        end
            RX_1, 
            RX_2, 
            RX_3, 
            RX_4, 
            RX_5, 
            RX_6, 
            RX_7:       if(count_rx == baud) begin                // Shift in bits
                           o_data_rx    <= {i_rx,o_data_rx[7:1]};
                           count_rx    <= 0;
                           state_rx <= state_rx + 1'b1;
                        end
            RX_8:       if(count_rx == baud) begin                // Last bit
                           o_data_rx     <= {i_rx,o_data_rx[7:1]};
                           count_rx    <= 0;
                           state_rx    <= RX_WAIT;
                           o_recieved    <= 1;
                        end
            RX_WAIT:    begin
                           o_recieved    <= 0;
                           if(i_rx) begin                           // Wait for line to go high
                              o_busy_rx     <= 0;
                              state_rx    <= RX_IDLE;
                              count_rx    <= 0;
                           end
                        end
            default:    state_rx       <= RX_IDLE;
         endcase


         // TX state machine
         case(state_tx)
            TX_IDLE:    begin                                     // When told to transmit take line low
                           count_tx    <= 0;
                           if(i_transmit) begin
                              shift_tx <= i_data_tx;
                              state_tx <= TX_1;
                              o_busy_tx  <= 1;
                              o_tx       <= 0; 
                              
                           end
                        end
            TX_1, 
            TX_2, 
            TX_3, 
            TX_4, 
            TX_5, 
            TX_6, 
            TX_7,
            TX_8:       if(count_tx == baud) begin                // Shift out bits
                           o_tx          <= shift_tx[0];
                           shift_tx    <= shift_tx >> 1;
                           count_tx    <= 0;
                           state_tx <= state_tx + 1'b1;
                        end
            TX_WAIT:    if(count_tx == baud) begin                // Return line high and wait
                           state_tx    <= TX_BUSY;
                           o_tx          <= 1;
                           count_tx    <= 0;
                        end
            TX_BUSY:    if(count_tx == baud) begin                // Keep the line high for one baud period
                           state_tx    <= TX_IDLE;
                           o_busy_tx     <= 0; 
                        end
            default:    state_tx       <= TX_IDLE;
         endcase
      end
   end
endmodule
