module clk_divider(
	input	            clk,
	input             nRst,
   input             update,
   input    [31:0]   div,
   output   reg      div_clk

);

   reg [31:0]  top;
   reg [31:0]  count;

   wire        hit;

   assign hit = (count == div) ? 1'b1 : 1'b0;

   always@(posedge clk or negedge nRst) begin 
      casex({nRst,update,hit})
         3'b0xx:  begin
                     top      <= 32'd0;
                     count    <= 32'd0;
                     div_clk  <= 1'b0;        
                  end
         3'b11x:  begin
                     top      <= div;
                     count    <= 32'd0;
                  end
         3'b100:  begin
                     count    <= count + 1'b1;
                  end
         3'b101:  begin
                     count    <= 32'd0;
                     div_clk  <= ~div_clk;
                  end
      endcase
   end



endmodule
