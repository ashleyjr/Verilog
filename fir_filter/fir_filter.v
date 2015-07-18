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
			delay[0]			*			32'd2			+
			delay[1]			*			32'd3			+
			delay[2]			*			32'd4			+
			delay[3]			*			32'd5			+
			delay[4]			*			32'd6			+
			delay[5]			*			32'd7			+
			delay[6]			*			32'd8			+
			delay[7]			*			32'd9			+
			delay[8]			*			32'd10			+
			delay[9]			*			32'd11			+
			delay[10]			*			32'd12			+
			delay[11]			*			32'd13			+
			delay[12]			*			32'd1			+
			delay[13]			*			32'd22345			+
			delay[14]			*			32'd2345234			+
			delay[15]			*			32'd2345234			+
			delay[16]			*			32'd342252345			+
			delay[17]			*			32'd2345234532			+
			delay[18]			*			32'd345324			+
			delay[19]			*			32'd3452345			;

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
