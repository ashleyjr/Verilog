`timescale 1ns/1ps
module arb_in_2_rr(
	input				         i_clk,
	input				         i_nrst,
	input				         i_req0,
	input				         i_req1,
   input    [p_width-1:0]  i_data0,
   input    [p_width-1:0]  i_data1,
   input                   i_acc,
	output	               o_acc0,
	output	               o_acc1,
   output                  o_req,
   output   [p_width-1:0]  o_data
);

   parameter p_width = 1; 
   
   reg   service;
   reg   rr;
   wire  contest;
   

   assign o_req   = i_req0 | i_req1;
   assign o_acc0  = i_acc & ~rr;
   assign o_acc1  = i_acc & rr;
   
   assign contest = i_req0 & i_req1;
   assign o_data  =  (contest & service)  ? i_data1   :
                     (contest & ~service) ? i_data0   :
                     (i_req0)             ? i_data0   :
                                            i_data1   ;
  
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin  
         rr       <= 1'b0;
		   service  <= 1'b0; 
      end else begin
         if(i_req0 & i_req1) begin
            service  <= ~service;
            rr       <= service;
         end else begin
            rr <= i_req1;
         end
      end
	end
endmodule
