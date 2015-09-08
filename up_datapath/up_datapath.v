module up_datapath(
   // ip_datapath
	input	   wire        clk,
	input	   wire        nRst,
   input    wire  [7:0] data_in,
   input    wire        rb_sel_data_in,
   // up_alu
   input    wire        a_sel_in_a,
   input    wire        a_sel_in_b,
   input    wire  [2:0] a_op,
   // up_instruction_register
   input    wire        ir_we,
   // up_program_counter
   input    wire        pc_we,
   // up_reg_block
   input    wire  [1:0] rb_sel_out_a,
   input    wire  [1:0] rb_sel_out_b,
   input    wire  [1:0] rb_sel_in,
   input    wire        rb_we,
   // up_stack_pointer
   input    wire        sp_we,
   // outputs
   output   wire  [7:0] data_out,
   output   wire  [3:0] ir
   
);
      
   // Parameters
   parameter   REG_ON_RES_0   = 8'h01,
               REG_ON_RES_1   = 8'h02,
               REG_ON_RES_2   = 8'h03,
               REG_ON_RES_3   = 8'h04;

   parameter   SEL_0          = 2'b00,
               SEL_1          = 2'b01,
               SEL_2          = 2'b10,
               SEL_3          = 2'b11;

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

   // up_alu
   wire  [7:0] a_data_in_a0;
   wire  [7:0] a_data_in_a1;
   wire  [7:0] a_data_in_b0;
   wire  [7:0] a_data_in_b1; 
   wire  [7:0] rb_data_in;


   reg   [7:0]    sp;
   reg   [7:0]    pc;
   reg   [3:0]    ir;
   reg   [7:0]    r0;
   reg   [7:0]    r1;
   reg   [7:0]    r2;
   reg   [7:0]    r3;  
   
   wire  [7:0]    rb_data_out_a;
   wire  [7:0]    rb_data_out_b;

   assign   rb_data_in = 
               (rb_sel_data_in)           ? data_in : data_out;

   assign   rb_data_out_a = 
               (rb_sel_out_a == SEL_0)    ? r0:
               (rb_sel_out_a == SEL_1)    ? r1:
               (rb_sel_out_a == SEL_2)    ? r2: r3;

   assign   rb_data_out_b = 
               (rb_sel_out_b == SEL_0)    ? r0:
               (rb_sel_out_b == SEL_1)    ? r1:
               (rb_sel_out_b == SEL_2)    ? r2: r3;

   assign   data_out =
               (op == ADD  )              ? rb_data_out_a +  rb_data_out_b  :
               (op == SUB  )              ? rb_data_out_a -  rb_data_out_b  :
               (op == MUL  )              ? rb_data_out_a *  rb_data_out_b  :
               (op == DIV  )              ? rb_data_out_a /  rb_data_out_b  :
               (op == NAND )              ? rb_data_out_a ~& rb_data_out_b  :
               (op == NOR  )              ? rb_data_out_a ~| rb_data_out_b  :
               (op == XOR  )              ? rb_data_out_a ^  rb_data_out_b  : data_out_b;

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
         if(sp_we)   sp <= data_out;
         if(pc_we)   pc <= data_out;
         if(rb_we) 
            case(rb_sel_in) 
               SEL_0:   r0 <= rb_data_in;  
               SEL_1:   r1 <= rb_data_in;
               SEL_2:   r2 <= rb_data_in;
               SEL_3:   r3 <= rb_data_in;
            endcase
         if(ir_we)
            if(pc[0])
               ir <= data_in[7:4];
            else
               ir <= data_in[3:0];
      end
   end
  
   assign rb_data_in = (rb_sel_data_in) ? data_in : data_out;
   

endmodule
