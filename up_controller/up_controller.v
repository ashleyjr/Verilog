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
               FETCH          = 4'b0100,
               DECODE         = 4'b0101,
               EXECUTE_1      = 4'b0110,
               EXECUTE_2      = 4'b0111,
               EXECUTE_3      = 4'b1000;

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
                           rb_sel   = 3'b010;
                           rb_we    = 2'b1;
                        end
         FETCH:         begin
                           op       = 5'b10100;
                           ale      = 1'b1;
                        end
         DECODE:        begin
                           op       = 5'b10101;
                           ir_we    = 1'b1;
                           pc_we    = 1'b1;
                        end
         EXECUTE_1:     case(ir)
                           4'h0: begin
                                    op       = 5'b00000;
                                    rb_we    = 1'b1;
                                 end
                           4'h1: begin
                                    op       = 5'b00001;
                                    rb_we    = 1'b1;
                                 end
                           4'h2: begin
                                    op       = 5'b00010;
                                    rb_we    = 1'b1;
                                 end
                           4'h3: begin
                                    op       = 5'b00011;
                                    rb_we    = 1'b1;
                                 end
                           4'h4: begin
                                    op       = 5'b00100;
                                    rb_we    = 1'b1;
                                 end
                           4'h5: begin
                                    op       = 5'b00101;
                                    rb_sel   = 3'b101;
                                    rb_we    = 1'b1;
                                 end
                           4'h6: begin
                                    op       = 5'b00110;
                                    rb_sel   = 3'b110;
                                    rb_we    = 1'b1;
                                 end
                        endcase
         EXECUTE_2:     case(ir)
                           4'h4: begin
                                    op       = 5'b00100;
                                    rb_sel   = 3'b101;
                                    rb_we    = 1'b1;
                                 end
                           4'h5: begin
                                    op       = 5'b00101;
                                    rb_sel   = 3'b110;
                                    rb_we    = 1'b1;
                                 end
                           4'h6: begin
                                    op       = 5'b00110;
                                    rb_sel   = 3'b111;
                                    rb_we    = 1'b1;
                                 end
                        endcase
         EXECUTE_3:     case(ir)
                           4'h4: begin
                                    op       = 5'b00100;
                                    rb_we    = 1'b1;
                                 end
                           4'h5: begin
                                    op       = 5'b00101;
                                    rb_sel   = 3'b101;
                                    rb_we    = 1'b1;
                                 end
                           4'h6: begin
                                    op       = 5'b00110;
                                    rb_sel   = 3'b110;
                                    rb_we    = 1'b1;
                                 end
                           endcase
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
            FETCH:         state <= DECODE;
            DECODE:        state <= EXECUTE_1;
            EXECUTE_1:     case(ir)
                              4'h0,4'h1,4'h2,4'h3:    state <= FETCH;
                              4'h4,4'h5,4'h6:         state <= EXECUTE_2;
                           endcase
            EXECUTE_2:     case(ir)
                              4'h4,4'h5,4'h6:         state <= EXECUTE_3;
                           endcase
            EXECUTE_3:     state <= FETCH;
         endcase
      end
   end 

endmodule
