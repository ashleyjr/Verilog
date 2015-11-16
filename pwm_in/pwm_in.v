module pwm_in(
	input	               clk,
	input 	            nRst,
   input                in,
   output reg             valid,
   output reg  [7:0]    duty
);

   reg   [31:0]   count;
   reg   [31:0]   high;
   reg   [31:0]   period;
   reg            in_0;
   reg            in_1;
  
   wire  [31:0]   test;
   wire  [31:0]   test_high;
   wire  [31:0]   test_duty;
   wire           rise;
   wire           fall;


   assign test       = (period*count[7:0]) >> 8;
   assign test_high  = test - high;
   assign test_duty  = high - ((period*duty) >> 8);

   assign rise = in_0 & ~in_1;
   assign fall = ~in_0 & in_1;

	always@(posedge clk or negedge nRst) begin
		in_0 <= in;
      in_1 <= in_0;      
      casex({nRst,rise,fall})
         3'b0xx:  begin
                     count <= 1'b0;
                     duty <= 8'h00;
                     valid <= 1'b0;
                  end
         3'b11x:  begin
                     count <= 32'd0;
                     valid <= 1'b0;
                     period <= count;
                  end
         3'b1x1:  begin
                     high  <= count;
                  end
         3'b100:  begin
                     count <= count + 1'b1;                                      // Count up
                     if((test < high) && (valid == 1'b0)) begin                  // Pass count to output while still below input values
                        duty <= count[7:0];
                     end else begin
                        if((test_high < test_duty) && (valid == 1'b0))  begin
                           duty <= count[7:0];
                        end
                        valid <= 1'b1;
                     end
                  end
      endcase
	end
endmodule
