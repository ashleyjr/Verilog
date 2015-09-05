module up_reg_block_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg   [1:0]    sel_out_a;
   reg   [1:0]    sel_out_b;
   reg   [1:0]    sel_write_a;
   reg   [1:0]    sel_write_b;
   reg            we_a;
   reg            we_b;
   reg   [7:0]    data_in_a;
   reg   [7:0]    data_in_b;
   wire  [7:0]    data_out_a;
   wire  [7:0]    data_out_b;


	up_reg_block up_reg_block(
		.clk	         (clk           ),
		.nRst	         (nRst          ),
	   .sel_out_a     (sel_out_a     ),
      .sel_out_b     (sel_out_b     ),
      .sel_write_a   (sel_write_a   ),
      .sel_write_b   (sel_write_b   ),
      .we_a          (we_a          ),
      .we_b          (we_b          ),
      .data_in_a     (data_in_a     ),
      .data_in_b     (data_in_b     ),
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
               sel_write_a    = 0;
               sel_write_b    = 0;
               we_a           = 0;
               we_b           = 0;
               data_in_a      = 0;
               data_in_b      = 0;


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
      #50      data_in_a      = 8'hAA;
               data_in_b      = 8'hBB;        
               sel_write_a    = 2'b00;
               sel_write_b    = 2'b01;
      #50      we_a           = 1;
               we_b           = 1;
      #20      we_a           = 0;
               we_b           = 0;

      #50      data_in_a      = 8'hCC;
               data_in_b      = 8'hDD;        
               sel_write_a    = 2'b10;
               sel_write_b    = 2'b11;
      #50      we_a           = 1; 
               we_b           = 1;
      #20      we_a           = 0;
               we_b           = 0;


               
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
      
      #50      data_in_a      = 8'h00;
               data_in_b      = 8'h11;
               sel_write_a    = 2'b00;
               sel_write_b    = 2'b00;
      #50      we_a           = 1; 
               we_b           = 1;
      #20      we_a           = 0;
               we_b           = 0;



      #50      data_in_a      = 8'h22;
               data_in_b      = 8'h33;
               sel_write_a    = 2'b01;
               sel_write_b    = 2'b01;
      #50      we_a           = 1; 
               we_b           = 1;
      #20      we_a           = 0;
               we_b           = 0;






      #50      data_in_a      = 8'h44;
               data_in_b      = 8'h55;
               sel_write_a    = 2'b10;
               sel_write_b    = 2'b10;
      #50      we_a           = 1; 
               we_b           = 1;
      #20      we_a           = 0;
               we_b           = 0;





      #50      data_in_a      = 8'h66;
               data_in_b      = 8'h77;
               sel_write_a    = 2'b11;
               sel_write_b    = 2'b11;
      #50      we_a           = 1; 
               we_b           = 1;
      #20      we_a           = 0;
               we_b           = 0;





      #100     nRst        = 0;
      #100     nRst        = 1;
      
      #10000
		$finish;
	end

endmodule
