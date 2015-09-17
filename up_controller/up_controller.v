module up_controller(
	input			         clk,
	input			         nRst,
	input			         int,
	input	     [3:0]	   ir,
   input                z,
	input 			      mem_re,
	output reg [4:0]     op,
	output reg			   ir_we,
	output reg           pc_we,
	output reg [2:0]     rb_sel_in,
	output reg           rb_we,
	output reg           sp_we,
	output reg           mem_we,
   output reg           z_we,
	output reg           ale
);

   parameter   FETCH_LATCH    = 3'b001,
               FETCH_READ     = 3'b010,
               EXECUTE_1      = 3'b011,
               EXECUTE_2      = 3'b100,
               EXECUTE_3      = 3'b101;

   reg [2:0]   state;
   
   reg         int_onoff;
   reg         int_last;
   wire        int_detect;
   assign      int_detect = int & (int_last ^ int) & int_onoff;

   always @(*) begin
      op          = {1'b0,ir};  // Defaults
      ir_we       = 1'b0;
      pc_we       = 1'b0;
      rb_sel_in   = 3'b100;
      rb_we       = 1'b0;
      sp_we       = 1'b0;
      mem_we      = 1'b0;
      ale         = 1'b0;
      z_we        = 1'b0;
      case(state)
         FETCH_LATCH:      begin
                              if(int_detect) begin
                                 op          = 5'b10000;
                                 pc_we       = 1'b1;
                              end else begin
                                 if(int_last) 
                                    op       = 5'b11110;  // Address 0x80 and above
                                 else
                                    op       = 5'b11101;  // PC shifted right out
                                 ale         = 1'b1;
                              end
                           end
         FETCH_READ:       begin
                              op          = 5'b11111; // PC out
                              ir_we       = 1'b1;
                              pc_we       = 1'b1;
                           end
         EXECUTE_1:        casez(ir)
                              4'b00??:    begin
                                             rb_we          = 1'b1;
                                             z_we           = 1'b1;
                                          end
                              4'b0100,
                              4'b0101,
                              4'b0110:    begin
                                             rb_sel_in   = {1'b1,ir[1:0]};
                                             rb_we       = 1'b1;
                                          end
                              4'b0111:    begin
                                             rb_sel_in   = 3'b110;
                                             rb_we       = 1'b1;
                                          end
                              4'b100?:    ale            = 1'b1;      
                              4'b1011:    rb_we          = 1'b1;
                              4'b110?:    ale            = 1'b1;
                           endcase
         EXECUTE_2:        casez(ir)
                              4'b0100,
                              4'b0101,
                              4'b0110:    begin
                                             rb_sel_in   = {1'b1,(ir[1:0] + 1'b1)};  
                                             rb_we       = 1'b1;
                                          end
                              4'b0111:    begin
                                             pc_we       = 1'b1;
                                          end
                              4'b1000:    begin
                                             rb_sel_in   = 3'b010;
                                             rb_we       = 1'b1;
                                          end
                              4'b1001:    begin
                                             op          = 5'b11000;
                                             mem_we      = 1'b1;
                                          end
                              4'b1100:    begin
                                             op          = 5'b01000;
                                             mem_we      = 1'b1;
                                          end
                              4'b1101:    begin
                                             rb_sel_in   = 3'b011;
                                             rb_we       = 1'b1;
                                          end
                           endcase
         EXECUTE_3:        casez(ir)
                              4'b0100,
                              4'b0101,
                              4'b0110:    begin
                                             rb_sel_in   = {1'b1,ir[1:0]};  
                                             rb_we       = 1'b1;
                                          end
                              4'b0111:    begin
                                             rb_sel_in   = 3'b110;
                                             rb_we       = 1'b1;
                                          end
                              4'b1100:    begin
                                             op          = 5'b11011;
                                             sp_we       = 1'b1;
                                          end
                              4'b1101:    begin
                                             op          = 5'b11010;
                                             sp_we       = 1'b1;
                                          end
                           endcase
      endcase
   end


   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state       <= FETCH_LATCH;
         int_last    <= 1'b0;
         int_onoff   <= 1'b0;
      end else begin
         case(state)
            FETCH_LATCH:   if(int_detect)  
                           begin
                                                state <= FETCH_LATCH; 
                                                int_last <= int; 
                           end else begin
                                                state <= FETCH_READ;
                           end
            FETCH_READ:                         state <= EXECUTE_1;
            EXECUTE_1:     casez(ir)
                              4'b01??,
                              4'b100?,
                              4'b110?:          state <= EXECUTE_2;
                              4'b1010:          begin
                                                   int_onoff <= ~int_onoff;
                                                   state <= FETCH_LATCH;
                                                end
                              default:          state <= FETCH_LATCH;
                           endcase     
            EXECUTE_2:     casez(ir)
                              4'b100?:          state <= FETCH_LATCH;
                              default:          state <= EXECUTE_3;
                           endcase
            EXECUTE_3:                          state <= FETCH_LATCH; 
         endcase
      end
   end endmodule
