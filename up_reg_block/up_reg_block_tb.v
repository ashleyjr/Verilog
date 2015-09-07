module up_reg_block_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg   [1:0]    sel_out_a;
   reg   [1:0]    sel_out_b;
   reg   [1:0]    sel_in;
   reg   [7:0]    data_in;
   reg            we;
   wire  [7:0]    data_out_a;
   wire  [7:0]    data_out_b;


	up_reg_block up_reg_block(
		.clk	         (clk           ),
		.nRst	         (nRst          ),
	   .sel_out_a     (sel_out_a     ),
      .sel_out_b     (sel_out_b     ),
      .sel_in        (sel_in        ), 
      .data_in       (data_in       ),
      .we            (we            ),
      .data_out_a    (data_out_a    ),
      .data_out_b    (data_out_b    ) 
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_reg_block.vcd");
		$dumpvars(0,up_reg_block_tb);
	end

	initial begin
					nRst           = 1;
               sel_out_a      = 0;
               sel_out_b      = 0;
               sel_in         = 0;
               data_in        = 0;
               we             = 0;


		#100		nRst           = 0;
		#100		nRst           = 1;


               
      // scan the outputs
      #50      sel_out_a   = 2'b00;
      #50      sel_out_a   = 2'b01;
      #50      sel_out_a   = 2'b10;
      #50      sel_out_a   = 2'b11;

	
      #50      sel_out_b   = 2'b00;
      #50      sel_out_b   = 2'b01;
      #50      sel_out_b   = 2'b10;
      #50      sel_out_b   = 2'b11;

      
      
      
      // Write individual regs
      #50      sel_in      = 2'b11;
      #50      data_in     = 8'hAA;
      #50      we          = 1;
      #50      we          = 0;

      #50      sel_in      = 2'b10;
      #50      data_in     = 8'hBB;
      #50      we          = 1;
      #50      we          = 0;

      #50      sel_in      = 2'b01;
      #50      data_in     = 8'hCC;
      #50      we          = 1;
      #50      we          = 0;

      #50      sel_in      = 2'b00;
      #50      data_in     = 8'hDD;
      #50      we          = 1;
      #50      we          = 0;




 
      // scan the outputs
      #50      sel_out_a   = 2'b00;
      #50      sel_out_a   = 2'b01;
      #50      sel_out_a   = 2'b10;
      #50      sel_out_a   = 2'b11;

	
      #50      sel_out_b   = 2'b00;
      #50      sel_out_b   = 2'b01;
      #50      sel_out_b   = 2'b10;
      #50      sel_out_b   = 2'b11;


      
      
      
      #100     nRst        = 0;
      #100     nRst        = 1;
      
      #10000
		$finish;
	end

endmodule
