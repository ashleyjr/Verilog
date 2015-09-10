module up_controller(
	input			clk,
	input			nRst
	input			int,
	input	[3:0]	ir,
	input 			mem_re,
	output	[4:0]	op,
	output			ir_we,
	output			pc_we,
	output	[2:0]	rb_sel_in,
	output 			rb_we,
	output 			sp_we,
	output 			mem_we,
	output			ale
);

endmodule
