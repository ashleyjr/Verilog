module phase_out(
	input			clk,
	input			nRst,
	input			freq,
	input 	[7:0]	phase,
	input			update,
	output			out
);

	reg 	[31:0]	period_in;
	reg 	[31:0] 	count_in;
	reg 	[7:0]	sample_count;
	reg		[255:0]	line;
	reg				freq_0;
	reg				freq_1;


	wire 			edgey;
	wire			take;

	assign edgey = (freq_0 & ~freq_1) | (~freq_0 & freq_1);

	assign take = (sample_count == (period_in >> 8)) ? 1'b1 : 1'b0;

	assign out = line[phase];

	always@(posedge clk or negedge nRst) begin
		// Capture input waveform
		freq_0 <= freq;
		freq_1 <= freq_0;

		// Inputre period capture
		casex({nRst,edgey})
			2'b0x:	begin
						count_in 	<= 32'd0;
						freq_0 	<= freq;
						freq_1 	<= freq;
					end
					
			2'b11: 	begin
						count_in 	<= 32'd0;
						period_in 	<= count_in;
					end
			2'b10: 	begin
						count_in 	<= count_in + 32'd1;
					end
		endcase


		// Sample clk
		casex({nRst,take})
			2'b0x:	begin
						sample_count <= 8'd0;
					end	
			2'b10: 	begin
						sample_count <= sample_count + 8'd1;
					end
			2'b11: 	begin
						sample_count <= 8'd0;
						line[0] <= freq;
					end
		endcase
	end

	genvar i;
		generate
			for (i = 0; i < 255; i = i + 1) begin: delay
				always @(posedge clk or negedge nRst) begin
					if(!nRst) 				line[i] <= 8'b0;
					else if(take) begin
					 	line[i+1] <= line[i];
					 	line[0] <= freq;
					 end
				end
			end
		endgenerate

endmodule
