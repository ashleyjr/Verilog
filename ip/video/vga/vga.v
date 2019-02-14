`timescale 1ns/1ps
module vga(
	input    wire                       i_clk,
	input	   wire                       i_nrst,
   // Driven by fpga	
	output   wire  [$clog2(VER_C)-1:0]  o_v_next,
   output   wire  [$clog2(HOR_C)-1:0]  o_h_next,
   input    wire  [RGB_WIDTH-1:0]      i_rgb,
	input    wire                       i_valid,
   // Drive VGA
   output	wire	                     o_hs,
	output	wire                       o_vs,
	output	wire  [RGB_WIDTH-1:0]      o_rgb
);
   // VGA pixel clock is half of i_clk
   // http://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml
   // Default is 640x480, 85Hz
   parameter   HOR         = 640;
   parameter   HOR_FP      = 32;
   parameter   HOR_SP      = 48;
   parameter   HOR_BP      = 112;
   parameter   HOR_C       = HOR + HOR_FP + HOR_SP + HOR_BP; 
   
   parameter   VER         = 480;
   parameter   VER_FP      = 1;
   parameter   VER_SP      = 3;
   parameter   VER_BP      = 25; 
   parameter   VER_C       = VER + VER_FP + VER_SP + VER_BP; 
   
   parameter   R_WIDTH     = 5;
   parameter   G_WIDTH     = 5;
   parameter   B_WIDTH     = 5;
   parameter   RGB_WIDTH   = R_WIDTH + G_WIDTH + B_WIDTH;

   reg                        hs;
   wire                       hs_start;
   wire                       hs_end;
   wire                       hs_upd;
   
   reg                        vs;
   wire                       vs_start;
   wire                       vs_end;
   wire                       vs_upd;

   reg   [$clog2(HOR_C)-1:0]  h;
   wire  [$clog2(HOR_C)-1:0]  h_next;
   reg   [$clog2(VER_C)-1:0]  v;
   wire  [$clog2(VER_C)-1:0]  v_next;
   wire                       v_upd;
   reg   [RGB_WIDTH-1:0]      pre_o_rgb;
   reg   [RGB_WIDTH-1:0]      rgb;
   reg                        rgb_upd;
  
   // RGB
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) rgb_upd <= 'd0;
      else        rgb_upd <= ~rgb_upd; 
	end
     
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       rgb <= 'd0;
      else if(i_valid)  rgb <= i_rgb; 
	end
   
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       pre_o_rgb <= 'd0;
      else if(rgb_upd)  pre_o_rgb <= rgb; 
	end

   assign o_rgb = ((o_h_next == 'd0) & (o_v_next == 'd0)) ? 'd0 : rgb;

   // Horz
   assign h_next     =  (h + 'd1) % HOR_C; 
   assign o_h_next   =  (h_next >= HOR) ? 'd0 : h_next; 

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       h  <= 'd0;
      else if(rgb_upd)  h  <= h_next;
	end

   // Vert
   
   assign v_upd      = (h_next == 'd0) & rgb_upd;
   assign v_next     = (v + 'd1) % VER_C; 
   assign o_v_next   =  (v_next >= VER) ? 'd0 : v_next;
   
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)    v  <= 'd0;
      else if(v_upd) v  <= v_next; 
	end
   
   // Horz Sync
   assign o_hs       = ~hs;
   assign hs_start   = (h == (HOR + HOR_FP - 1));
   assign hs_end     = (h == (HOR + HOR_FP + HOR_SP- 1));
   assign hs_upd     = rgb_upd & (hs_start | hs_end);
   
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       hs  <= 1'b0;
      else if(hs_upd)   hs  <= o_hs; 
	end

   // Vert Sync
   assign o_vs       = ~vs;
   assign vs_start   = (v == (VER + VER_FP - 1));
   assign vs_end     = (v == (VER + VER_FP + VER_SP- 1));
   assign vs_upd     = v_upd & (vs_start | vs_end);
   
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       vs  <= 1'b0;
      else if(vs_upd)   vs  <= o_vs; 
	end


endmodule
