///////////////////////////////////////////////////////////
// ram_uart.v
// Access memory through a uart
//
// Baudrate = 460800
//
//
///////////////////////////////////////////////////////////

`timescale 1ns/1ps
module ram_uart(
	input    wire  i_clk,
	input    wire  i_nrst,
	input	   wire  i_rx,
	output	wire	o_tx,
   output   wire	led4,
	output   wire	led3,
	output   wire	led2,
	output   wire	led1,
	output   wire	led0
);

   // CLK_MHZ = 81
   // BAUDRATE = 921600
   parameter   SAMPLE   = 88;   // SAMPLE = CLK_HZ / BAUDRATE

   wire        rx_resync;
   reg   [6:0] addr;
   reg         re1,re2;
   wire  [8:0] laddr;
   wire        we;
   wire        re;
   wire        rx_2_ram_valid;
   wire  [7:0] rx_2_ram_data;
   wire  [7:0] ram_2_tx_data;
   wire        clk;

   assign   laddr    = {1'b0, addr};
   assign   we       = rx_2_ram_valid  & rx_2_ram_data[7];
   assign   re       = rx_2_ram_valid  & ~rx_2_ram_data[7];
   assign   {  led4,
               led3,
               led2,
               led1,
               led0} = addr[4:0];

   always@(posedge clk or negedge i_nrst) begin
      if(!i_nrst) begin
         re1   <= 1'b0;
         re2   <= 1'b0;
         addr  <= 7'd0; 
      end else begin
         if(rx_2_ram_valid) begin
            addr <= rx_2_ram_data[6:0];
         end 
         re1   <= re;
         re2   <= re1;
      end
   end

   ram ram(
      .i_nrst     (i_nrst                    ),
      .i_wclk     (clk                     ),
      .i_waddr    (laddr                     ),
      .i_we       (we                        ),
      .i_wdata    ({1'b0,rx_2_ram_data[6:0]} ),
      .i_rclk     (clk                     ),
      .i_raddr    (laddr                     ),
      .i_re       (re1                        ),
      .o_rdata    (ram_2_tx_data             )
	);

   resync_3 resync_3(
      .i_clk      (clk                     ),
      .i_nrst     (i_nrst                    ),
      .i_rst_d    (1'b1                      ),
      .i_d        (i_rx                      ),
      .o_q        (rx_resync                 )
	);

   uart_rx #(
      .SAMPLE     (SAMPLE                    )   
   ) uart_rx (
      .i_clk      (clk                     ),
      .i_nrst     (i_nrst                    ),
      .o_data     (rx_2_ram_data             ),
      .i_rx       (rx_resync                 ),
      .o_valid    (rx_2_ram_valid            ),
      .i_accept   (1'b1                      )
	);

   uart_tx #(
      .SAMPLE     (SAMPLE                    )
   ) uart_tx (
	   .i_clk      (clk                     ),
      .i_nrst     (i_nrst                    ),
      .i_data     ({1'b0,ram_2_tx_data[6:0]} ),
      .o_tx       (o_tx                      ),
      .i_valid    (re2                        ),
      .o_accept   (                          )
   );

	pll #(
      .p_divr     (4'd0    ),
      .p_divf     (7'd53   ),
      .p_divq     (3'd3    )
   ) pll(
	   .i_clk	   (i_clk   ),
	   .i_nrst	   (i_nrst  ),
	   .i_bypass   (1'b0    ),
      .o_clk      (clk     ),
      .o_lock     (        )	
	);

endmodule
