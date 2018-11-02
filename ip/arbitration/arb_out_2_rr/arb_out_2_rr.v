`timescale 1ns/1ps
module arb_out_2_rr(
	input				         i_clk,
	input				         i_nrst,
	input				         i_req0,
   input                   i_req1,	
   input    [p_width-1:0]  i_data,
   input                   i_acc,
	output	               o_acc0,
	output	               o_acc1,
   output                  o_req, 
   output   [p_width-1:0]  o_data
);

   parameter p_width = 1;

   // The winner of the contest will be the loser next time 
   wire     contest,
            winner;
   reg      rr;

   assign o_data     = i_data;
   assign contest    = i_req0 & i_req1;
   assign winner     = (contest) ? rr : i_req1;  
   assign o_req      = i_req0 | i_req1;
   assign o_acc0     = ~winner & i_acc;
   assign o_acc1     = winner & i_acc;
   	
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         rr <= 1'b0; 
		end else begin
         if(i_acc)
            rr <= ~winner;
		end
	end
endmodule

