`timescale 1ns/1ps
module vga_mandelbrot(
	input	   wire           i_clk,
   input    wire           i_nrst,	
	output	wire	         o_hs,
	output	wire	         o_vs,
	output	wire  [1:0]    o_r,
	output	wire	[1:0]    o_g,
	output	wire	[1:0]    o_b
);
   parameter   SIZE     = 176;
   parameter   V_WIDTH  = 10;
   parameter   H_WIDTH  = 10;

   // PLL
   wire                 pll_clk;
   
   // VGA
   wire                 h_black; 
   wire                 v_black; 
   wire  [V_WIDTH-1:0]  v;
   wire  [H_WIDTH-1:0]  h; 
   wire  [5:0]          rgb; 

   // RAM
   wire  [15:0]         we;   
   wire  [14:0]         waddr;
   wire  [1:0]          wdata;
   wire  [1:0]          rdata; 
   wire  [31:0]         rdata_mux; 
   wire  [14:0]         raddr; 
   reg   [3:0]          rdata_index;
   wire  [4:0]          rdata_index_0;
   wire  [4:0]          rdata_index_1;
  
   // Generate
   wire  [7:0]          iter;
   wire                 done;
   reg   [7:0]          a;
   reg   [7:0]          b;
   wire  [7:0]          a_next;
   wire  [7:0]          b_next;
   wire                 a_wrap;
   wire  signed [15:0]   re;
   wire  signed [15:0]   im;

   ///////////////////////////////////////////////////
   // PLL out is 48 MHz
   ice_pll #(
      .p_divr     (4'd0             ),
      .p_divf     (7'd63            ),
      .p_divq     (3'd4             )
   
   )ice_pll(
	   .i_clk	   (i_clk            ),
	   .i_nrst	   (i_nrst           ),
	   .i_bypass   (1'b0             ),
      .o_clk      (pll_clk          ),
      .o_lock     (                 )	
	);

   ///////////////////////////////////////////////////
   // VGA
   
   assign h_black = h >= SIZE; 
   assign v_black = v >= SIZE;  
   assign rgb     =  (h_black | v_black)  ?  6'b000000 : // Black
                     (rdata == 2'b00)     ?  6'b000011 : // Blue
                     (rdata == 2'b01)     ?  6'b111100 : // Yellow
                     (rdata == 2'b10)     ?  6'b110000 : // Red
                                             6'b111111 ; // White
   vga #(   // 640x480, 25.175Hz
      .HOR           (640              ),
      .HOR_FP        (16               ),
      .HOR_SP        (96               ),
      .HOR_BP        (48               ),
      .HOR_C_WIDTH   (10               ),
      .VER           (480              ),
      .VER_FP        (11               ),
      .VER_SP        (2                ),
      .VER_BP        (31               ),
      .VER_C_WIDTH   (10               ), 
      .R_WIDTH       (2                ),
      .G_WIDTH       (2                ),
      .B_WIDTH       (2                )
   ) vga (
      .i_clk         (pll_clk          ), 
      .i_nrst        (i_nrst           ),      
      .o_v_next      (v                ),
      .o_h_next      (h                ),
      .i_rgb         (rgb              ),
      .i_valid       (1'b1             ),
      .o_hs          (o_hs             ),
      .o_vs          (o_vs             ),
      .o_rgb         ({o_r, o_g, o_b}  )
   );

   ///////////////////////////////////////////////////
   // RAMS

   assign we       = 1'b1 << waddr[14:11];  
   assign raddr    = (v << 7) + (v << 5) + (v << 4) + h;  
  
   assign rdata_index_0 = {rdata_index,1'b0};
   assign rdata_index_1 = {rdata_index,1'b1};
   
   assign rdata[0] = rdata_mux[rdata_index_0];
   assign rdata[1] = rdata_mux[rdata_index_1];

   always@(posedge pll_clk or negedge i_nrst) begin
		if(!i_nrst) rdata_index <= 'd0;
		else        rdata_index <= raddr[14:11];
	end
   
   genvar i;
   generate
      for(i=0;i<16;i=i+1) begin 
         ice_ram_2048x2b  ram (
            .i_nrst     (i_nrst                 ),
            .i_wclk     (pll_clk                ),
            .i_waddr    (waddr[10:0]            ),
            .i_we       (we[i]                  ),
            .i_wdata    (wdata                  ),
            .i_rclk     (pll_clk                ),
            .i_raddr    (raddr[10:0]            ),
            .i_re       (1'b1                   ),
            .o_rdata    ({ rdata_mux[(i*2)+1],
                           rdata_mux[(i*2)]}    ) 
         );
      end
   endgenerate

   ///////////////////////////////////////////////////
   // Generate
  
   assign we = done << waddr[14:11];   
  
   assign a_wrap = (a == SIZE-1) & done;
   assign a_next = (a_wrap) ? 'd0 : a + 'd1;

   always@(posedge pll_clk or negedge i_nrst) begin
		if(!i_nrst)    a <= 'd0;
		else if(done)  a <= a_next;
	end

   assign b_next = (b == SIZE-1) ? 'd0 : b + 'd1;
   
   always@(posedge pll_clk or negedge i_nrst) begin
		if(!i_nrst)       b <= 'd0;
		else if(a_wrap)   b <= b_next;
	end

   assign waddr = (b << 7) + (b << 5) + (b << 4) + a;  
   assign we    = done << waddr[14:11];   
 

   assign wdata = (iter < 8)   ?  2'b00:
                  (iter < 16)  ?  2'b01:
                  (iter < 32)  ?  2'b10:
                                  2'b11; 

   assign re = -(2 ** 15) + (a << 8); 
   assign im = (2 ** 15) - (b << 8);

   mandelbrot #(              
      .WIDTH      (16            ),
      .ITERS      (256           )
   ) mandelbrot (
      .i_clk      (pll_clk       ),
      .i_nrst     (i_nrst        ),
      .i_c_re     (re  ),
      .i_c_im     (im  ),
      .i_valid    (1'b1          ),
      .o_iter     (iter          ),
      .o_bounded  (              ),
      .o_done     (done          )
   );
   
endmodule
