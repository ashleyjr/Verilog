module up_alu(
	input	wire			clk,
	input	wire			nRst,
	input	wire	[7:0]	data_in_a0,
	input	wire	[7:0]	data_in_a1,
	input	wire	[7:0]	data_in_b0,
	input	wire	[7:0]	data_in_b1,
	input	wire			sel_in_a,
	input	wire			sel_in_b,
	input	wire	[3:0]	op,
	output	wire	[7:0]	data_out,
	output  wire	[7:0]	data_out_a,
	output	wire	[7:0]	data_out_b
);

	parameter	ADD		= 3'b000,
				SUB		= 3'b001,
				MUL 	= 3'b010,
				DIV 	= 3'b011,
				NAND 	= 3'b100,
				NOR 	= 3'b101,
				A 		= 3'b110,
				B 		= 3'b111;

	assign data_out_a = (sel_in_a) ? data_in_a1 : data_in_a0;
	assign data_out_b = (sel_in_b) ? data_in_b1 : data_in_b0; 

	assign data_out =
			(op == ADD	) ? data_out_a + data_out_b 	:
			(op == SUB	) ? data_out_a - data_out_b 	:
			(op == MUL 	) ? data_out_a * data_out_b 	:
			(op == DIV	) ? data_out_a / data_out_b 	:
			(op == NAND	) ? data_out_a + data_out_b 	:
			(op == NOR	) ? data_out_a + data_out_b 	:
			(op == A 	) ? data_out_a   				: data_out_b;

endmodule
