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
	output reg [2:0]     rb_sel,
	output reg           rb_we,
	output reg           sp_we,
	output reg           mem_we,
	output reg           ale
);

   parameter   LOAD_REGS_0    = 4'b0000,
               LOAD_REGS_1    = 4'b0001,
               LOAD_REGS_2    = 4'b0010,
               LOAD_REGS_3    = 4'b0011,
               FETCH          = 4'b0100;

   reg [3:0]   state;
   

   always @(*) begin
      op          = 5'b00000;  // Defaults
      ir_we       = 1'b0;
      pc_we       = 1'b0;
      rb_sel      = 3'b100;
      rb_we       = 1'b0;
      sp_we       = 1'b0;
      mem_we      = 1'b0;
      ale         = 1'b0;
      case(state)
         LOAD_REGS_0:   begin
                           op       = 5'b10000;
                           ale      = 1'b1;
                        end
         LOAD_REGS_1:   begin
                           op       = 5'b10001;
                           rb_sel   = 3'b000;
                           rb_we    = 2'b1;
                           ale      = 1'b1;
                        end
         LOAD_REGS_2:   begin
                           op       = 5'b10011;
                           rb_sel   = 3'b001;
                           rb_we    = 2'b1;
                           ale      = 1'b1;
                        end
         LOAD_REGS_3:   begin
                           op       = 5'b10010;
                           pc_we    = 1'b1;
                           rb_sel   = 3'b010;
                           rb_we    = 2'b1;
                        end
      endcase
   end


   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state       <= LOAD_REGS_0;
      end else begin
         case(state)
            LOAD_REGS_0:   state <= LOAD_REGS_1;
            LOAD_REGS_1:   state <= LOAD_REGS_2;
            LOAD_REGS_2:   state <= LOAD_REGS_3;
            LOAD_REGS_3:   state <= FETCH;
         endcase
      end
   end 

endmodule
