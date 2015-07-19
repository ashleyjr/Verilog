module watchdog(
	input	   clk,
	input	   nRst,
   input    sclk,    // serial clock
   input    in,      // serial data in
   input    sel,     // serial input listening when high also resets watch dog
   output   woof     // The counter has lapsed when high
);

   parameter DEFAULT = 32'd1000;

   reg   [31:0]   top;
   reg   [31:0]   count;

   assign woof = (count) ? 1'b0 : 1'b1;

   always @(posedge clk or negedge nRst) begin
      if(!nRst | sel) begin
         count <= top;
      end else begin
         if(count) begin
            count <= count - 32'd1;
         end
      end
   end

   always @(posedge sclk or negedge nRst) begin
      if(!nRst) begin
         top <= DEFAULT;
      end else begin
         if(sel) begin
            top <= {top[30:0],in};
         end
      end
   end
endmodule
