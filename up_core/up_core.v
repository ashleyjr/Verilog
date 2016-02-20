module up_core(
	input	            clk,
	input	            nRst,
   input    [7:0]    data_in,
   input             mem_re, 
   input             int,
   output   [7:0]    data_out,
   output            mem_we
);

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
			// Reset code
		end else begin
			// Active code
		end
	end
endmodule
