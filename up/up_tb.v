module up_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg   [1:0]    sel_out_a;
   reg   [1:0]    sel_out_b;
   reg   [2:0]    sel_write;
   reg   [7:0]    data_in;
   wire  [7:0]    data_out_a;
   wire  [7:0]    data_out_b;


	up up(
		.clk	      (clk        ),
		.nRst	      (nRst       ),
	   .sel_out_a  (sel_out_a  ),
      .sel_out_b  (sel_out_b  ),
      .sel_write  (sel_write  ),
      .data_in    (data_in    ),
      .data_out_a (data_out_a ),
      .data_out_b (data_out_b ) 
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up.vcd");
		$dumpvars(0,up_tb);
	end

	initial begin
					nRst        = 1;
               sel_out_a   = 0;
               sel_out_b   = 0;
               sel_write   = 0;
               data_in     = 0;


		#100		nRst        = 0;
		#100		nRst        = 1;

      // Write all regs
      #50      data_in     = 8'hAA;
               sel_write   = 3'b100;

      // Write individual regs
      #50      data_in     = 8'hBB;
               sel_write   = 3'b000;
      
      #50      data_in     = 8'hCC;
               sel_write   = 3'b001;

      #50      data_in     = 8'hDD;
               sel_write   = 3'b010;

      #50      data_in     = 8'hEE;
               sel_write   = 3'b011;

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
