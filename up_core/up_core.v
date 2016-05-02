module up_core(
	input	            clk,
	input	            nRst,                      // Active low reset
   input             int,                       // Active high interrupt
   input             mem_map_load,              // Write = 1
   input    [8:0]    mem_map_address,           // 0..255 == Memory, > 255 processor registers
   input    [7:0]    mem_map_in,                // Data in can be written to memory
   output   [7:0]    mem_map_out                // Data out from memory and processor registers
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
   reg            int_1;
   reg            int_2;
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
   reg   [7:0]    mem_map_out;
   wire  [7:0]    data_in; 
   wire           int_go;
   
   assign         data_in        = mem[addr];                                                   // Output from memory
   assign         z              = (r1 == r2) ? 1'b1 : 1'b0;                                    // branch signal
   assign         int_go         = (int_1 ^ int_2) & int_1 & int_on_off & ~int_in;               // Interrupt signal

   always @(*) begin
      ir_we       = 1'b0;
      pc_we       = 1'b0;
      rb_sel      = 3'b100;
      rb_we       = 1'b0;
      sp_we       = 1'b0;
      mem_we      = 1'b0;
      ale         = 1'b0;
      if(mem_map_address[8]) begin                                                              // Registers are also available on memory map output
         case(mem_map_address[7:0])  
            8'h00:   mem_map_out    <= state;
            8'h01:   mem_map_out    <= int_on_off;
            8'h02:   mem_map_out    <= int_1;
            8'h03:   mem_map_out    <= int_1;
            8'h04:   mem_map_out    <= int_in;
            8'h05:   mem_map_out    <= ir;
            8'h06:   mem_map_out    <= ir_we;
            8'h07:   mem_map_out    <= pc_we;
            8'h08:   mem_map_out    <= rb_sel;
            8'h09:   mem_map_out    <= rb_we;
            8'h0A:   mem_map_out    <= sp_we;
            8'h0B:   mem_map_out    <= mem_we;
            8'h0D:   mem_map_out    <= ale;
            8'h0E:   mem_map_out    <= sp;
            8'h0F:   mem_map_out    <= pc;
            8'h0E:   mem_map_out    <= r0;
            8'h10:   mem_map_out    <= r1;
            8'h11:   mem_map_out    <= r2;
            8'h12:   mem_map_out    <= r3;  
            8'h13:   mem_map_out    <= addr;
            8'h14:   mem_map_out    <= data_out;
         endcase
      end else begin
         mem_map_out    = mem[mem_map_address[7:0]];                                            // Memory output 
      end
      
      casex({state,ir})
         {LOAD_REGS_0,4'bxxxx },                                                                // Get mem for R0
         {EXECUTE_1,IR_REF    }:    begin                                                       // Load referance
                                                      data_out = 8'h00;
                                                      ale      = 1'b1;
                                    end
         {LOAD_REGS_1,4'bxxxx }:    begin                                                       // Load R0
                                                      data_out = 8'h01;
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_2,4'bxxxx }:    begin                                                       // Load R1
                                                      data_out = 8'h02;
                                                      rb_sel   = 3'b001;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_3,4'bxxxx }:    begin                                                       // Load R2
                                                      data_out = 8'h03;
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;

                                    end
         {LOAD_REGS_4,4'bxxxx }:    begin                                                       // Load R3
                                                      data_out = {1'b0,pc[7:1]};
                                                      rb_sel   = 3'b011;
                                                      rb_we    = 1'b1;
                                                      ale      = 1'b1;
                                    end
         {FETCH,4'bxxxx       }:    begin                                                       // Get from memory or do an interupt
                                       if(int_in)     data_out = {1'b1,pc[7:1]};
                                       else           data_out = {1'b0,pc[7:1]};
                                                      ale      = 1'b1;
                                    end
         {DECODE,4'bxxxx      }:    begin                                                       // Write to PC and IR
                                                      data_out = pc + 1'b1;
                                                      ir_we    = 1'b1;
                                                      pc_we    = 1'b1;
                                    end

         {EXECUTE_1,IR_ADD    }:    begin                                                       // R0 = R1 + R2  
                                                      data_out = r1 + r2;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SUB    }:    begin                                                       // R0 - R1 - R2
                                                      data_out = r1 - r2;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_MUL    }:    begin                                                       // R0 = R1 * R2
                                                      data_out = r1 * r2;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_NAND   }:    begin                                                       // R0 = R1 NAND R2
                                                      data_out = ~(r1 & r2);
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW01   },
         {EXECUTE_3,IR_SW01   }:    begin                                                       // Switrch R0 and R1
                                                      data_out = r0 ^ r1;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW12   },
         {EXECUTE_3,IR_SW12   }:    begin                                                       // Switch R2 and R2
                                                      data_out = r1 ^ r2;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_SW23   },                                                                
         {EXECUTE_3,IR_SW23   }:    begin                                                       // Switch R2 and R3 
                                                      data_out = r2 ^ r3;;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_BE     }:    if(z) begin                                                 // Branch to loaction in R3 if R1 == R2
                                                      data_out = r3;
                                                      pc_we    = 1'b1;
                                    end
         {EXECUTE_1,IR_POP    },                                                                // Pop R3 from stack
         {EXECUTE_1,IR_POPC   }:    begin                                                       // Pop propgram counter from stack
                                                      data_out = sp + 1'b1; 
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_PUSHC  },                                                                // Push prgram counter to stack
         {EXECUTE_1,IR_PUSH   },                                                                // Push R3 to stack  
         {INT_1,4'bxxxx       }:    begin                                                       // Interrupt
                                                      data_out = sp;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_LDW    },                                                                // Load
         {EXECUTE_1,IR_STW    }:    begin                                                       // Store
                                                      data_out = r3;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_1,IR_REF    }:    begin                                                       // Load reference memory location
                                                      data_out = 8'h00;
                                                      ale      = 1'b1;
                                    end
         {EXECUTE_2,IR_SW01   }:    begin                                                       // Switch R0 and r1
                                                      data_out =  r0 ^ r1;
                                                      rb_sel   = 3'b101;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_SW12   }:    begin                                                       // Switch R1 and R2
                                                      data_out = r1 ^ r2;
                                                      rb_sel   = 3'b110;
                                                      rb_we    = 1'b1;
                                    end   
         {EXECUTE_2,IR_SW23   }:    begin                                                       // Switch R2 and R3
                                                      data_out = r2 ^ r3;
                                                      rb_sel   = 3'b111;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_POPC   }:    begin                                                       // Pop in program counter
                                                      data_out = data_in;
                                                      pc_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_PUSHC  },                                                                // Push program counter to stack
         {EXECUTE_2,IR_PUSH   }:    begin                                                       // Push R3 to stack
                                                      data_out = sp - 1'b1;
                                                      sp_we    = 1'b1;                    
                                    end
         {EXECUTE_2,IR_POP    },                                                                // Pop stack in top R3
         {EXECUTE_2, IR_LDW   }:    begin                                                       // Load
                                                      data_out = data_in;
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_2,IR_STW    },                                                                // Store 
         {EXECUTE_3,IR_PUSH   }:    begin                                                       // Push R3 to stack
                                                      data_out = r2;
                                                      mem_we   = 1'b1;
                                    end
         {EXECUTE_2,IR_REF    }:    begin                                                       // Load reference memory location
                                                      data_out = 8'h00;
                                                      rb_sel   = 3'b000;
                                                      rb_we    = 1'b1;
                                    end
         {EXECUTE_3,IR_PUSHC  }:    begin
                                                      data_out = pc - 1'b1;                     // Push program counter to stack
                                                      mem_we   = 1'b1;
                                    end
         {INT_2,4'bxxxx       }:    begin
                                                      data_out = pc;                            // Write PC
                                                      mem_we   = 1'b1;
                                    end
         {INT_3,4'bxxxx       }:    begin
                                                      data_out = sp - 1'b1;                     // Dec SP
                                                      sp_we    = 1'b1;
                                    end
         {INT_4,4'bxxxx       }:    begin
                                                      data_out = 8'h00;                         // Jump to fixed location
                                                      pc_we    = 1'b1;
                                    end
      endcase
   end
   always@(posedge clk or negedge nRst) begin 
      if(nRst) begin      
         if(!int_go) begin
                                                int_1                      <= int;              // Clock in int 
                                                int_2                      <= int_1;
         end
         state <= FETCH;
         casex({int_go,state,ir})
            {1'bx,LOAD_REGS_0,   4'bxxxx  }:    state                      <= LOAD_REGS_1;      // The load regs from bottom four bytes 
            {1'bx,LOAD_REGS_1,   4'bxxxx  }:    state                      <= LOAD_REGS_2;
            {1'bx,LOAD_REGS_2,   4'bxxxx  }:    state                      <= LOAD_REGS_3;
            {1'bx,LOAD_REGS_3,   4'bxxxx  }:    state                      <= LOAD_REGS_4;
            {1'b1,FETCH,         4'bxxxx  }:    state                      <= INT_1;            // An interrupt has happened
            {1'b0,FETCH,         4'bxxxx  }:    state                      <= DECODE;           
            {1'bx,DECODE,        4'bxxxx  }:    state                      <= EXECUTE_1;        // Simple ops finish here
            {1'bx,EXECUTE_1,     IR_SW01  },
            {1'bx,EXECUTE_1,     IR_SW12  },
            {1'bx,EXECUTE_1,     IR_SW23  },
            {1'bx,EXECUTE_1,     IR_PUSHC },
            {1'bx,EXECUTE_1,     IR_POP   },
            {1'bx,EXECUTE_1,     IR_PUSH  },
            {1'bx,EXECUTE_1,     IR_LDW   },
            {1'bx,EXECUTE_1,     IR_STW   },
            {1'bx,EXECUTE_1,     IR_REF   }:    state                      <= EXECUTE_2;        
            {1'bx,EXECUTE_1,     IR_POPC  }:    begin
                                                   state                   <= EXECUTE_2;
                                                   int_in                  <= 1'b0;
                                                end
            {1'bx,EXECUTE_1,     IR_INT   }:    int_on_off                 <= ~int_on_off;      // Toggle ints
            {1'bx,EXECUTE_2,     IR_SW01  },                                                    // Multi cycle operations
            {1'bx,EXECUTE_2,     IR_SW12  },
            {1'bx,EXECUTE_2,     IR_SW23  },
            {1'bx,EXECUTE_2,     IR_PUSHC },
            {1'bx,EXECUTE_2,     IR_PUSH  }:    state                      <= EXECUTE_3;
            {1'bx,INT_1,         4'bxxxx  }:    begin                                           // Interrupt jump happens here
                                                   int_in                  <= 1'b1;
                                                   state                   <= INT_2;
                                                end
            {1'bx,INT_2,         4'bxxxx  }:    state                      <= INT_3;
            {1'bx,INT_3,         4'bxxxx  }:    state                      <= INT_4;
         endcase
         if(sp_we)                              sp                         <= data_out;
         if(pc_we)                              pc                         <= data_out;
         case({ir_we,pc[0]})                                                                    // Flip between upper and lower nibble of instructions
            2'b11:                              ir                         <= data_in[3:0];
            2'b10:                              ir                         <= data_in[7:4];
         endcase
         case({rb_we,rb_sel})                                                                   // Reg select 
            4'h8:                               r0                         <= data_in;      
            4'h9:                               r1                         <= data_in;      
            4'hA:                               r2                         <= data_in;      
            4'hB:                               r3                         <= data_in;      
            4'hC:                               r0                         <= data_out;     
            4'hD:                               r1                         <= data_out;     
            4'hE:                               r2                         <= data_out;     
            4'hF:                               r3                         <= data_out;     
         endcase
         casex({ale,mem_we})
            2'b1x:                              addr                       <= data_out;         // Interface to memory
            2'bx1:                              mem[addr]                  <= data_out;
         endcase 
         if(mem_map_load) 
            if(mem_map_address[8])              begin
                                                state                      <= LOAD_REGS_0;      // Soft reset
                                                int_on_off                 <= 1'b0;
                                                int_1                      <= 1'b0;
                                                int_2                      <= 1'b0;
                                                int_in                     <= 1'b0;
                                                pc                         <= 8'h08;
                                                sp                         <= 8'hFF;
                                                ir                         <= IR_ADD;
                                                r0                         <= 8'h00;
                                                r1                         <= 8'h00;
                                                r2                         <= 8'h00;
                                                r3                         <= 8'h00;
                                                addr                       <= 8'h00; 

            end else                            mem[mem_map_address[7:0]]  <= mem_map_in;       // Load any byte in memory
      end else begin                                                                            // Hard reset
                                                state                      <= LOAD_REGS_0;
                                                int_on_off                 <= 1'b0;
                                                int_1                      <= 1'b0;
                                                int_2                      <= 1'b0;
                                                int_in                     <= 1'b0;
                                                pc                         <= 8'h08;
                                                sp                         <= 8'hFF;
                                                ir                         <= IR_ADD;
                                                r0                         <= 8'h00;
                                                r1                         <= 8'h00;
                                                r2                         <= 8'h00;
                                                r3                         <= 8'h00;
                                                addr                       <= 8'h00; 
      end
   end  
endmodule
