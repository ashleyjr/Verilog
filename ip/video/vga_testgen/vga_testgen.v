`timescale 1ns/1ps
module vga_testgen(	
   input    wire                    i_clk,
   input    wire                    i_nrst,
   input    wire  [V_WIDTH-1:0]     i_v,
   input    wire  [H_WIDTH-1:0]     i_h,
   output   reg                     o_valid,
   output   reg   [RGB_WIDTH-1:0]   o_rgb         	
);

   parameter   V_WIDTH     = 10;
   parameter   H_WIDTH     = 8;
   parameter   R_WIDTH     = 2;
   parameter   G_WIDTH     = 2;
   parameter   B_WIDTH     = 2;
   parameter   RGB_WIDTH   = R_WIDTH + G_WIDTH + B_WIDTH; 

   // Input
   reg   [V_WIDTH-1:0]  v;
   reg   [H_WIDTH-1:0]  h;

   // Compute
   wire                 check;
   wire  [R_WIDTH-1:0]  r_next;
   wire  [G_WIDTH-1:0]  g_next;
   wire  [B_WIDTH-1:0]  b_next;

   //////////////////////////////////////////////////////////
   // Input
   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         v <= 'd0;
         h <= 'd0;      
      end else begin
         v <= i_v;
         h <= i_h;
      end 
	end
  
   ////////////////////////////////////////////////////////////
   // Compute next
   assign check = |(v[6] + h[6]);

   assign r_next = (check) ? 2'b00 : 2'b11;
   assign g_next = r_next;
   assign b_next = r_next;

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) o_rgb    <= 'd0;
      else        o_rgb    <= {r_next, g_next, b_next}; 
	end
 
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) o_valid  <= 'd0;
      else        o_valid  <= 'd1; 
	end
     

endmodule
