module up_datapath_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg   [7:0] data_in;
   reg         sel_rb_data_in_a;
   reg         a_sel_in_a;
   reg         a_sel_in_b;
   reg   [2:0] a_op;
   reg         ir_we;
   reg   [1:0] pc_op;
   reg   [1:0] rb_sel_out_a;
   reg   [1:0] rb_sel_out_b;
   reg   [1:0] rb_sel_write_a;
   reg   [1:0] rb_sel_write_b;
   reg         rb_we_a;
   reg         rb_we_b;
   reg         sp_add;
   reg         sp_sub;


	up_datapath up_datapath(
		.clk	               (clk              ),
		.nRst	               (nRst             ),
      .data_in             (data_in          ),
      .sel_rb_data_in_a    (sel_rb_data_in_a ),
      .a_sel_in_a          (a_sel_in_a       ),
      .a_sel_in_b          (a_sel_in_b       ),
      .a_op                (a_op             ),
      .ir_we               (ir_we            ),
      .pc_op               (pc_op            ),
      .rb_sel_out_a        (rb_sel_out_a     ),
      .rb_sel_out_b        (rb_sel_out_b     ),
      .rb_sel_write_a      (rb_sel_write_a   ),
      .rb_sel_write_b      (rb_sel_write_b   ),
      .rb_we_a             (rb_we_a          ),
      .rb_we_b             (rb_we_b          ),
      .sp_add              (sp_add           ),
      .sp_sub              (sp_sub           )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_datapath.vcd");
		$dumpvars(0,up_datapath_tb);
	end

	initial begin
					nRst                 = 1;
               data_in              = 0;
               sel_rb_data_in_a     = 0;
               a_sel_in_a           = 0;
               a_sel_in_b           = 0;
               a_op                 = 0;
               ir_we                = 0;
               pc_op                = 0;
               rb_sel_out_a         = 0;
               rb_sel_out_b         = 0;
               rb_sel_write_a       = 0;
               rb_sel_write_b       = 0;
               rb_we_a              = 0;
               rb_we_b              = 0;
               sp_add               = 0;
               sp_sub               = 0;
		#100		nRst                 = 0;
		#100		nRst                 = 1;


      
      // ADD - R0 = R1 + R2
      #100     a_op                 = 3'b000;  
      #100     a_sel_in_a           = 1'b0;
      #100     a_sel_in_b           = 1'b0;
      #100     sel_rb_data_in_a     = 1'b0;
      #100     rb_sel_out_a         = 2'b01;
      #100     rb_sel_out_b         = 2'b10;
      #100     rb_sel_write_a       = 2'b00;
      #100     rb_we_a              = 1'b1;
      #100     rb_we_a              = 1'b0;


      // SUB - R0 = R1 - R2
      #100     a_op                 = 3'b001;  
      #100     a_sel_in_a           = 1'b0;
      #100     a_sel_in_b           = 1'b0;
      #100     sel_rb_data_in_a     = 1'b0;
      #100     rb_sel_out_a         = 2'b01;
      #100     rb_sel_out_b         = 2'b10;
      #100     rb_sel_write_a       = 2'b00;
      #100     rb_we_a              = 1'b1;
      #100     rb_we_a              = 1'b0;

      // MUL - R0 = R1 - R2
      #100     a_op                 = 3'b010;  
      #100     a_sel_in_a           = 1'b0;
      #100     a_sel_in_b           = 1'b0;
      #100     sel_rb_data_in_a     = 1'b0;
      #100     rb_sel_out_a         = 2'b01;
      #100     rb_sel_out_b         = 2'b10;
      #100     rb_sel_write_a       = 2'b00;
      #100     rb_we_a              = 1'b1;
      #100     rb_we_a              = 1'b0;


      // DIV - R0 = R1 - R2
      #100     a_op                 = 3'b011;  
      #100     a_sel_in_a           = 1'b0;
      #100     a_sel_in_b           = 1'b0;
      #100     sel_rb_data_in_a     = 1'b0;
      #100     rb_sel_out_a         = 2'b01;
      #100     rb_sel_out_b         = 2'b10;
      #100     rb_sel_write_a       = 2'b00;
      #100     rb_we_a              = 1'b1;
      #100     rb_we_a              = 1'b0;

      // NAND - R0 = R1 NAND R2
      #100     a_op                 = 3'b100;  
      #100     a_sel_in_a           = 1'b0;
      #100     a_sel_in_b           = 1'b0;
      #100     sel_rb_data_in_a     = 1'b0;
      #100     rb_sel_out_a         = 2'b01;
      #100     rb_sel_out_b         = 2'b10;
      #100     rb_sel_write_a       = 2'b00;
      #100     rb_we_a              = 1'b1;
      #100     rb_we_a              = 1'b0;

      // NOR - R0 = R1 NOR R2
      #100     a_op                 = 3'b101;  
      #100     a_sel_in_a           = 1'b0;
      #100     a_sel_in_b           = 1'b0;
      #100     sel_rb_data_in_a     = 1'b0;
      #100     rb_sel_out_a         = 2'b01;
      #100     rb_sel_out_b         = 2'b10;
      #100     rb_sel_write_a       = 2'b00;
      #100     rb_we_a              = 1'b1;
      #100     rb_we_a              = 1'b0;

      // CMP - R1 - R2
      #100     a_op                 = 3'b001;  
      #100     a_sel_in_a           = 1'b0;
      #100     a_sel_in_b           = 1'b0;
      #100     sel_rb_data_in_a     = 1'b0;
      #100     rb_sel_out_a         = 2'b01;
      #100     rb_sel_out_b         = 2'b10;
      #100     rb_sel_write_a       = 2'b00; 


      
      // SWP01 - R0 =  R1, R1 = R0  
      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b00;
      #CLK_PERIOD  rb_sel_out_b         = 2'b01;
      #CLK_PERIOD  rb_sel_write_a       = 2'b00;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0;

      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b00;
      #CLK_PERIOD  rb_sel_out_b         = 2'b01;
      #CLK_PERIOD  rb_sel_write_a       = 2'b01;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0; 

      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b00;
      #CLK_PERIOD  rb_sel_out_b         = 2'b01;
      #CLK_PERIOD  rb_sel_write_a       = 2'b00;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0;
	

   
      // SWP12 - R1 =  R2, R2 = R1  
      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b01;
      #CLK_PERIOD  rb_sel_out_b         = 2'b10;
      #CLK_PERIOD  rb_sel_write_a       = 2'b01;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0;

      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b01;
      #CLK_PERIOD  rb_sel_out_b         = 2'b10;
      #CLK_PERIOD  rb_sel_write_a       = 2'b10;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0; 

      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b01;
      #CLK_PERIOD  rb_sel_out_b         = 2'b10;
      #CLK_PERIOD  rb_sel_write_a       = 2'b01;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0;
	


      // SWP23 - R2 =  R3, R3 = R2  
      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b10;
      #CLK_PERIOD  rb_sel_out_b         = 2'b11;
      #CLK_PERIOD  rb_sel_write_a       = 2'b10;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0;

      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b10;
      #CLK_PERIOD  rb_sel_out_b         = 2'b11;
      #CLK_PERIOD  rb_sel_write_a       = 2'b11;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0; 

      #CLK_PERIOD  a_op                 = 3'b110;  
      #CLK_PERIOD  a_sel_in_a           = 1'b0;
      #CLK_PERIOD  a_sel_in_b           = 1'b0;
      #CLK_PERIOD  sel_rb_data_in_a     = 1'b0;
      #CLK_PERIOD  rb_sel_out_a         = 2'b10;
      #CLK_PERIOD  rb_sel_out_b         = 2'b11;
      #CLK_PERIOD  rb_sel_write_a       = 2'b10;
      #CLK_PERIOD  rb_we_a              = 1'b1;
      #CLK_PERIOD  rb_we_a              = 1'b0;
      #10000
		$finish;
	end

endmodule
