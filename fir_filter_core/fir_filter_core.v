module fir_filter_core(
	input                      	clk,
	input                      	nRst,
	input                      	sample,  		// Sample input
	input						coeffs_shift,	// Shift coeffs along one
	input    			[31:0] 	data_in,      	// Data in to filter
	input				[7:0]	coeffs_in,		// Coeffcients in to filter
	output   	reg 	[31:0] 	data_out,  		// Data out of filter
	output				[7:0]	coeffs_out		// Coeffcients out of filter
);	
	parameter LENGTH = 20;




	// The coeff pipe

	reg [7:0] coeffs [LENGTH:0];										// Registers

	assign coeffs_out = coeffs[LENGTH];									// Take output

	always @(posedge clk or negedge nRst) begin 						// Reset the pipe
		if(!nRst) 				coeffs[0] <= 8'b0;
		else if(coeffs_shift) 	coeffs[0] <= coeffs_in;
	end

	genvar i;
		generate
			for (i = 0; i < LENGTH; i = i + 1) begin: coeff_pipe		// Shift between regs
				always @(posedge clk or negedge nRst) begin
					if(!nRst) 				coeffs[i] <= 8'b0;
					else if(coeffs_shift) 	coeffs[i+1] <= coeffs[i];
				end
			end
		endgenerate



	// The data pipe

	reg [31:0] data [LENGTH:0];											// Registers

	always @(posedge clk or negedge nRst) begin 						// Reset the pipe
		if(!nRst) 			data[0] <= 32'b0;
		else if(sample) 	data[0] <= data_in;
	end

	genvar j;
		generate
			for (j = 0; j < LENGTH; j = j + 1) begin : data_pipe		// Shift between regs
				always @(posedge clk or negedge nRst) begin
					if(!nRst) 			data[j] <= 32'b0;
					else if(sample) 	data[j+1] <= data[j];
				end
			end
		endgenerate


	// MAC
	integer k;
	always @(posedge clk) begin 
		if(!nRst) 
			data_out <= 32'b0;
		else
			data_out = 32'b0;
			for(k=0;k<LENGTH;k=k+1) begin
				data_out = data_out + (coeffs[k]*data[k]);
			end
	end
endmodule
