`timescale 1ns/1ps
module fm_tx(
	input	   wire  i_clk,
	input    wire  i_nrst,
	output   wire  o_fm
);

   parameter   p_top = 32'd2238080614; // (100.05e6 / 192e6) * 2^32 
   parameter   p_bot = 32'd2235843652; // (99.95e6 / 192e6) * 2^32 
   parameter   p_range = p_top - p_bot;

   reg [31:0]  phase_acc, 
               add;

   assign o_fm = phase_acc[31];

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
		   phase_acc   <= 'd0;
		   add         <= p_bot;
      end else begin
         phase_acc   <= phase_acc + add; 
         if(add == p_top) begin
            add <= p_bot;
         end else begin
            add <= add + 'd1;
         end
		end
	end
endmodule
