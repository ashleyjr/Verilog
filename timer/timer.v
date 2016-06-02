module timer(
	input	            clk,
	input	            nRst,            
   input    [31:0]   period_ns,           // Required output period in us
   input    [31:0]   clk_frequency_hz,    // Freqeuncy of input 'clk'
   output            hit                  // High for one clock cycle with required period     
);

   reg   [63:0]   count;
	wire  [63:0]   top;

   assign hit  = (count == 32'b0) ? 1'b1 : 1'b0; 
   assign top  = (((period_ns * clk_frequency_hz)/32'd1000000000) - 1);

   always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
		   count <= 32'd0;                                 // Reset to known state
		end else begin
         if(count >= top)     count <= 32'd0;            // On overlap reset counter
         else                 count <= count + 32'd1;    // Count
		end
	end
endmodule
