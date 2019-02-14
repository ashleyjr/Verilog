`timescale 1ns/1ps
module vga_testgen(	
   input    wire                    i_clk,
   input    wire                    i_nrst,
   output   reg                     o_valid,
   output   reg   [RGB_WIDTH-1:0]   o_rgb         	
);

   parameter   R_WIDTH     = 5;
   parameter   G_WIDTH     = 5;
   parameter   B_WIDTH     = 5;
   parameter   RGB_WIDTH   = R_WIDTH + G_WIDTH + B_WIDTH; 

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) o_rgb    <= 'd0;
      else        o_rgb    <= 'd0; 
	end
 
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) o_valid  <= 'd0;
      else        o_valid  <= 'd1; 
	end
     

endmodule
