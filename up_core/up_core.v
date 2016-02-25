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

   parameter   IR_ADD         = 4'b0000,
               IR_SUB         = 4'b0001,
               IR_MUL         = 4'b0010,
               IR_NAND        = 4'b0011,
               IR_SW01        = 4'b0100,
               IR_SW12        = 4'b0101,
               IR_SW23        = 4'b0110,
               IR_BE          = 4'b0111,
               IR_POPC        = 4'b1000,
               IR_PUSHC       = 4'b1001,
               IR_POP         = 4'b1010,
               IR_PUSH        = 4'b1011,
               IR_LDW         = 4'b1100,
               IR_STW         = 4'b1101,
               IR_REF         = 4'b1110,
               IR_INT         = 4'b1111;



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


   assign z = (r1 == r2) ? 1'b1 : 1'b0;
      
   assign int_go = (int ^ int_last) & int & int_on_off & ~int_in;

   always @(*) begin
      ir_we       = 1'b0;
      pc_we       = 1'b0;
      rb_sel      = 3'b100;
      rb_we       = 1'b0;
      sp_we       = 1'b0;
      mem_we      = 1'b0;
      ale         = 1'b0;
      casex({state,ir})
         {LOAD_REGS_0,4'bxxxx }:    begin
                                                      op       = OP_00;
                                                      ale      = 1'b1;
                                    end
         {LOAD_REGS_1,4'bxxxx }:    begin
                                                      op       = OP_01;
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_2,4'bxxxx }:    begin
                                                      op       = OP_02;
                                                      rb_sel   = 3'b001;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_3,4'bxxxx }:    begin
                                                      op       = OP_03;
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_4,4'bxxxx }:   
                                    begin
                                                      op       = OP_PC_0;
                                                      rb_sel   = 3'b011;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;
                                    end
         {FETCH,4'bxxxx       }:    begin
                                       if(int_in)     op       = OP_PC_1;
                                       else           op       = OP_PC_0;
                                                      ale      = 1'b1;
                                    end
         {DECODE,4'bxxxx      }:    begin
                                                      op       = OP_PC_INC;
                                                      ir_we    = 1'b1;
                                                      pc_we    = 1'b1;
                                    end

         {EXECUTE_1,IR_ADD    }:    begin
                                                      op       = OP_ADD;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SUB    }:    begin
                                                      op       = OP_SUB;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_MUL    }:    begin
                                                      op       = OP_MUL;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_NAND   }:    begin
                                                      op       = OP_NAND;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW01   }:    begin
                                                      op       = OP_XOR_01;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW12   }:    begin
                                                      op       = OP_XOR_12;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW23   }:    begin                
                                                      op       = OP_XOR_23;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_BE     }:    if(z) begin
                                                      op       = OP_R3;
                                                      pc_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_POPC   }:    begin
                                                      op       = OP_SP_INC; 
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_PUSHC  },
         {EXECUTE_1,IR_PUSH   }:    begin
                                                      op       = OP_SP;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_POP    }:    begin
                                                      op       = OP_SP_INC;
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_LDW    },
         {EXECUTE_1,IR_STW    }:    begin
                                                      op       = OP_R3;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_REF    }:    begin
                                                      op       = OP_00;
                                                      ale      = 1'b1;
                                    end



         {EXECUTE_2,IR_SW01   }:    begin
                                                      op       = OP_XOR_01;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_SW12   }:    begin
                                                      op       = OP_XOR_12;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_SW23   }:    begin
                                                      op       = OP_XOR_23;
                                                      rb_sel   = 3'b111;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_POPC   }:    begin
                                                      op       = OP_IN_OUT;
                                                      pc_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_PUSHC  },
         {EXECUTE_2,IR_PUSH   }:    begin
                                                      op       = OP_SP_DEC;
                                                      sp_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_POP    },
         {EXECUTE_2, IR_LDW   }:    begin
                                                      op       = OP_IN_OUT;
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_STW    }:    begin
                                                      op       = OP_R2;
                                                      mem_we   = 1'b1;
                                    end
         {EXECUTE_2,IR_REF    }:    begin
                                                      op       = OP_00;
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_3,IR_SW01   }:    begin
                                                      op       = OP_XOR_01;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_3,IR_SW12   }:    begin
                                                      op       = OP_XOR_12;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                    end                           
         {EXECUTE_3,IR_SW23   }:    begin
                                                      op       = OP_XOR_23;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_3,IR_PUSHC  }:    begin
                                                      op       = OP_PC_DEC;
                                                      mem_we   = 1'b1;
                                    end
         {EXECUTE_3,IR_PUSH   }:    begin
                                                      op       = OP_R2;
                                                      mem_we   = 1'b1;
                                    end
         {INT_1,4'bxxxx       }:    begin
                                                      op       = OP_SP;    // Add sp
                                                      ale      = 1'b1;
                                    end 
         {INT_2,4'bxxxx       }:    begin
                                                      op       = OP_PC;    // Write PC
                                                      mem_we   = 1'b1;
                                    end
         {INT_3,4'bxxxx       }:    begin
                                                      op       = OP_SP_DEC;    // Dec SP
                                                      sp_we    = 1'b1;
                                    end
         {INT_4,4'bxxxx       }:    begin
                                                      op       = OP_00;    // Jump to fixed location
                                                      pc_we    = 1'b1;
                                    end
      endcase
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
         state       <= LOAD_REGS_0;
         int_on_off  <= 1'b0;
         int_last    <= 1'b0;
         int_in      <= 1'b0;
         pc                            <= 8'h08;
         sp                            <= 8'hFF;
         ir                            <= IR_ADD;
         r0                            <= 8'h00;
         r1                            <= 8'h00;
         r2                            <= 8'h00;
         r3                            <= 8'h00;
         addr                          <= 8'h00;
      end else begin
         if(!int_go) int_last <= int;
         casex({state,ir})
            {LOAD_REGS_0,4'bxxxx }:    state <= LOAD_REGS_1;
            {LOAD_REGS_1,4'bxxxx }:    state <= LOAD_REGS_2;
            {LOAD_REGS_2,4'bxxxx }:    state <= LOAD_REGS_3;
            {LOAD_REGS_3,4'bxxxx }:    state <= LOAD_REGS_4;
            {LOAD_REGS_4,4'bxxxx }:    state <= FETCH;
            {FETCH,4'bxxxx       }:    if(int_go)  
                                          state <= INT_1;
                                       else          
                                          state <= DECODE;
            {DECODE,4'bxxxx      }:    state <= EXECUTE_1;
            {EXECUTE_1,IR_ADD    },
            {EXECUTE_1,IR_SUB    },
            {EXECUTE_1,IR_MUL    },
            {EXECUTE_1,IR_NAND   },
            {EXECUTE_1,IR_BE     }:    state <= FETCH;
            {EXECUTE_1,IR_SW01   },
            {EXECUTE_1,IR_SW12   },
            {EXECUTE_1,IR_SW23   },
            {EXECUTE_1,IR_PUSHC  },
            {EXECUTE_1,IR_POP    },
            {EXECUTE_1,IR_PUSH   },
            {EXECUTE_1,IR_LDW    },
            {EXECUTE_1,IR_STW    },
            {EXECUTE_1,IR_REF    }:    state <= EXECUTE_2;
            {EXECUTE_1,IR_POPC   }:    begin
                                          state <= EXECUTE_2;
                                          int_in <= 1'b0;
                                       end
            {EXECUTE_1,IR_INT    }:    begin
                                          state       <= FETCH;
                                          int_on_off  <= ~int_on_off;
                                       end
            {EXECUTE_2,IR_POPC   },
            {EXECUTE_2,IR_POP    },
            {EXECUTE_2,IR_LDW    },
            {EXECUTE_2,IR_STW    },
            {EXECUTE_2,IR_REF    }:    state <= FETCH;
            {EXECUTE_2,IR_SW01   },
            {EXECUTE_2,IR_SW12   },
            {EXECUTE_2,IR_SW23   },
            {EXECUTE_2,IR_PUSHC  },
            {EXECUTE_2,IR_PUSH   }:    state <= EXECUTE_3;
            {EXECUTE_3,4'bxxxx   }:    state <= FETCH;
            {INT_1,4'bxxxx       }:    begin
                                          int_last <= int;
                                          int_in   <= 1'b1;
                                          state <= INT_2;
                                       end
            {INT_2,4'bxxxx       }:    state <= INT_3;
            {INT_3,4'bxxxx       }:    state <= INT_4;
            {INT_4,4'bxxxx       }:    state <= FETCH;
            default:                   state <= FETCH;
         endcase
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
