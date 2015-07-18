module fir_filter(
   input                      clk,
   input                      nRst,
   input                      sample,  // Take a sample
   input    signed   [31:0]   in,      // Data in to filter
   output   signed   [31:0]   out      // Data out of filter
);
  
   parameter LENGTH = 4;
  
   reg signed [31:0] delay [LENGTH-1:0];

   assign
      out = in       * 32'd1 + 
            delay[0] * 32'd2 +
            delay[1] * 32'd3 +
            delay[2] * 32'd4 +
            delay[3] * 32'd5 ;


   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         delay[0] <= 32'b0;
      end else begin     
         if(sample)
            delay[0] <= in;
         end
      end
   end

   genvar i;
   generate
      for (i = 1; i < LENGTH; i = i + 1) begin: pipe
         always @(posedge clk or negedge nRst) begin
            if(!nRst) begin
               delay[i] <= 32'b0;
            end else begin
               delay[i] <= delay[i-1];
            end
         end
      end
   endgenerate

endmodule
