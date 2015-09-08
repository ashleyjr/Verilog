module up_datapath(
   // ip_datapath
	input	   wire        clk,
	input	   wire        nRst,
   input    wire  [7:0] data_in,
   // up_alu
   input    wire        a_sel_in_a,
   input    wire        a_sel_in_b,
   input    wire  [3:0] a_op,
   // up_instruction_register
   input    wire        ir_we,
   // up_program_counter
   input    wire        pc_we,
   // up_reg_block
   input    wire  [1:0] rb_sel_out_a,
   input    wire  [1:0] rb_sel_out_b,
   input    wire  [2:0] rb_sel_in,
   input    wire        rb_we,
   // up_stack_pointer
   input    wire        sp_we,
   // outputs
   output   wire  [7:0] data_out,
   output   reg   [3:0] ir
   
);
      
   // Parameters
   parameter   REG_ON_RES_0   = 8'h01,
               REG_ON_RES_1   = 8'h02,
               REG_ON_RES_2   = 8'h03,
               REG_ON_RES_3   = 8'h04;

   parameter   SEL_I0         = 3'b000,
               SEL_I1         = 3'b001,
               SEL_I2         = 3'b010,
               SEL_I3         = 3'b011;
               SEL_O0         = 3'b100,
               SEL_O1         = 3'b101,
               SEL_O2         = 3'b110,
               SEL_O3         = 3'b111;

   parameter   ADD            = 4'h0,
               SUB            = 4'h1,
               MUL            = 4'h2,
               DIV            = 4'h3,
               NAND           = 4'h4,
               NOR            = 4'h5,
               XOR            = 4'h6,
               B              = 4'h7;

   parameter   TOP            = 1'b1,
               BOTTOM         = 1'b0;


   reg   [7:0]    sp;
   reg   [7:0]    pc;
   reg   [7:0]    r0;
   reg   [7:0]    r1;
   reg   [7:0]    r2;
   reg   [7:0]    r3;  


   wire  [7:0]    a_data_in_a;
   wire  [7:0]    a_data_in_b;
   
   wire  [7:0]    rb_data_out_a;
   wire  [7:0]    rb_data_out_b;

   assign   rb_data_out_a = 
               (rb_sel_out_a == SEL_0)    ? r0:
               (rb_sel_out_a == SEL_1)    ? r1:
               (rb_sel_out_a == SEL_2)    ? r2: r3;

   assign   rb_data_out_b = 
               (rb_sel_out_b == SEL_0)    ? r0:
               (rb_sel_out_b == SEL_1)    ? r1:
               (rb_sel_out_b == SEL_2)    ? r2: r3;

   assign   a_data_in_a = 
               (a_sel_in_a)               ? rb_data_out_a : sp;

   assign   a_data_in_b = 
               (a_sel_in_b)               ? rb_data_out_b : pc;      

   assign   data_out =
               (op == ADD  )              ? a_data_in_a +  a_data_in_b  :
               (op == SUB  )              ? a_data_in_a -  a_data_in_b  :
               (op == MUL  )              ? a_data_in_a *  a_data_in_b  :
               (op == DIV  )              ? a_data_in_a /  a_data_in_b  :
               (op == NAND )              ? a_data_in_a ~& a_data_in_b  :
               (op == NOR  )              ? a_data_in_a ~| a_data_in_b  :
               (op == XOR  )              ? a_data_in_a ^  a_data_in_b  : 
               (op == B    )              ? a_data_in_b                 : 8'h00;

   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         pc <= 8'h00;
         sp <= 8'hFF;
         ir <= 4'h0;
         r0 <= REG_ON_RES_0;
         r1 <= REG_ON_RES_1;
         r2 <= REG_ON_RES_2;
         r3 <= REG_ON_RES_3;  
      end else begin
         if(ir_we)
            if(pc[0])   ir <= data_in[7:4];
            else        ir <= data_in[3:0];
         if(sp_we)      sp <= data_out;
         if(pc_we)      pc <= data_out;
         if(rb_we) 
            case(rb_sel_in) 
               SEL_I0:  r0 <= data_in;  
               SEL_I1:  r1 <= data_in;
               SEL_I2:  r2 <= data_in;
               SEL_I3:  r3 <= data_in;
               SEL_O0:  r0 <= data_out;  
               SEL_O1:  r1 <= data_out;
               SEL_O2:  r2 <= data_out;
               SEL_O3:  r3 <= data_out;
            endcase
      end
   end
endmodule
