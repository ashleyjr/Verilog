`timescale 1ns/1ps
module clk_div8(
	input				clk,
	input				nRst,
	input	   [7:0] div,
	input          set,
   output	      clk_div
);
   reg   [255:0]  count;
   reg   [7:0]    div_sel;    

   assign clk_div = count[div_sel];

	always@(posedge clk or negedge nRst) begin
      if(!nRst) begin 
         count    <= 256'd0;
         div_sel  <= 8'h00;
      end else begin
         count <= count + 256'h01; 
	      if(set) begin
            div_sel <= div;
         end
      end
   end
endmodule
