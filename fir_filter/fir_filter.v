module fir_filter(
   input                clk,
   input                nRst,
   input       [31:0]   in,      // Data in to filter
   output reg  [31:0]   out      // Data out of filter
);
   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         out   <=    32'b0;
      end else begin
         out   <=    in;      
      end
   end
endmodule
