module pwm_in(
	input	               clk,
	input 	            nRst,
   input                in,
   output               valid,
   output reg  [7:0]    duty
);

   reg   [31:0]   count;
   reg            in_0;
   reg            in_1;
  
   wire  rise;
   wire  fall;

   assign rise = in_0 & ~in_1;
   assign fall = ~in_0 & in_1;

	always@(posedge clk or negedge nRst) begin
		in_0 <= in;
      in_1 <= in_0;      
      
      casex({nRst,rise,fall})
         3'b0xx:  begin
                     count <= 1'b0;
                  end
         3'b11x:  begin
                     count <= 1'b0;
                  end
         3'b1x1:  begin
                     count <= 1'b0;
                  end
         3'b100:  begin
                     count <= count + 1'b1;
                  end
      endcase
	end
endmodule
