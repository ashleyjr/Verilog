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
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;
		#10000
		$finish;
	end

endmodule
