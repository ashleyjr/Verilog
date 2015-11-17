module fm_out(
	input			clk,
	input			nRst,
	input			centre,
	input			update,
	input	[7:0]	data,
	output	reg		fm
);

	reg		[7:0]	data_reg;
	reg		[31:0]	period_in;
	reg 	[31:0] 	count_in;
	reg 	[31:0]	period_out;
	reg 	[31:0] 	count_out;
	reg				centre_0;
	reg 			centre_1;

	wire			edgey;

	assign edgey = (centre_0 & ~centre_1) | (~centre_0 & centre_1);


	assign hit = (count_out > period_out) ? 1'b1 : 1'b0;


	always@(posedge clk or negedge nRst) begin
		// Capture in centre waveform
		centre_0 <= centre;
		centre_1 <= centre_0;

		// Inputre period capture
		casex({nRst,edgey})
			2'b0x:	begin
						count_in 	<= 32'd0;
						centre_0 	<= centre;
						centre_1 	<= centre;
					end
					
			2'b11: 	begin
						count_in 	<= 32'd0;
						period_in 	<= count_in;
					end
			2'b10: 	begin
						count_in 	<= count_in + 32'd1;
					end
		endcase

		// Update the frequency offset
		casex({nRst,update})
			2'b0x:	begin
						data_reg 	<= 8'h00;
					end
			2'b11:	begin
						data_reg 	<= data;
					end
		endcase

		// calc the offset
		if(edgey) 
			if(data_reg > 8'h80) begin
				period_out <= period_in + ((period_in >> 9)*(data_reg-8'h80));
			end else begin
				period_out <= period_in - ((period_in >> 9)*(8'h80-data_reg));
			end
		
		// Generate output waveform
		casex({nRst,hit})
			2'b0x:	begin
						count_out 	<= 32'd0;
						fm <= 1'b0;
					end
			2'b11: 	begin
						count_out 	<= 32'd0;
						fm <= ~fm;
					end
			2'b10: 	begin
						count_out 	<= count_out + 32'd1;
					end
		endcase

	end
endmodule
