module pwm(
	input	clk,
	input	nRst
);

   reg [31:0]  count;
   reg [31:0]  period;
   reg [31:0]  duty;
   reg         out;

   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         out      <= 1'b0;
         duty     <= 32'd1000;
         period   <= 32'd2000;
         count    <= 32'd0;
      end else begin
         if(count == period) begin
            count <= 32'd0;
            out   <= !out;
         end else begin
            if(count == duty) begin
               out <= !out;
            end
            count <= count + 1;
         end
      end
   end
endmodule
