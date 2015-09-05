module up_datapath(
	input	   wire        clk,
	input	   wire        nRst,
   // up_alu
   input    wire        a_sel_in_a,
   input    wire        a_sel_in_b,
   input    wire  [2:0] a_op,
   // up_reg_block
   input    wire  [1:0] rb_sel_out_a,
   input    wire  [1:0] rb_sel_out_b,
   input    wire  [1:0] rb_sel_write_a,
   input    wire  [1:0] rb_sel_write_b,
   input    wire  [1:0] rb_we_a,
   input    wire  [1:0] rb_we_b,
   
   
);


   // up_alu
   wire  [7:0] a_data_in_a0;
   wire  [7:0] a_data_in_a1;
   wire  [7:0] a_data_in_b0;
   wire  [7:0] a_data_in_b1; 

   // up_reg_block
   wire  [7:0] rb_data_in_a;
   wire  [7:0] rb_data_in_b;


   up_alu up_alu(
      .data_in_a0    (a_data_in_a0     ),
      .data_in_a1    (a_data_in_a1     ),
      .data_in_b0    (a_data_in_b0     ),
      .data_in_b1    (a_data_inb1      ),
      .sel_in_a      (a_sel_in_a       ),
      .sel_in_b      (a_sel_in_b       ),
      .op            (a_op             ),
      .data_out      (                 ),
      .data_out_a    (                 ),
      .data_out_b    (                 )
   )


   up_reg_block up_reg_block(
      .clk           (clk              ),
      .nRst          (nRst             ),
      .sel_out_a     (rb_sel_out_a     ),
      .sel_out_b     (rb_sel_out_b     ),
      .sel_write_a   (rb_sel_write_a   ),
      .sel_write_b   (rb_sel_write_b   ),
      .we_a          (rb_we_a          ),
      .we_b          (rb_we_b          ),
      .data_in_a     (),
      .data_in_b     (),
      .data_out_a    (a_data_in_a0     ),
      .data_out_b    (a_data_in_b0     )
   );



endmodule
