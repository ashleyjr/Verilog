module watchdog(
	input	   clk,
	input	   nRst,
   input    sleep,
   output   woof
);

   reg [31:0] count;

   assign woof = (count) ? 1'b0 : 1'b1;

   always @(posedge clk or negedge nRst) begin
      if(!nRst | sleep) begin
         count <= 32'd100;
      end else begin
         if(count) begin
            count <= count - 32'd1;
         end 
      end
   end
endmodule
