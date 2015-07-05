module fir_filter(
   input                clk,
   input                nRst,
   input       [31:0]   in,      // Data in to filter
   output      [31:0]   out      // Data out of filter
);
   
   parameter LENGTH = 4;

   parameter M0   = 32'd0;
   parameter M1   = 32'd1;
   parameter M2   = 32'd2;
   parameter M3   = 32'd3;
   parameter M4   = 32'd4;
   
   //reg [31:0] multi [LENGTH:0]   
   //   =  {
   //         32'd0,
   //         32'd1,
   //         32'd2,
   //         32'd3,
   //         32'd4
   //      };
   //
      reg [31:0] delay [LENGTH-1:0];

   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         delay[0] <= 32'b0;
      end else begin      
         delay[0] <= in;
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
 
   assign out = in*M0 + delay[0]*M1 + delay[1]*M2 + delay[2]*M3 + delay[3]*M4; 
   

endmodule
