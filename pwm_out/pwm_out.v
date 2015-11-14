module pwm_out(
	input	      clk,
	input	      nRst,
   input       sclk,
   input       sin,
   input       sen,
   output reg  out
);

   reg [31:0]  count;
   reg [31:0]  new_period;
   reg [31:0]  period;
   reg [31:0]  new_duty;
   reg [31:0]  duty;
   reg         update;

   always @(posedge sclk or negedge nRst) begin
      if(!nRst) begin
         new_period  <= 32'd0;
         new_duty    <= 32'd0;
      end else begin
         if(sen) begin
            {new_period,new_duty} <= {new_period[30:0],new_duty,sin};
         end 
      end
   end

   always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         out      <= 1'b0;
         period   <= 32'd0;
         duty     <= 32'd1;
         count    <= 32'd0;
      end else begin
         if(   (duty > period)   |
               (period == 32'd0) ) begin
            out <= 1'b0;
            if(!sen) begin
               period   <= new_period;
               duty     <= new_duty;
            end
         end else begin
            if(count == period) begin
               count <= 32'd0;
               out   <= !out;
               if(!sen) begin
                  period   <= new_period;
                  duty     <= new_duty;
               end
            end else begin
               if(count == duty) begin
                  out <= !out;
               end
               count <= count + 1;
            end
         end
      end
   end
endmodule
