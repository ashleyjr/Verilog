module parity_bit(
	input	            clk,
	input	            nRst,
   input             start,
   input [WIDTH-1:0] data,
   input             parity,
   output   reg      finished,
   output   reg      error
);

   parameter WIDTH = 32;
   parameter WIDTH_INDEX =  $clog2(WIDTH)-1;

   reg [WIDTH_INDEX:0] i;
   wire  done;

   assign done = (i == (WIDTH-1)) ? 1'b1 : 1'b0;

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
		   finished    <= 1'b1;
         error       <= 1'b0;
         i           <= 0;
      end else begin
         casex({start,finished,done})
            3'b110:   finished <= 1'b0;
            3'b1x0,
            3'bx00:   begin
                        i <= i + 1;
                        error <= data[i] ^ ~error;
                     end
            3'b0x1:  begin
                        error <= (error == parity) ? 1'b1 : 1'b0;
                        finished <= 1'b1;
                        i = 0;
                     end
         endcase
      end
	end
endmodule
