module up_instruction_register(
	input	   wire        clk,
	input 	wire        nRst,
   input    wire        we,
   input    wire        sel,
   input    wire  [7:0] in,
   output   reg   [3:0] ir
);

   parameter   TOP      = 1'b1,
               BOTTOM   = 1'b0;

   always@(posedge clk or negedge nRst) begin
      if(!nRst)
         ir <= 0;
      else begin
         case({we,sel})
            {1'b1,TOP}:    ir <= in[7:4];
            {1'b1,BOTTOM}: ir <= in[3:0];
         endcase
      end
   end
endmodule
