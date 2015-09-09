module up_memory_tb;

	parameter CLK_PERIOD = 20;

	reg clk;
	reg nRst;

	up_memory up_memory(
		.clk	(clk),
		.nRst	(nRst)
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_memory.vcd");
		$dumpvars(0,up_memory_tb);
	end

	initial begin
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;
		#10000
		$finish;
	end

endmodule
