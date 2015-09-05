module up_stack_pointer(
	input	   wire        clk,
	input	   wire        nRst,
   input    wire        add,
   input    wire        sub,
   output   reg   [7:0] sp
);

   parameter   UP    = 2'b10,
               DOWN  = 2'b01;

   always@(posedge clk or negedge nRst) begin
      if(!nRst)
         sp <= 8'hFF;
      else begin
         case({add,sub}) 
            UP:   sp <= sp + 1;
            DOWN: sp <= sp -1 ;
         endcase
      end
   end

endmodule
