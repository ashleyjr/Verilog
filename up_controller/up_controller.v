module up_controller(
	input			         clk,
	input			         nRst,
	input			         int,
	input	     [3:0]	   ir,
	input 			      mem_re,
	output reg [4:0]     op,
	output reg			   ir_we,
	output reg           pc_we,
	output reg [2:0]     rb_sel_in,
	output reg           rb_we,
	output reg           sp_we,
	output reg           mem_we,
	output reg           ale
);

   parameter   FETCH_LATCH    = 3'b001,
               FETCH_READ     = 3'b010,
               EXECUTE_1      = 3'b011,
               EXECUTE_2      = 3'b100,
               EXECUTE_3      = 3'b101;

   reg [2:0]   state;


   always @*
      case(state)
         {FETCH_LATCH}:    begin
                              op          = 5'b11101;  // PC shifted right out
                              ir_we       = 1'b0;
                              pc_we       = 1'b0;
                              rb_sel_in   = 3'b000;
                              rb_we       = 1'b0;
                              sp_we       = 1'b0;
                              mem_we      = 1'b0;
                              ale         = 1'b1;
                           end
         {FETCH_READ}:     begin
                              op          = 5'b11111;  // PC + 1 out
                              ir_we       = 1'b0;
                              pc_we       = 1'b0;
                              rb_sel_in   = 3'b000;
                              rb_we       = 1'b0;
                              sp_we       = 1'b0;
                              mem_we      = 1'b0;
                              ale         = 1'b1;
                           end
         {EXECUTE_1}:      always @*
                              case(ir)
                                 4'b0000: begin
                                             op          = 5'b11111;  // PC + 1 out
                                             ir_we         = 1'b0;
                                             pc_we       = 1'b0;
                                             rb_sel_in   = 3'b000;
                                             rb_we       = 1'b0;
                                             sp_we       = 1'b0;
                                             mem_we      = 1'b0;
                                             ale         = 1'b1;
                                          end
                              endcase

      endcase


   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state <= FETCH_LATCH;
      end else begin
         case(state)
            FETCH_LATCH:                     state <= FETCH_READ; 
            FETCH_READ:                      state <= EXECUTE_1;
            EXECUTE_1:     case(ir)
                              4'b01??:       state <= EXECUTE_2;
                              default:       state <= FETCH_LATCH;
                           endcase     
            EXECUTE_2:                       state <= EXECUTE_3;
            EXECUTE_3:                       state <= FETCH_LATCH;
         endcase
      end
   end endmodule
