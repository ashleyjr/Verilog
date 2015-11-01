module fir_filter(
	input                      clk,
	input                      nRst,
	input                      sample,  // Take a sample
	input    signed   [31:0]   in,      // Data in to filter
	output   signed   [31:0]   out      // Data out of filter
);
	parameter LENGTH = 19;
	reg signed [31:0] delay [LENGTH:0];

	assign
		out =	in				*			32'd1			+
			delay[0]			*		32'd1 + 	
			delay[1]			*		32'd1 + 	
			delay[2]			*		32'd1 + 	
			delay[3]			*		32'd1 + 	
			delay[4]			*		32'd1 + 	
			delay[5]			*		32'd1 + 	
			delay[6]			*		32'd1 + 	
			delay[7]			*		32'd1 + 	
			delay[8]			*		32'd1 + 	
			delay[9]			*		32'd1 + 	
			delay[10]			*	32'd1 + 	
			delay[11]			*	32'd1 + 	
			delay[12]			*	32'd1 + 	
			delay[13]			*	32'd1 + 	
			delay[14]			*	32'd1 + 	
			delay[15]			*	32'd1 + 	
			delay[16]			*	32'd1 + 	
			delay[17]			*	32'd1 + 	
			delay[18]			*			32'd1			+
			delay[19]			*			32'd1			;

	always @(posedge clk or negedge nRst) begin
		if(!nRst) begin
			delay[0] <= 32'b0;
		end else begin
			if(sample) begin
				delay[0] <= in;
			end
		end
	end

	genvar i;
		generate
			for (i = 0; i < LENGTH; i = i + 1) begin: pipe
				always @(posedge clk or negedge nRst) begin
					if(!nRst) begin
						delay[i] <= 32'b0;
					end else begin
						delay[i+1] <= delay[i];
					end
				end
			end
		endgenerate
endmodule
