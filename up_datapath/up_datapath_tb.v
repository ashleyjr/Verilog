module up_datapath_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg   [7:0] data_in;
   reg         rb_sel_data_in;
   reg         a_sel_in_a;
   reg         a_sel_in_b;
   reg   [3:0] a_op;
   reg         ir_we;
   reg         pc_we;
   reg   [1:0] rb_sel_out_a;
   reg   [1:0] rb_sel_out_b;
   reg   [1:0] rb_sel_in;
   reg         rb_we;
   reg         sp_we;
   wire  [7:0] data_out;
   wire  [3:0] ir;


	up_datapath up_datapath(
		.clk	               (clk              ),
		.nRst	               (nRst             ),
      .data_in             (data_in          ),
      .a_sel_in_a          (a_sel_in_a       ),
      .a_sel_in_b          (a_sel_in_b       ),
      .a_op                (a_op             ),
      .ir_we               (ir_we            ),
      .pc_we               (pc_we            ),
      .rb_sel_out_a        (rb_sel_out_a     ),
      .rb_sel_out_b        (rb_sel_out_b     ),
      .rb_sel_in           (rb_sel_in        ), 
      .rb_we               (rb_we            ),
      .sp_we               (sp_we            ),
      .data_out            (data_out         ),
      .ir                  (ir               )     
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
        
               // Default setup 
               data_in              = 8'h00;
               rb_sel_data_in       = 1'b0;
               a_sel_in_a           = 1'b0;
               a_sel_in_b           = 1'b0;
               a_op                 = 3'b000;
               ir_we                = 1'b0;
               pc_we                = 1'b0;
               rb_sel_out_a         = 2'b00;
               rb_sel_out_b         = 2'b00;
               rb_sel_in            = 2'b00;
               rb_we                = 1'b0;
               sp_we                = 1'b0;



		#100		nRst                 = 0;
		#100		nRst                 = 1;


      #10000
		$finish;
	end

endmodule
