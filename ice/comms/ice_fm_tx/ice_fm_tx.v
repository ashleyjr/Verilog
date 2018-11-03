`timescale 1ns/1ps
module ice_fm_tx(
	input	   wire  i_clk,
	input	   wire  i_nrst,
	input	   wire  i_rx,
	output   wire  o_tx,
   output   wire  o_fm
);

   wire pll_clk;

   ///////////////////////////////////////////////////
   // PLL out is 67.5 MHz
   ice_pll #(
      .p_divr     (4'd0          ),
      .p_divf     (7'd44         ),
      .p_divq     (3'd3          )
   
   )ice_pll(
	   .i_clk	   (i_clk         ),
	   .i_nrst	   (i_nrst        ),
	   .i_bypass   (1'b0          ),
      .o_clk      (pll_clk       ),
      .o_lock     (              )	
	); 
   ///////////////////////////////////////////////////
   // FM TX   
   //fm_tx #(
   //   .p_hz_sz    (27            )
   //)fm_tx(
   //   .i_clk      (pll_clk       ),
   //   .i_nrst     (i_nrst        ),
   //   .i_clk_hz   (27'd67500000  ),
   //   .i_base_hz  (27'd30000000  ),
   //   .i_shift_hz ({{11{1'b0}},ram_rdata}),
   //   .i_set      (set|set1|set2 ),
   //   .o_fm       (o_fm          )
   //);
   ///////////////////////////////////////////////////
   // FM RAM
   reg            fm_ram_req;
   wire           fm_ram_acc;
   reg   [10:0]   fm_ram_addr;
    
   always@(posedge pll_clk or negedge i_nrst) begin 
      if(!i_nrst) begin
         fm_ram_addr <= 'd0;     
         fm_ram_req  <= 1'b0;
      end else begin  
            fm_ram_addr <= fm_ram_addr + 'd1;
      
      end
   end
   ///////////////////////////////////////////////////
   // ARB - UART, FM 
   arb_in_2_rr #(
      .p_width       (11      )
   ) arb_in_2_rr(
      .i_nrst        (i_nrst  ),
      .i_clk         (pll_clk     ), 
      // RAM
      .o_data        (ram_raddr     ),
      .o_req         (ram_req       ),
      .i_acc         (ram_acc       ),
      // UART
      .i_req0        (uart_ram_read_req   ),
      .i_data0       (uart_ram_addr       ),
      .o_acc0        (uart_ram_read_acc   ),
      // FM
      .i_req1        (1'b1                ),
      .i_data1       (fm_ram_addr         ),
      .o_acc1        (fm_ram_acc          )
   );
   ///////////////////////////////////////////////////
   // RAM
   wire  [10:0]   ram_raddr;
   wire  [15:0]   ram_rdata;
   wire  [15:0]   ram_wdata;
   wire           ram_req;
   reg            ram_acc; 
   always@(posedge pll_clk or negedge i_nrst) begin 
      if(!i_nrst)
         ram_acc <= 1'b0;
      else
         ram_acc <= ram_req;
   end
   ice_ram_2048x16b ice_ram_2048x16b(
      .i_nrst        (i_nrst                 ),
      .i_wclk        (pll_clk                ),
      .i_waddr       (uart_ram_addr          ),
      .i_we          (uart_ram_write_req     ),
      .i_wdata       (uart_ram_data          ),
      .i_rclk        (pll_clk                ),
      .i_raddr       (ram_raddr              ),
      .i_re          (ram_req                ),
      .o_rdata       (ram_rdata              )
   );  
   ///////////////////////////////////////////////////
   // UART RAM      
   reg   [10:0]   uart_ram_addr; 
   reg   [15:0]   uart_ram_data; 
   reg            uart_ram_write_req;
   reg            uart_ram_read_req_latch;
   wire           uart_ram_read_req;
   wire           uart_ram_read_acc;
   assign         uart_ram_read_req = uart_ram_read_req_latch & ~uart_ram_read_acc;
   always@(posedge pll_clk or negedge i_nrst)
      if(!i_nrst) begin
         uart_ram_data           <= 'd0; 
         uart_ram_addr           <= 'd0;
         uart_transmit           <= 1'b0;
         uart_ram_write_req      <= 1'b0;
         uart_ram_read_req_latch <= 1'b0;
      end else begin 
         uart_ram_write_req   <= 1'b0;
         uart_transmit        <= 1'b0;
         if(uart_recieved)
            case(uart_data_rx[3:0])
               4'h0: uart_ram_data[3:0]         <= uart_data_rx[7:4]; 
               4'h1: uart_ram_data[7:4]         <= uart_data_rx[7:4];
               4'h2: uart_ram_data[11:8]        <= uart_data_rx[7:4];
               4'h3: uart_ram_data[15:12]       <= uart_data_rx[7:4];
               4'h4: uart_ram_addr[3:0]         <= uart_data_rx[7:4];
               4'h5: uart_ram_addr[7:4]         <= uart_data_rx[7:4];
               4'h6: uart_ram_addr[10:8]        <= uart_data_rx[7:4];
               4'h7: uart_ram_read_req_latch    <= 1'b1;  
               4'h8: uart_ram_write_req         <= 1'b1;
               4'hE: begin
                        uart_data_tx            <= uart_ram_data[7:0];
                        uart_transmit           <= 1'b1;
                     end
               4'hF: begin
                        uart_data_tx            <= uart_ram_data[15:8];
                        uart_transmit           <= 1'b1;
                     end
            endcase
         if(uart_ram_read_acc) begin
            uart_ram_data           <= ram_rdata;
            uart_ram_read_req_latch <= 1'b0;
         end
      end 
   ///////////////////////////////////////////////////
   // UART
   wire        uart_rx_sync;
   reg   [7:0] uart_data_tx;
   wire  [7:0] uart_data_rx;
   reg         uart_transmit;
   wire        uart_recieved;
   resync_3 resync_3(
      .i_clk         (pll_clk             ),
      .i_nrst        (i_nrst              ),
      .i_rst_d       (1'b1                ),
      .i_d           (i_rx                ),
      .o_q           (uart_rx_sync        )
	);
   uart_autobaud uart_autobaud(
      .i_clk         (pll_clk             ),
      .i_nrst        (i_nrst              ),
      .i_transmit    (uart_transmit       ),
      .i_data_tx     (uart_data_tx        ),
      .i_rx          (uart_rx_sync        ),
      .o_busy_rx     (                    ),
      .o_busy_tx     (                    ),
      .o_recieved    (uart_recieved       ),
      .o_data_rx     (uart_data_rx        ),
      .o_tx          (o_tx                )
   );
   ///////////////////////////////////////////////////


endmodule
