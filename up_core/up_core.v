module up_core(
	input	            clk,
	input	            nRst, 
   input             int
);

   parameter   SIZE           = 256;
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


   parameter   OP_ADD         = 5'b00000,
               OP_SUB         = 5'b00001,
               OP_MUL         = 5'b00010,
               OP_NAND        = 5'b00011,
               OP_XOR_01      = 5'b00100,
               OP_XOR_12      = 5'b00101,
               OP_XOR_23      = 5'b00110,
               OP_00          = 5'b01110,
               OP_01          = 5'b10001,
               OP_02          = 5'b10010,
               OP_03          = 5'b10011,
               OP_PC_0        = 5'b10100,
               OP_PC_INC      = 5'b10101,
               OP_R3          = 5'b10110,
               OP_SP_INC      = 5'b01000,
               OP_SP          = 5'b11001,
               OP_SP_DEC      = 5'b11010,
               OP_PC          = 5'b11011,
               OP_R2          = 5'b11100,
               OP_PC_DEC      = 5'b11101,
               OP_PC_1        = 5'b11110;


	reg   [7:0]    mem         [SIZE-1:0];
   reg   [3:0]    state;
   reg            int_on_off;
   reg            int_last;
   reg            int_in;
   reg   [3:0]    ir;
   reg   [4:0]    op;
   reg            ir_we;
   reg            pc_we;
   reg   [2:0]    rb_sel;
   reg            rb_we;
   reg            sp_we;
   reg            mem_we;
   reg            ale;
   reg   [7:0]    sp;
   reg   [7:0]    pc;
   reg   [7:0]    r0;
   reg   [7:0]    r1;
   reg   [7:0]    r2;
   reg   [7:0]    r3;  
   reg   [7:0]    address_latch;
   wire  [7:0]    data_out;
   wire  [7:0]    data_in; 
   wire           int_go;
   assign         data_in = mem[address_latch];



   // Controller
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
                                                      op       = OP_00;
                                                      ale      = 1'b1;
                        end
         LOAD_REGS_1,LOAD_REGS_2,LOAD_REGS_3,LOAD_REGS_4:   
                        begin
                                                      op       = {1'b1,state};
                                                      rb_sel   = state[2:0] - 1'b1;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;
                        end
         FETCH:         begin
                           if(int_in)                 op       = OP_PC_1;
                           else                       op       = 5'b10100;
                                                      ale      = 1'b1;
                        end
         DECODE:        begin
                                                      op       = OP_PC_INC;
                                                      ir_we    = 1'b1;
                                                      pc_we    = 1'b1;
                        end
         EXECUTE_1:     case(ir)
                           4'h0,4'h1,4'h2,4'h3,4'h4:  rb_we    = 1'b1;
                           4'h5:       begin 
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                       end
                           4'h6:       begin                
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                       end
                           4'h7: if(z) begin
                                                      op       = OP_R3;
                                                      pc_we    = 1'b1;
                                 end
                           4'h8:       begin
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                       end
                           4'h9,4'hB:  begin
                                                      op       = OP_SP;
                                                      ale      = 1'b1;
                                       end
                           4'hA:       begin
                                                      op       = 5'b01000;
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                       end
                           4'hC,4'hD:  begin
                                                      op       = OP_R3;
                                                      ale      = 1'b1;
                                       end
                           4'hE:                      ale      = 1'b1;
                              
                        endcase
         EXECUTE_2:     case(ir)
                           4'h4,4'h5, 4'h6:  begin
                                                      rb_sel   = ir[2:0] + 1'b1;
                                                      rb_we    = 1'b1;
                                             end
                           4'h8:             begin
                                                      op       = 5'b11000;
                                                      pc_we    = 1'b1;
                                             end
                           4'h9,4'hB:        begin
                                                      op       = OP_SP_DEC;
                                                      sp_we    = 1'b1;
                                             end
                           4'hA,4'hC:        begin
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                             end
                           4'hD:             begin
                                                      op       = OP_R2;
                                                      mem_we   = 1'b1;
                                             end
                           4'hE:             begin
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                             end
                        endcase
         EXECUTE_3:     case(ir)
                           4'h4:                      rb_we    = 1'b1; 
                           4'h5,4'h6:        begin
                                                      rb_sel   = ir[2:0];
                                                      rb_we    = 1'b1;
                                             end
                           4'h9:             begin
                                                      op       = OP_PC_DEC;
                                                      mem_we   = 1'b1;
                                             end
                           4'hB:             begin
                                                      op       = OP_R2;
                                                      mem_we   = 1'b1;
                                             end
                        endcase
         INT_1:                              begin
                                                      op       = OP_SP;    // Add sp
                                                      ale      = 1'b1;
                                             end 
         INT_2:                              begin
                                                      op       = OP_PC;    // Write PC
                                                      mem_we   = 1'b1;
                                             end
         INT_3:                              begin
                                                      op       = OP_SP_DEC;    // Dec SP
                                                      sp_we    = 1'b1;
                                             end
         INT_4:                              begin
                                                      op       = OP_00;    // Jump to fixed location
                                                      pc_we    = 1'b1;
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
            LOAD_REGS_0:                                                         state <= LOAD_REGS_1;
            LOAD_REGS_1:                                                         state <= LOAD_REGS_2;
            LOAD_REGS_2:                                                         state <= LOAD_REGS_3;
            LOAD_REGS_3:                                                         state <= LOAD_REGS_4;
            LOAD_REGS_4:                                                         state <= FETCH;
            FETCH:         if(int_go)                                            state <= INT_1;
                           else                                                  state <= DECODE;
            DECODE:                                                              state <= EXECUTE_1;
            EXECUTE_1:     case(ir)
                              4'h0,4'h1,4'h2,4'h3,4'h7:                          state <= FETCH;
                              4'h4,4'h5,4'h6,4'h9,4'hA,4'hB,4'hC,4'hD,4'hE:      state <= EXECUTE_2;
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
                              4'h8,4'hA,4'hC,4'hD,4'hE:                          state <= FETCH;
                              4'h4,4'h5,4'h6,4'h9,4'hB:                          state <= EXECUTE_3;
                           endcase
            EXECUTE_3:                                                           state <= FETCH;
            INT_1:         begin
                                                                                 int_last <= int;
                                                                                 int_in   <= 1'b1;
                                                                                 state <= INT_2;
                           end
            INT_2:                                                               state <= INT_3;
            INT_3:                                                               state <= INT_4;
            INT_4:                                                               state <= FETCH;
            default:                                                             state <= FETCH;
         endcase
      end
   end 

   // Datapath
   assign z = (r1 == r2) ? 1'b1 : 1'b0;
   
   assign   data_out =
               (op ==  OP_ADD         )        ? r1 + r2            :
               (op ==  OP_SUB         )        ? r1 - r2            :
               (op ==  OP_MUL         )        ? r1 * r2            :
               (op ==  OP_NAND        )        ? ~(r1 & r2)         :
               (op ==  OP_XOR_01      )        ? r0 ^ r1            :
               (op ==  OP_XOR_12      )        ? r1 ^ r2            :
               (op ==  OP_XOR_23      )        ? r2 ^ r3            : 
               (op ==  OP_00          )        ? 8'h00              :
               (op ==  OP_01          )        ? 8'h01              :
               (op ==  OP_02          )        ? 8'h02              :
               (op ==  OP_03          )        ? 8'h03              :
               (op ==  OP_PC_0        )        ? {1'b0,pc[7:1]}     :
               (op ==  OP_PC_INC      )        ? pc + 1'b1             :
               (op ==  OP_R3          )        ? r3                 :
               (op ==  OP_SP_INC      )        ? sp + 1'b1             :
               (op ==  OP_SP          )        ? sp                 :
               (op ==  OP_SP_DEC      )        ? sp - 1'b1             :
               (op ==  OP_PC          )        ? pc                 :
               (op ==  OP_R2          )        ? r2                 :
               (op ==  OP_PC_DEC      )        ? pc - 1'b1                 :
               (op ==  OP_PC_1        )        ? {1'b1,pc[7:1]}     : 
               data_in            ;  

   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         pc <= 8'h08;
         sp <= 8'hFF;
         ir <= 4'h0;
         r0 <= 8'h00;
         r1 <= 8'h00;
         r2 <= 8'h00;
         r3 <= 8'h00;
      end else begin 
         if(sp_we)      sp <= data_out;
         if(pc_we)      pc <= data_out;
         case({ir_we,pc[0]})
            2'b11:      ir <= data_in[3:0];
            2'b10:      ir <= data_in[7:4];
         endcase
         case({rb_we,rb_sel}) 
            4'b1000:    r0 <= data_in;       // SEL_I0
            4'b1001:    r1 <= data_in;       // SEL_I1
            4'b1010:    r2 <= data_in;       // SEL_I2
            4'b1011:    r3 <= data_in;       // SEL_I3
            4'b1100:    r0 <= data_out;      // SEL_00
            4'b1101:    r1 <= data_out;      // SEL_01
            4'b1110:    r2 <= data_out;      // SEL_02
            4'b1111:    r3 <= data_out;      // SEL_03
         endcase
      end
   end

   // Address latch
   always@(posedge clk or negedge nRst) begin 
      casex({nRst,ale,mem_we})
         3'b0xx:  address_latch        <= 8'h00;
         3'b11x:  address_latch        <= data_out;
         3'b1x1:  mem[address_latch]   <= data_out;
      endcase
   end
endmodule
