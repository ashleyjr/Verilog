module dac(
	input	            clk,
	input	            nRst,
   output reg [7:0]  out
);

   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         out <= 8'd0;
      end else begin
         out <= out + 8'd1;
      end
   end

endmodule
