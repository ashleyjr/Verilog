module up_reg_block_tb;

	parameter CLK_PERIOD = 20;

	reg clk;
	reg nRst;

	up_reg_block up_reg_block(
		.clk	(clk),
		.nRst	(nRst)
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
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;
		#10000
		$finish;
	end

endmodule
