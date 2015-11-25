module pwm_in(
	input	               clk,
	input 	            nRst,
   input                in,
   output reg           valid,
   output reg  [7:0]    duty
);

   reg   [31:0]   count;
   reg   [31:0]   high;
   reg   [31:0]   period;
   reg            in_0;
   reg            in_1;
  
   wire  [31:0]   test;
   wire  [23:0]   chunk;
   wire  rise;
   wire  fall;


   assign test = duty*chunk;
   assign chunk = period >> 8;
   assign rise = in_0 & ~in_1;
   assign fall = ~in_0 & in_1;
   
	always@(posedge clk or negedge nRst) begin
		in_0 <= in;
      in_1 <= in_0;      
      casex({nRst,rise,fall})
         3'b0xx:  begin
                     count <= 1'b0;
                     valid <= 1'b0;
                     duty <= 8'h00;
                  end
         3'b11x:  begin
                     count <= 1'b0;
                     period  <= count;
                     valid <= 1'b0;
                  end
         3'b1x1:  begin
                     high  <= count;
                  end
         3'b100:  begin
                     if((test<high) && (valid == 1'b0))begin
                        duty <= duty + 1'b1;
                     end else begin
                        valid <= 1'b1;
                     end 
                     count <= count + 1'b1;
                  end
      endcase
	end
endmodule
