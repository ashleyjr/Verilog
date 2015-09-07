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
      

   // up_alu
   wire  [7:0] a_data_in_a0;
   wire  [7:0] a_data_in_a1;
   wire  [7:0] a_data_in_b0;
   wire  [7:0] a_data_in_b1; 
   wire  [7:0] rb_data_in;

   // internal    
   reg   [7:0] sp;
   reg   [7:0] pc;
   
   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         pc <= 8'h00;
         sp <= 8'hFF;
      end else begin
         if(sp_we)   sp <= data_out;
         if(pc_we)   pc <= data_out;
      end
   end
  
   assign rb_data_in = (rb_sel_data_in) ? data_in : data_out;
   
   
   up_alu up_alu(
      .data_in_a0    (a_data_in_a0     ),
      .data_in_a1    (a_data_in_a1     ),
      .data_in_b0    (a_data_in_b0     ),
      .data_in_b1    (a_data_in_b1     ),
      .sel_in_a      (a_sel_in_a       ),
      .sel_in_b      (a_sel_in_b       ),
      .op            (a_op             ),
      .data_out      (data_out         )
   );

   up_instruction_register up_instruction_register(
      .clk           (clk              ),
      .nRst          (nRst             ),
      .we            (ir_we            ),
      .sel           (pc[0]            ),
      .in            (data_in          ),
      .ir            (ir               )
   );

   up_reg_block up_reg_block(
      .clk           (clk              ),
      .nRst          (nRst             ),
      .sel_out_a     (rb_sel_out_a     ),
      .sel_out_b     (rb_sel_out_b     ),
      .sel_in        (rb_sel_in        ),
      .data_in       (rb_data_in       ),
      .we            (rb_we            ),
      .data_out_a    (a_data_in_a0     ),
      .data_out_b    (a_data_in_b0     )
   );


endmodule
