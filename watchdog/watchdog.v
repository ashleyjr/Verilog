module watchdog(
	input	   clk,
	input	   nRst,
   input    sleep,   // Reset the watchdog
   input    sclk,    // serial clock
   input    in,      // serial data in
   input    sel,     // serial input listening when high
   output   woof     // The counter has lapsed when high
);

   reg   [31:0]   top;
   reg   [31:0]   count;

   assign woof = (count) ? 1'b0 : 1'b1;

   always @(posedge clk or negedge nRst) begin
      if(!nRst | sleep) begin
         count <= top;
      end else begin
         if(count) begin
            count <= count - 32'd1;
         end 
      end
   end

   always @(posedge sclk) begin
      if(sel) begin
         top <= {top[31:1],in};
      end
   end
endmodule
