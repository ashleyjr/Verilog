`timescale 1ns/1ps
module vga_ram(
	input	   wire           i_clk,
   input    wire           i_nrst,	
	output	wire	         o_hs,
	output	wire	         o_vs,
	output	wire  [1:0]    o_r,
	output	wire	[1:0]    o_g,
	output	wire	[1:0]    o_b,
   input    wire           i_rx
);

   parameter   V_WIDTH  = 10;
   parameter   H_WIDTH  = 10;

   // PLL
   wire                 pll_clk;

   // UART
   wire  [7:0]          data_rx; 

   // VGA
   wire                 h_black; 
   wire                 v_black; 
   wire  [V_WIDTH-1:0]  v;
   wire  [H_WIDTH-1:0]  h; 
   wire  [5:0]          rgb; 

   // RAM
   wire  [15:0]         we;  
   wire                 waddr_upd;
   reg   [14:0]         waddr;
   wire  [14:0]         waddr_next;

   wire  [1:0]          rdata;
   wire  [4:0]          rdata_index_0;
   wire  [4:0]          rdata_index_1;
   wire  [31:0]         rdata_mux; 
   wire  [14:0]         raddr;
   reg   [14:0]         p0_raddr; 

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
   // UART
   resync_3 resync_3(
      .i_clk   (pll_clk ),
      .i_nrst  (i_nrst  ),
      .i_rst_d (1'b1    ),
      .i_d     (i_rx    ),
      .o_q     (rx_s    )
	);

   uart_autobaud uart_autobaud(
      .i_clk         (pll_clk    ),
      .i_nrst        (i_nrst     ),
      .i_transmit    (1'b0       ),
      .i_data_tx     (8'h00      ),
      .i_rx          (rx_s       ),
      .o_busy_rx     (           ),
      .o_busy_tx     (           ),
      .o_recieved    (recieved   ),
      .o_data_rx     (data_rx    ),
      .o_tx          (           )
   );

   assign waddr_next = (data_rx[7]) ? (waddr + 'd1) : 'd0;

   always@(posedge pll_clk or negedge i_nrst) begin
		if(!i_nrst)       waddr <= 'd0;
		else if(recieved) waddr <= waddr_next;
	end

   ///////////////////////////////////////////////////
   // VGA
   
   assign rgb =   (h_black | v_black | (rdata == 2'b00)) ? 6'b000000 :   // Black
                  (rdata == 2'b01) ? 6'b110000 :   // Red
                  (rdata == 2'b10) ? 6'b111100 :   // Yellow
                                     6'b001100 ;   // Green
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

   assign we            = recieved << waddr[14:11]; 
 
   assign h_black       = h >= 180; 
   assign v_black       = v >= 180; 
   assign raddr         = (v*180)+h; 
   
   assign rdata_index_0 = {p0_raddr[14:11],1'b0};
   assign rdata_index_1 = {p0_raddr[14:11],1'b1};

   assign rdata[0]      = rdata_mux[rdata_index_0];
   assign rdata[1]      = rdata_mux[rdata_index_1];

   always@(posedge pll_clk or negedge i_nrst) begin
		if(!i_nrst) p0_raddr <= 'd0;
		else        p0_raddr <= raddr;
	end
   
   genvar i;
   generate
      for(i=0;i<16;i=i+1) begin 
         ice_ram_2048x2b  ram (
            .i_nrst     (i_nrst                 ),
            .i_wclk     (pll_clk                ),
            .i_waddr    (waddr[10:0]            ),
            .i_we       (we[i]                  ),
            .i_wdata    (data_rx[1:0]           ),
            .i_rclk     (pll_clk                ),
            .i_raddr    (raddr[10:0]            ),
            .i_re       (1'b1                   ),
            .o_rdata    ({ rdata_mux[(i*2)+1],
                           rdata_mux[(i*2)]}    ) 
         );
      end
   endgenerate


endmodule

