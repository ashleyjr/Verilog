`timescale 1ns/1ps
module vga(
	input    wire                       i_clk,
	input	   wire                       i_nrst,
   // Driven by fpga	
	output   wire  [VER_C_WIDTH-1:0]    o_v_next,
   output   wire  [HOR_C_WIDTH-1:0]    o_h_next,
   input    wire  [RGB_WIDTH-1:0]      i_rgb,
	input    wire                       i_valid,
   // Drive VGA
   output	wire	                     o_hs,
	output	wire                       o_vs,
	output	wire  [RGB_WIDTH-1:0]      o_rgb
);
   // VGA pixel clock is half of i_clk
   // http://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml
   // Default is 800x600, 56Hz
   parameter   HOR         = 800;
   parameter   HOR_FP      = 32;
   parameter   HOR_SP      = 128;
   parameter   HOR_BP      = 128;
   parameter   HOR_C       = HOR + HOR_FP + HOR_SP + HOR_BP; 
   parameter   HOR_C_WIDTH = 11; //$clog2(HOR_C);

   parameter   VER         = 600;
   parameter   VER_FP      = 1;
   parameter   VER_SP      = 4;
   parameter   VER_BP      = 14; 
   parameter   VER_C       = VER + VER_FP + VER_SP + VER_BP; 
   parameter   VER_C_WIDTH = 10;//$clog2(VER_C);

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
   wire                       h_wrap;
   reg   [$clog2(VER_C)-1:0]  v;
   wire  [$clog2(VER_C)-1:0]  v_next;
   wire                       v_wrap;
   wire                       v_upd;
   reg   [RGB_WIDTH-1:0]      pre_o_rgb;
   reg   [RGB_WIDTH-1:0]      rgb;
   reg                        rgb_upd;
   wire                       rgb_mux;

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

   assign rgb_mux = ((o_h_next == 'd0) | (o_v_next == 'd0));
   assign o_rgb   = (rgb_mux) ? 'd0 : rgb;

   // Horz
   assign h_wrap     = (h == (HOR_C-1));
   assign h_next     = (h_wrap) ? 'd0 : (h + 'd1); 
   assign o_h_next   = (h_next >= HOR) ? 'd0 : h_next; 

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       h  <= 'd0;
      else if(rgb_upd)  h  <= h_next;
	end

   // Vert
   
   assign v_upd      = (h_next == 'd0) & rgb_upd;
   assign v_wrap     = (v == (VER_C-1)); 
   assign v_next     = (v_wrap) ? 'd0 : (v + 'd1); 
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
