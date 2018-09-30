module clk_divider(
	input	            clk,
	input             nRst,
   input             update,
   input    [31:0]   div,
   output            div_clk
);

   reg [31:0]  top;
   reg [30:0]  count;
   reg         div_reg;

   wire        hit;
   wire [30:0] top_2;

   assign top_2      =  top >> 1;                                          // Divide input by 2

   assign hit        =  (count == (top_2 - div_reg))     ?  1'b1 : 1'b0;   // Top of odd/even
 
   assign div_clk    =  ((top == 32'd0 ) && !update)     ?  1'b0   :       // Can't divide by zero
                        ((top == 32'd1 ) && !update)     ?  clk    :       // Pass through clk on 1
                                                            div_reg;       // All other numbers

   always@(posedge clk or negedge nRst) begin 
      casex({nRst,update,hit,div_reg})
         4'b0xxx:    begin
                        top      <= 32'd1;               // On reset                               
                        count    <= 32'd0;
                        div_reg  <= 1'b0;      
                     end
         4'b11xx:    begin
                        top      <= div;                 // Update the divider
                        count    <= 32'd0;
                        div_reg  <= 1'b0;
                     end
         4'b100x:    begin
                        count    <= count + 1'b1;        //  Normal operation
                     end
         4'b1010:    begin
                        count    <= 32'd0;               // End of low 
                        div_reg  <= 1'b1;
                     end
         4'b1011:    begin
                        count    <= 32'd0;               // End of high
                        div_reg  <= 1'b0;
                     end
      endcase
   end



endmodule
