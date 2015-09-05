module up_program_counter(
	input	               clk,
	input	               nRst,
   input    wire  [1:0] op,
   input    wire  [7:0] in,  
   output   reg   [7:0] pc
);

   parameter   NOP   = 2'b00,
               INC   = 2'b01,
               INT   = 2'b10,
               NEW   = 2'b11;

   always@(posedge clk or negedge nRst) begin
      if(!nRst)
         pc <= 8'h08;
      else begin
         case(op)
            INC:  pc <= pc + 1;  
            INT:  pc <= 8'h00;
            NEW:  pc <= in;
         endcase
      end
   end
endmodule
