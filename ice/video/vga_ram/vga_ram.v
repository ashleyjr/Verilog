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
   parameter   H_WIDTH  = 11;

   // PLL
   wire                 pll_clk;

   // UART
   wire                 rx_s;
   wire                 recieved;
   reg                  p0_recieved;
   reg                  p1_recieved;
   reg                  p2_recieved;
   wire  [7:0]          data_rx;

   // VGA
   wire  [V_WIDTH-1:0]  v;
   wire  [H_WIDTH-1:0]  h;
   wire                 valid;
   wire  [5:0]          rgb; 

   // RAM
   wire  [15:0]         we;
   wire  [1:0]          w;
   reg   [7:0]          wdata;
   wire                 waddr_upd;
   reg   [15:0]         waddr;
   wire  [15:0]         waddr_next;

   wire  [1:0]          rdata;
   wire  [1:0]          rdata_mux [15:0];
   wire  [15:0]         raddr;
   wire  [15:0]         re;

   ///////////////////////////////////////////////////
   // PLL out is 76.5 MHz
   ice_pll #(
      .p_divr     (4'd0             ),
      .p_divf     (7'd50            ),
      .p_divq     (3'd3             )
   
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
      .i_clk   (i_clk   ),
      .i_nrst  (i_nrst  ),
      .i_rst_d (1'b1    ),
      .i_d     (i_rx    ),
      .o_q     (rx_s    )
	);

   uart_autobaud uart_autobaud(
      .i_clk         (i_clk      ),
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

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       wdata <= 'd0;
		else 
         if(recieved) 
            wdata <= data_rx;
         else if(waddr_upd)
            wdata <= wdata >> 2;
	end

   assign waddr_upd  = p0_recieved|p1_recieved|p2_recieved;
   assign waddr_next = (data_rx[7]) ? (waddr + 'd1) : 'd0;

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)          waddr <= 'd0;
		else if(waddr_upd)   waddr <= waddr_next;
	end

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         p0_recieved <= 'd0;
         p1_recieved <= 'd0;
         p2_recieved <= 'd0;
      end else begin
         p0_recieved <= recieved;
         p1_recieved <= p0_recieved;
         p2_recieved <= p1_recieved;
      end	
	end

   ///////////////////////////////////////////////////
   // VGA
   
   assign rgb =   (w == 2'b00) ? 6'b000000 :
                  (w == 2'b01) ? 6'b000001 :
                  (w == 2'b10) ? 6'b000010 :
                                 6'b000011 ; 
   
   vga #(
      .R_WIDTH    (2                ),
      .G_WIDTH    (2                ),
      .B_WIDTH    (2                )
   ) vga (
      .i_clk      (pll_clk          ), 
      .i_nrst     (i_nrst           ),      
      .o_v_next   (v                ),
      .o_h_next   (h                ),
      .i_rgb      (rgb              ),
      .i_valid    (valid            ),
      .o_hs       (o_hs             ),
      .o_vs       (o_vs             ),
      .o_rgb      ({o_r, o_g, o_b}  )
   );

   ///////////////////////////////////////////////////
   // RAMS

   assign we            = waddr_upd << waddr[15:11]; 
   assign w             = wdata[1:0];

   assign raddr         = (800*v) + h; 

   assign rdata_index   = raddr[15:11];
   assign rdata         = rdata_mux[rdata_index];

   genvar i;
   generate
      for(i=0;i<16;i=i+1) begin 
         ice_ram_2048x2b  ram (
            .i_nrst     (i_nrst        ),
            .i_wclk     (i_clk         ),
            .i_waddr    (waddr[10:0]   ),
            .i_we       (we[i]         ),
            .i_wdata    (w             ),
            .i_rclk     (i_clk         ),
            .i_raddr    (raddr[10:0]   ),
            .i_re       (1'b1          ),
            .o_rdata    (rdata_mux[i]  )
         );
      end
   endgenerate


endmodule

