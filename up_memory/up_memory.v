module up_memory(
	input  wire			clk,
	input  wire			nRst,
	input  wire	[7:0]   in,
	input  wire	[7:0]   address,
	input  wire			we,
	output wire	[7:0]   out,
	output wire			re,
	output wire	[7:0]		test);

	reg [7:0] mem [255:0];

	assign out = mem[address];
	assign re = 1'b1;

	assign test = mem[128];	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
			mem[0] <= 8'h02;
			mem[1] <= 8'h80;
			mem[2] <= 8'h16;
			mem[3] <= 8'h80;
			mem[4] <= 8'h65;
			mem[5] <= 8'hDF;
			mem[6] <= 8'h9C;
			mem[7] <= 8'hE4;
			mem[8] <= 8'h51;
			mem[9] <= 8'h45;
			mem[10] <= 8'hD8;
			mem[11] <= 8'hFB;
			mem[12] <= 8'h6B;
			mem[13] <= 8'h5B;
			mem[14] <= 8'h45;
			mem[15] <= 8'hBE;
			mem[16] <= 8'h45;
			mem[17] <= 8'hE4;
			mem[18] <= 8'h24;
			mem[19] <= 8'h24;
			mem[20] <= 8'h24;
			mem[21] <= 8'h24;
			mem[22] <= 8'h24;
			mem[23] <= 8'h24;
			mem[24] <= 8'h56;
			mem[25] <= 8'hC6;
			mem[26] <= 8'hBE;
			mem[27] <= 8'h45;
			mem[28] <= 8'hE4;
			mem[29] <= 8'h34;
			mem[30] <= 8'h04;
			mem[31] <= 8'h04;
			mem[32] <= 8'h60;
			mem[33] <= 8'h45;
			mem[34] <= 8'h6A;
			mem[35] <= 8'h6D;
			mem[36] <= 8'hFA;
			mem[37] <= 8'h54;
			mem[38] <= 8'hA5;
			mem[39] <= 8'hA6;
			mem[40] <= 8'hA8;
			mem[41] <= 8'h00;
			mem[42] <= 8'h00;
			mem[43] <= 8'h00;
			mem[44] <= 8'h00;
			mem[45] <= 8'h00;
			mem[46] <= 8'h00;
			mem[47] <= 8'h00;
			mem[48] <= 8'h00;
			mem[49] <= 8'h00;
			mem[50] <= 8'h00;
			mem[51] <= 8'h00;
			mem[52] <= 8'h00;
			mem[53] <= 8'h00;
			mem[54] <= 8'h00;
			mem[55] <= 8'h00;
			mem[56] <= 8'h00;
			mem[57] <= 8'h00;
			mem[58] <= 8'h00;
			mem[59] <= 8'h00;
			mem[60] <= 8'h00;
			mem[61] <= 8'h00;
			mem[62] <= 8'h00;
			mem[63] <= 8'h00;
			mem[64] <= 8'h00;
			mem[65] <= 8'h00;
			mem[66] <= 8'h00;
			mem[67] <= 8'h00;
			mem[68] <= 8'h00;
			mem[69] <= 8'h00;
			mem[70] <= 8'h00;
			mem[71] <= 8'h00;
			mem[72] <= 8'h00;
			mem[73] <= 8'h00;
			mem[74] <= 8'h00;
			mem[75] <= 8'h00;
			mem[76] <= 8'h00;
			mem[77] <= 8'h00;
			mem[78] <= 8'h00;
			mem[79] <= 8'h00;
			mem[80] <= 8'h00;
			mem[81] <= 8'h00;
			mem[82] <= 8'h00;
			mem[83] <= 8'h00;
			mem[84] <= 8'h00;
			mem[85] <= 8'h00;
			mem[86] <= 8'h00;
			mem[87] <= 8'h00;
			mem[88] <= 8'h00;
			mem[89] <= 8'h00;
			mem[90] <= 8'h00;
			mem[91] <= 8'h00;
			mem[92] <= 8'h00;
			mem[93] <= 8'h00;
			mem[94] <= 8'h00;
			mem[95] <= 8'h00;
			mem[96] <= 8'h00;
			mem[97] <= 8'h00;
			mem[98] <= 8'h00;
			mem[99] <= 8'h00;
			mem[100] <= 8'h00;
			mem[101] <= 8'h00;
			mem[102] <= 8'h00;
			mem[103] <= 8'h00;
			mem[104] <= 8'h00;
			mem[105] <= 8'h00;
			mem[106] <= 8'h00;
			mem[107] <= 8'h00;
			mem[108] <= 8'h00;
			mem[109] <= 8'h00;
			mem[110] <= 8'h00;
			mem[111] <= 8'h00;
			mem[112] <= 8'h00;
			mem[113] <= 8'h00;
			mem[114] <= 8'h00;
			mem[115] <= 8'h00;
			mem[116] <= 8'h00;
			mem[117] <= 8'h00;
			mem[118] <= 8'h00;
			mem[119] <= 8'h00;
			mem[120] <= 8'h00;
			mem[121] <= 8'h00;
			mem[122] <= 8'h00;
			mem[123] <= 8'h00;
			mem[124] <= 8'h00;
			mem[125] <= 8'h00;
			mem[126] <= 8'h00;
			mem[127] <= 8'h00;
		end else begin
			if(we) mem[address] <= in;
		end
	end

endmodule