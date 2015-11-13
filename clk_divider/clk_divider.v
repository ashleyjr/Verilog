module clk_divider(
	input	            clk,
	input             nRst,
   input             update,
   input    [31:0]   div,
   output            div_clk
);

   reg [31:0]  top;
   reg [31:0]  count;
   reg         div_reg;

   wire        hit;

   assign hit     = (count == ((top >> 2)) )    ? 1'b1 : 1'b0;
   
   assign div_clk = (   (top     == 32'd0) &&
                        (update  == 1'b0)    )  ? clk  : div_reg;

   always@(posedge clk or negedge nRst) begin 
      casex({nRst,update,hit})
         3'b0xx:  begin
                     top      <= 32'd1;
                     count    <= 32'd0;
                     div_reg  <= 1'b0;        
                  end
         3'b11x:  begin
                     top      <= div;
                     count    <= 32'd0;
                     div_reg  <= 1'b0;
                  end
         3'b100:  begin
                     count    <= count + 1'b1;
                  end
         3'b101:  begin
                     count    <= 32'd0;
                     div_reg  <= ~div_reg;
                  end
      endcase
   end



endmodule
