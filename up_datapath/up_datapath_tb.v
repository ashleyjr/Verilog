module up_datapath_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg   [7:0] data_in; 
   reg   [4:0] op;
   reg         ir_we;
   reg         pc_we;
   reg   [2:0] rb_sel_in;
   reg         rb_we;
   reg         sp_we;
   wire  [7:0] data_out;
   wire  [3:0] ir;


	up_datapath up_datapath(
		.clk	               (clk              ),
		.nRst	               (nRst             ),
      .data_in             (data_in          ), 
      .op                  (op               ),
      .ir_we               (ir_we            ),
      .pc_we               (pc_we            ),
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
					nRst        = 1;
        
               // Default 
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b000;
               rb_we       = 1'b0;
               sp_we       = 1'b0;


		#100		nRst        = 0;
		#100		nRst        = 1;


               // ADD
               #50
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b100;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #50
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b000;
               rb_we       = 1'b0;
               sp_we       = 1'b0;

              
               // SUB
               #50
               data_in     = 8'h00; 
               op          = 5'b00001;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b100;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #50
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b000;
               rb_we       = 1'b0;
               sp_we       = 1'b0;



               // MUL
               #50
               data_in     = 8'h00; 
               op          = 5'b00010;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b100;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #50
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b000;
               rb_we       = 1'b0;
               sp_we       = 1'b0;



               // DIV
               #50
               data_in     = 8'h00; 
               op          = 5'b00011;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b100;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #50
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b000;
               rb_we       = 1'b0;
               sp_we       = 1'b0;


               // NAND
               #50
               data_in     = 8'h00; 
               op          = 5'b00100;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b100;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #50
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b000;
               rb_we       = 1'b0;
               sp_we       = 1'b0;


              
               // XOR_01
               #50
               data_in     = 8'h00; 
               op          = 5'b00101;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b100;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #CLK_PERIOD
               data_in     = 8'h00; 
               op          = 5'b00101;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b101;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #CLK_PERIOD
               data_in     = 8'h00; 
               op          = 5'b00101;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b100;
               rb_we       = 1'b1;
               sp_we       = 1'b0;
               #CLK_PERIOD
               data_in     = 8'h00; 
               op          = 5'b00000;
               ir_we       = 1'b0;
               pc_we       = 1'b0;
               rb_sel_in   = 3'b000;
               rb_we       = 1'b0;
               sp_we       = 1'b0;


         
      #10000
		$finish;
	end

endmodule
