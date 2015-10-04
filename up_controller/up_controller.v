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

   parameter   LOAD_REGS_0    = 4'h0,
               LOAD_REGS_1    = 4'h1,
               LOAD_REGS_2    = 4'h2,
               LOAD_REGS_3    = 4'h3,
               LOAD_REGS_4    = 4'h4,
               FETCH          = 4'h5,
               DECODE         = 4'h6,
               EXECUTE_1      = 4'h7,
               EXECUTE_2      = 4'h8,
               EXECUTE_3      = 4'h9,
               INT_1          = 4'hA,
               INT_2          = 4'hB,
               INT_3          = 4'hC,
               INT_4          = 4'hD;

   reg [3:0]   state;

   reg         int_on_off;
   reg         int_last;
   reg         int_in;
   wire        int_go;

   assign int_go = (int ^ int_last) & int & int_on_off & ~int_in;

   always @(*) begin
      op          = {1'b0,ir};  // Defaults
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
                           rb_we    = 1'b1;
                           ale      = 1'b1;
                        end
         LOAD_REGS_2:   begin
                           op       = 5'b10010;
                           rb_sel   = 3'b001;
                           rb_we    = 2'b1;
                           ale      = 1'b1;
                        end
         LOAD_REGS_3:   begin
                           op       = 5'b10011;
                           rb_sel   = 3'b010;
                           rb_we    = 1'b1;
                           ale      = 1'b1;
                        end
         LOAD_REGS_4:   begin
                           rb_sel   = 3'b011;
                           rb_we    = 2'b1;
                        end
         FETCH:         begin
                           if(int_in)  op       = 5'b11110;
                           else        op       = 5'b10100;
                           ale      = 1'b1;
                        end
         DECODE:        begin
                           op       = 5'b10101;
                           ir_we    = 1'b1;
                           pc_we    = 1'b1;
                        end
         EXECUTE_1:     case(ir)
                           4'h0,4'h1,4'h2,4'h3,4'h4:  rb_we    = 1'b1;
                           4'h5: begin 
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                 end
                           4'h6: begin                rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                 end
                           4'h7: if(z) begin
                                                      op       = 5'b10110;
                                                      pc_we    = 1'b1;
                                 end
                           4'h8: begin
                                    op       = 5'b10111;
                                    sp_we    = 1'b1;
                                    ale      = 1'b1;
                                 end
                           4'h9: begin
                                    op       = 5'b11001;
                                    ale      = 1'b1;
                                 end
                           4'hA: begin
                                    op       = 5'b10111;
                                    sp_we    = 1'b1;
                                    ale      = 1'b1;
                                 end
                           4'hB: begin
                                    op       = 5'b11001;
                                    ale      = 1'b1;
                                 end
                           4'hC: begin
                                    op       = 5'b10110;
                                    ale      = 1'b1;
                                 end
                           4'hD: begin
                                    op       = 5'b10110;
                                    ale      = 1'b1;
                                 end
                           4'hE: begin
                                    op       = 5'b10000;
                                    ale      = 1'b1;
                                 end
                        endcase
         EXECUTE_2:     case(ir)
                           4'h4: begin
                                    rb_sel   = 3'b101;
                                    rb_we    = 1'b1;
                                 end
                           4'h5: begin
                                    rb_sel   = 3'b110;
                                    rb_we    = 1'b1;
                                 end
                           4'h6: begin
                                    rb_sel   = 3'b111;
                                    rb_we    = 1'b1;
                                 end
                           4'h8: begin
                                    op       = 5'b11000;
                                    pc_we    = 1'b1;
                                 end
                           4'h9: begin
                                    op       = 5'b11010;
                                    sp_we    = 1'b1;
                                 end
                           4'hA: begin
                                    rb_sel   = 3'b010;
                                    rb_we    = 1'b1;
                                 end
                           4'hB: begin
                                    op       = 5'b11010;
                                    sp_we    = 1'b1;
                                 end
                           4'hC: begin
                                    rb_sel   = 3'b010;
                                    rb_we    = 1'b1;
                                 end
                           4'hD: begin
                                    op       = 5'b11100;
                                    mem_we   = 1'b1;
                                 end
                           4'hE: begin
                                    rb_sel   = 3'b000;
                                    rb_we    = 1'b1;
                                 end
                        endcase
         EXECUTE_3:     case(ir)
                           4'h4:    rb_we    = 1'b1;
         
                           4'h5: begin
                                    rb_sel   = 3'b101;
                                    rb_we    = 1'b1;
                                 end
                           4'h6: begin
                                    rb_sel   = 3'b110;
                                    rb_we    = 1'b1;
                                 end
                           4'h9: begin
                                    op       = 5'b11101;
                                    mem_we   = 1'b1;
                                 end
                           4'hB: begin
                                    op       = 5'b11100;
                                    mem_we   = 1'b1;
                                 end
                        endcase
         
         INT_1:         begin
                           op = 5'b11001;    // Add sp
                           ale = 1'b1;
                        end 
         INT_2:         begin
                           op = 5'b11011;    // Write PC
                           mem_we = 1'b1;
                        end
         INT_3:         begin
                           op = 5'b11010;    // Dec SP
                           sp_we = 1'b1;
                        end               
                        
         INT_4:         begin
                           op = 5'b10000;    // Jump to fixed location
                           pc_we = 1'b1;
                        end
      endcase
   end


   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state       <= LOAD_REGS_0;
         int_on_off  <= 1'b0;
         int_last    <= 1'b0;
         int_in      <= 1'b0;
      end else begin
         if(!int_go) int_last <= int;
         case(state)
            LOAD_REGS_0:   state <= LOAD_REGS_1;
            LOAD_REGS_1:   state <= LOAD_REGS_2;
            LOAD_REGS_2:   state <= LOAD_REGS_3;
            LOAD_REGS_3:   state <= LOAD_REGS_4;
            LOAD_REGS_4:   state <= FETCH;
            FETCH:         if(int_go)  state <= INT_1;
                           else        state <= DECODE;
            DECODE:        state <= EXECUTE_1;
            EXECUTE_1:     case(ir)

                              4'h0,4'h1,4'h2,4'h3,4'h7:     state <= FETCH;
                              4'h4,4'h5,4'h6,4'h9,4'hA,4'hB,4'hC,4'hD,4'hE:     state <= EXECUTE_2;
                              4'h8: begin
                                       state <= EXECUTE_2;
                                       int_in <= 1'b0;
                                    end
                              4'hF: begin
                                       state       <= FETCH;
                                       int_on_off  <= ~int_on_off;
                                    end
                           endcase
            EXECUTE_2:     case(ir)
                              4'h8,4'hA,4'hC,4'hD,4'hE:                         state <= FETCH;
                              4'h4,4'h5,4'h6,4'h9,4'hB:          state <= EXECUTE_3;
                           endcase
            EXECUTE_3:     state <= FETCH;
            INT_1:         begin
                              int_last <= int;
                              int_in   <= 1'b1;
                              state <= INT_2;
                           end
            INT_2:         state <= INT_3;
            INT_3:         state <= INT_4;
            INT_4:         state <= FETCH;
         endcase
      end
   end 

endmodule
