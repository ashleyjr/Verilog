module up_core(
	input	            clk,
	input	            nRst, 
   input             int,
   input             mem_map_load,
   input    [8:0]    mem_map_address,
   input    [7:0]    mem_map_in,
   output   [7:0]    mem_map_out 
);

   parameter   SIZE           = 256,
               LOAD_REGS_0    = 4'h0,
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
               INT_4          = 4'hD,
               IR_ADD         = 4'h0,
               IR_SUB         = 4'h1,
               IR_MUL         = 4'h2,
               IR_NAND        = 4'h3,
               IR_SW01        = 4'h4,
               IR_SW12        = 4'h5,
               IR_SW23        = 4'h6,
               IR_BE          = 4'h7,
               IR_POPC        = 4'h8,
               IR_PUSHC       = 4'h9,
               IR_POP         = 4'hA,
               IR_PUSH        = 4'hB,
               IR_LDW         = 4'hC,
               IR_STW         = 4'hD,
               IR_REF         = 4'hE,
               IR_INT         = 4'hF;


	reg   [7:0]    mem         [SIZE-1:0];
   reg   [3:0]    state;
   reg            int_on_off;
   reg            int_last;
   reg            int_in;
   reg   [3:0]    ir;
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
   
   assign         data_in        = mem[addr];
   assign         mem_map_out    = mem[mem_map_address[7:0]]; 
   assign         z              = (r1 == r2) ? 1'b1 : 1'b0; 
   assign         int_go         = (int ^ int_last) & int & int_on_off & ~int_in;

   always @(*) begin
      ir_we       = 1'b0;
      pc_we       = 1'b0;
      rb_sel      = 3'b100;
      rb_we       = 1'b0;
      sp_we       = 1'b0;
      mem_we      = 1'b0;
      ale         = 1'b0;
      casex({state,ir})
         {LOAD_REGS_0,4'bxxxx }, 
         {EXECUTE_1,IR_REF    }:    begin
                                                      data_out = 8'h00;
                                                      ale      = 1'b1;
                                    end
         {LOAD_REGS_1,4'bxxxx }:    begin
                                                      data_out = 8'h01;
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_2,4'bxxxx }:    begin
                                                      data_out = 8'h02;
                                                      rb_sel   = 3'b001;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_3,4'bxxxx }:    begin
                                                      data_out = 8'h03;
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_4,4'bxxxx }:   
                                    begin
                                                      data_out = {1'b0,pc[7:1]};
                                                      rb_sel   = 3'b011;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;
                                    end
         {FETCH,4'bxxxx       }:    begin
                                       if(int_in)     data_out = {1'b1,pc[7:1]};
                                       else           data_out = {1'b0,pc[7:1]};
                                                      ale      = 1'b1;
                                    end
         {DECODE,4'bxxxx      }:    begin
                                                      data_out = pc + 1'b1;
                                                      ir_we    = 1'b1;
                                                      pc_we    = 1'b1;
                                    end

         {EXECUTE_1,IR_ADD    }:    begin
                                                      data_out = r1 + r2;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SUB    }:    begin
                                                      data_out = r1 - r2;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_MUL    }:    begin
                                                      data_out = r1 * r2;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_NAND   }:    begin
                                                      data_out = ~(r1 & r2);
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW01   },
         {EXECUTE_3,IR_SW01   }:    begin
                                                      data_out = r0 ^ r1;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW12   },
         {EXECUTE_3,IR_SW12   }:    begin
                                                      data_out = r1 ^ r2;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW23   },
         {EXECUTE_3,IR_SW23   }:    begin                
                                                      data_out = r2 ^ r3;;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_BE     }:    if(z) begin
                                                      data_out = r3;
                                                      pc_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_POP    },
         {EXECUTE_1,IR_POPC   }:    begin
                                                      data_out = sp + 1'b1; 
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_PUSHC  },
         {EXECUTE_1,IR_PUSH   },
         {INT_1,4'bxxxx       }:    begin
                                                      data_out = sp;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_LDW    },
         {EXECUTE_1,IR_STW    }:    begin
                                                      data_out = r3;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_REF    }:    begin
                                                      data_out = 8'h00;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_2,IR_SW01   }:    begin
                                                      data_out =  r0 ^ r1;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_SW12   }:    begin
                                                      data_out = r1 ^ r2;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_SW23   }:    begin
                                                      data_out = r2 ^ r3;
                                                      rb_sel   = 3'b111;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_POPC   }:    begin
                                                      data_out = data_in;
                                                      pc_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_PUSHC  },
         {EXECUTE_2,IR_PUSH   }:    begin
                                                      data_out = sp - 1'b1;
                                                      sp_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_POP    },
         {EXECUTE_2, IR_LDW   }:    begin
                                                      data_out = data_in;
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_STW    },
         {EXECUTE_3,IR_PUSH   }:    begin
                                                      data_out = r2;
                                                      mem_we   = 1'b1;
                                    end
         {EXECUTE_2,IR_REF    }:    begin
                                                      data_out = 8'h00;
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_3,IR_PUSHC  }:    begin
                                                      data_out = pc - 1'b1;
                                                      mem_we   = 1'b1;
                                    end
         {INT_2,4'bxxxx       }:    begin
                                                      data_out = pc;    // Write PC
                                                      mem_we   = 1'b1;
                                    end
         {INT_3,4'bxxxx       }:    begin
                                                      data_out = sp - 1'b1;    // Dec SP
                                                      sp_we    = 1'b1;
                                    end
         {INT_4,4'bxxxx       }:    begin
                                                      data_out = 8'h00;    // Jump to fixed location
                                                      pc_we    = 1'b1;
                                    end
      endcase
   end

   always@(posedge clk or negedge nRst) begin 
      if(nRst) begin      
         if(!int_go)          int_last <= int;  
         state <= FETCH;
         casex({int_go,state,ir})
            {1'bx,LOAD_REGS_0,   4'bxxxx  }:    state          <= LOAD_REGS_1;
            {1'bx,LOAD_REGS_1,   4'bxxxx  }:    state          <= LOAD_REGS_2;
            {1'bx,LOAD_REGS_2,   4'bxxxx  }:    state          <= LOAD_REGS_3;
            {1'bx,LOAD_REGS_3,   4'bxxxx  }:    state          <= LOAD_REGS_4;
            {1'b1,FETCH,         4'bxxxx  }:    state          <= INT_1;
            {1'b0,FETCH,         4'bxxxx  }:    state          <= DECODE;
            {1'bx,DECODE,        4'bxxxx  }:    state          <= EXECUTE_1; 
            {1'bx,EXECUTE_1,     IR_SW01  },
            {1'bx,EXECUTE_1,     IR_SW12  },
            {1'bx,EXECUTE_1,     IR_SW23  },
            {1'bx,EXECUTE_1,     IR_PUSHC },
            {1'bx,EXECUTE_1,     IR_POP   },
            {1'bx,EXECUTE_1,     IR_PUSH  },
            {1'bx,EXECUTE_1,     IR_LDW   },
            {1'bx,EXECUTE_1,     IR_STW   },
            {1'bx,EXECUTE_1,     IR_REF   }:    state          <= EXECUTE_2;
            {1'bx,EXECUTE_1,     IR_POPC  }:    begin
                                                   state       <= EXECUTE_2;
                                                   int_in      <= 1'b0;
                                                end
            {1'bx,EXECUTE_1,     IR_INT   }:    int_on_off     <= ~int_on_off;
            {1'bx,EXECUTE_2,     IR_SW01  },
            {1'bx,EXECUTE_2,     IR_SW12  },
            {1'bx,EXECUTE_2,     IR_SW23  },
            {1'bx,EXECUTE_2,     IR_PUSHC },
            {1'bx,EXECUTE_2,     IR_PUSH  }:    state          <= EXECUTE_3;
            {1'bx,INT_1,         4'bxxxx  }:    begin
                                                   int_last    <= int;
                                                   int_in      <= 1'b1;
                                                   state       <= INT_2;
                                                end
            {1'bx,INT_2,         4'bxxxx  }:    state          <= INT_3;
            {1'bx,INT_3,         4'bxxxx  }:    state          <= INT_4;
         endcase
         if(sp_we)                              sp             <= data_out;
         if(pc_we)                              pc             <= data_out;
         case({ir_we,pc[0]})
            2'b11:                              ir             <= data_in[3:0];
            2'b10:                              ir             <= data_in[7:4];
         endcase
         case({rb_we,rb_sel}) 
            4'b1000:                            r0             <= data_in;      
            4'b1001:                            r1             <= data_in;      
            4'b1010:                            r2             <= data_in;      
            4'b1011:                            r3             <= data_in;      
            4'b1100:                            r0             <= data_out;     
            4'b1101:                            r1             <= data_out;     
            4'b1110:                            r2             <= data_out;     
            4'b1111:                            r3             <= data_out;     
         endcase
         casex({ale,mem_we})
            2'b1x:                              addr           <= data_out;
            2'bx1:                              mem[addr]      <= data_out;
         endcase
         if(mem_map_load) begin
            if(mem_map_address[8]) begin
               state <= LOAD_REGS_0;
            end else begin
               mem[mem_map_address[7:0]] <= mem_map_in; 
            end
         end
      end else begin
         state          <= LOAD_REGS_0;
         int_on_off     <= 1'b0;
         int_last       <= 1'b0;
         int_in         <= 1'b0;
         pc             <= 8'h08;
         sp             <= 8'hFF;
         ir             <= IR_ADD;
         r0             <= 8'h00;
         r1             <= 8'h00;
         r2             <= 8'h00;
         r3             <= 8'h00;
         addr           <= 8'h00; 
      end
   end  
endmodule
