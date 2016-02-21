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
               OP_PC_1        = 5'b11110,
               OP_IN_OUT      = 5'b11000;

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
   reg   [7:0]    addr;
   reg   [7:0]    data_out;
   wire  [7:0]    data_in; 
   wire           int_go;
   assign         data_in = mem[addr];



   // Controller
   assign int_go = (int ^ int_last) & int & int_on_off & ~int_in;

   always @(*) begin
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
         LOAD_REGS_1:   begin
                                                      op       = OP_01;
                                                      rb_sel   = state[2:0] - 1'b1;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                        end
         LOAD_REGS_2:   begin
                                                      op       = OP_02;
                                                      rb_sel   = state[2:0] - 1'b1;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                        end
         LOAD_REGS_3:   begin
                                                      op       = OP_03;
                                                      rb_sel   = state[2:0] - 1'b1;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                        end
         LOAD_REGS_4:   
                        begin
                                                      op       = OP_PC_0;
                                                      rb_sel   = state[2:0] - 1'b1;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;
                        end
         FETCH:         begin
                           if(int_in)                 op       = OP_PC_1;
                           else                       op       = OP_PC_0;
                                                      ale      = 1'b1;
                        end
         DECODE:        begin
                                                      op       = OP_PC_INC;
                                                      ir_we    = 1'b1;
                                                      pc_we    = 1'b1;
                        end
         EXECUTE_1:     case(ir)
                           4'h0:       begin
                                                      op       = OP_ADD;
                                                      rb_we    = 1'b1;
                                       end
                           4'h1:       begin
                                                      op       = OP_SUB;
                                                      rb_we    = 1'b1;
                                       end
                           4'h2:       begin
                                                      op       = OP_MUL;
                                                      rb_we    = 1'b1;
                                       end
                           4'h3:       begin
                                                      op       = OP_NAND;
                                                      rb_we    = 1'b1;
                                       end
                           4'h4:       begin
                                                      op       = OP_XOR_01;
                                                      rb_we    = 1'b1;
                                       end
                           4'h5:       begin
                                                      op       = OP_XOR_12;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                       end
                           4'h6:       begin                
                                                      op       = OP_XOR_23;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                       end
                           4'h7: if(z) begin
                                                      op       = OP_R3;
                                                      pc_we    = 1'b1;
                                 end
                           4'h8:       begin
                                                      op       = OP_SP_INC; 
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                       end
                           4'h9,4'hB:  begin
                                                      op       = OP_SP;
                                                      ale      = 1'b1;
                                       end
                           4'hA:       begin
                                                      op       = OP_SP_INC;
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                       end
                           4'hC,4'hD:  begin
                                                      op       = OP_R3;
                                                      ale      = 1'b1;
                                       end
                           4'hE:       begin
                                                      op       = OP_00;
                                                      ale      = 1'b1;
                                       end
                              
                        endcase
         EXECUTE_2:     case(ir)
                           4'h4:             begin
                                                      op       = OP_XOR_01;
                                                      rb_sel   = ir[2:0] + 1'b1;
                                                      rb_we    = 1'b1;
                                             end

                           4'h5:             begin
                                                      op       = OP_XOR_12;
                                                      rb_sel   = ir[2:0] + 1'b1;
                                                      rb_we    = 1'b1;
                                             end

                           4'h6:             begin
                                                      op       = OP_XOR_23;
                                                      rb_sel   = ir[2:0] + 1'b1;
                                                      rb_we    = 1'b1;
                                             end
                           4'h8:             begin
                                                      op       = OP_IN_OUT;
                                                      pc_we    = 1'b1;
                                             end
                           4'h9,4'hB:        begin
                                                      op       = OP_SP_DEC;
                                                      sp_we    = 1'b1;
                                             end
                           4'hA,4'hC:        begin
                                                      op       = OP_IN_OUT;
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                             end
                           4'hD:             begin
                                                      op       = OP_R2;
                                                      mem_we   = 1'b1;
                                             end
                           4'hE:             begin
                                                      op       = OP_00;
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                             end
                        endcase
         EXECUTE_3:     case(ir)
                           4'h4:             begin
                                                      op       = OP_XOR_01;
                                                      rb_we    = 1'b1;
                                             end
                           4'h5:             begin
                                                      op       = OP_XOR_12;
                                                      rb_sel   = ir[2:0];
                                                      rb_we    = 1'b1;
                                             end                           
                           4'h6:             begin
                                                      op       = OP_XOR_23;
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
      
   always@(*) begin
      case(op)
         OP_ADD:              data_out = r1 + r2;         
         OP_SUB:              data_out = r1 - r2;         
         OP_MUL:              data_out = r1 * r2;         
         OP_NAND:             data_out = ~(r1 & r2);      
         OP_XOR_01:           data_out = r0 ^ r1;         
         OP_XOR_12:           data_out = r1 ^ r2;         
         OP_XOR_23:           data_out = r2 ^ r3;         
         OP_00:               data_out = 8'h00;           
         OP_01:               data_out = 8'h01;           
         OP_02:               data_out = 8'h02;           
         OP_03:               data_out = 8'h03;           
         OP_PC_0:             data_out = {1'b0,pc[7:1]};  
         OP_PC_INC:           data_out = pc + 1'b1;       
         OP_R3:               data_out = r3;              
         OP_SP_INC:           data_out = sp + 1'b1;       
         OP_SP:               data_out = sp;              
         OP_SP_DEC:           data_out = sp - 1'b1;       
         OP_PC:               data_out = pc;              
         OP_R2:               data_out = r2;              
         OP_PC_DEC:           data_out = pc - 1'b1;       
         OP_PC_1:             data_out = {1'b1,pc[7:1]};  
         OP_IN_OUT:           data_out = data_in;         
      endcase
   end
   
   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         pc                            <= 8'h08;
         sp                            <= 8'hFF;
         ir                            <= 4'h0;
         r0                            <= 8'h00;
         r1                            <= 8'h00;
         r2                            <= 8'h00;
         r3                            <= 8'h00;
         addr                          <= 8'h00;
      end else begin 
         if(sp_we)      sp             <= data_out;
         if(pc_we)      pc             <= data_out;
         case({ir_we,pc[0]})
            2'b11:      ir             <= data_in[3:0];
            2'b10:      ir             <= data_in[7:4];
         endcase
         case({rb_we,rb_sel}) 
            4'b1000:    r0             <= data_in;      
            4'b1001:    r1             <= data_in;      
            4'b1010:    r2             <= data_in;      
            4'b1011:    r3             <= data_in;      
            4'b1100:    r0             <= data_out;     
            4'b1101:    r1             <= data_out;     
            4'b1110:    r2             <= data_out;     
            4'b1111:    r3             <= data_out;     
         endcase
         casex({ale,mem_we})
            2'b1x:      addr           <= data_out;
            2'bx1:      mem[addr]      <= data_out;
         endcase
      end
   end
endmodule
