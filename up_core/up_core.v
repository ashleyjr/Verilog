module up_core(
	input	            clk,
	input	            nRst, 
   input             int
);


   reg   [3:0] ir;
   reg   [4:0] op;
   reg         ir_we;
   reg         pc_we;
   reg   [2:0] rb_sel;
   reg         rb_we;
   reg         sp_we;
   reg         mem_we;
   reg         ale;
  

   // Address latch
   reg   [7:0] address_latch;
 
   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         address_latch <= 8'h00;
      end else begin
         if(ale) address_latch <= data_out;
      end
   end


   // Memory
   parameter   SIZE           = 256;
   parameter   LEDS_LOC       = 160;
   parameter   S_MEM_ONLY     = 2'b00;
   parameter   S_MEM_LOAD_1   = 2'b01;
   parameter   S_MEM_LOAD_2   = 2'b10;

   wire [7:0] data_in;
	reg [7:0]   mem   [SIZE-1:0];

   assign data_in        = mem[address_latch];
  
   integer i;
   always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         for (i=0; i<SIZE; i=i+1) begin 
            mem[i]   <= 8'h00;
         end
      end else begin
         if(mem_we)      mem[address_latch]   <= data_out;
      end
	end



   // Controller
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
                                                      op       = 5'b01110;
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
                           if(int_in)                 op       = 5'b11110;
                           else                       op       = 5'b10100;
                                                      ale      = 1'b1;
                        end
         DECODE:        begin
                                                      op       = 5'b10101;
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
                                                      op       = 5'b10110;
                                                      pc_we    = 1'b1;
                                 end
                           4'h8:       begin
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                       end
                           4'h9,4'hB:  begin
                                                      op       = 5'b11001;
                                                      ale      = 1'b1;
                                       end
                           4'hA:       begin
                                                      op       = 5'b01000;
                                                      sp_we    = 1'b1;
                                                      ale      = 1'b1;
                                       end
                           4'hC,4'hD:  begin
                                                      op       = 5'b10110;
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
                                                      op       = 5'b11010;
                                                      sp_we    = 1'b1;
                                             end
                           4'hA,4'hC:        begin
                                                      rb_sel   = 3'b010;
                                                      rb_we    = 1'b1;
                                             end
                           4'hD:             begin
                                                      op       = 5'b11100;
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
                                                      op       = 5'b11101;
                                                      mem_we   = 1'b1;
                                             end
                           4'hB:             begin
                                                      op       = 5'b11100;
                                                      mem_we   = 1'b1;
                                             end
                        endcase
         INT_1:                              begin
                                                      op       = 5'b11001;    // Add sp
                                                      ale      = 1'b1;
                                             end 
         INT_2:                              begin
                                                      op       = 5'b11011;    // Write PC
                                                      mem_we   = 1'b1;
                                             end
         INT_3:                              begin
                                                      op       = 5'b11010;    // Dec SP
                                                      sp_we    = 1'b1;
                                             end
         INT_4:                              begin
                                                      op       = 5'b01110;    // Jump to fixed location
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
            FETCH:         if(1)
                              if(int_go)                                         state <= INT_1;
                              else                                               state <= DECODE;
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
   reg   [7:0]    sp;
   reg   [7:0]    pc;
   reg   [7:0]    r0;
   reg   [7:0]    r1;
   reg   [7:0]    r2;
   reg   [7:0]    r3;  

   assign z = (r1 == r2) ? 1'b1 : 1'b0;
   
   assign   data_out =
               (op == 5'b00000   )        ? r1 + r2            :
               (op == 5'b00001   )        ? r1 - r2            :
               (op == 5'b00010   )        ? r1 * r2            :
               (op == 5'b00011   )        ? ~(r1 & r2)         :
               (op == 5'b00100   )        ? r0 ^ r1            :
               (op == 5'b00101   )        ? r1 ^ r2            :
               (op == 5'b00110   )        ? r2 ^ r3            : 
               (op == 5'b01110   )        ? 8'h00              :
               (op == 5'b10001   )        ? 8'h01              :
               (op == 5'b10010   )        ? 8'h02              :
               (op == 5'b10011   )        ? 8'h03              :
               (op == 5'b10100   )        ? {1'b0,pc[7:1]}     :
               (op == 5'b10101   )        ? pc + 1'b1             :
               (op == 5'b10110   )        ? r3                 :
               (op == 5'b01000   )        ? sp + 1'b1             :
               (op == 5'b11001   )        ? sp                 :
               (op == 5'b11010   )        ? sp - 1'b1             :
               (op == 5'b11011   )        ? pc                 :
               (op == 5'b11100   )        ? r2                 :
               (op == 5'b11101   )        ? pc - 1'b1                 :
               (op == 5'b11110   )        ? {1'b1,pc[7:1]}     : 
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

endmodule
