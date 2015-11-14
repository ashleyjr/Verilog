module pwm_in(
	input	clk,
	input	nRst
);

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
			// Reset code
		end else begin
			// Active code
		end
	end
endmodule
