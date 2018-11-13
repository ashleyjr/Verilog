`timescale 1ns/1ps
module sequential_multiplier_test(
	input				i_clk,
	input				i_nrst,
	input				i_rx,	
	output	      o_tx
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
   // MUL
   parameter   DATA_IN_WIDTH  = 32;
   parameter   DATA_OUT_WIDTH = 64;

   reg   [DATA_IN_WIDTH-1:0]  mul_a;
   reg   [DATA_IN_WIDTH-1:0]  mul_b;
   wire  [DATA_OUT_WIDTH-1:0] mul_c;
   wire                       mul_valid;
   wire                       mul_accept;
   
   sequential_multiplier #(
      .DATA_WIDTH_A  (DATA_IN_WIDTH ),
      .DATA_WIDTH_B  (DATA_IN_WIDTH )
   ) sequential_multiplier (
      .i_clk         (pll_clk       ),
      .i_nrst        (i_nrst        ),
      .i_a           (mul_a         ),
      .i_b           (mul_b         ),
      .o_c           (mul_c         ),
      .i_valid       (mul_valid     ),
      .o_accept      (mul_accept    )
	);
   ///////////////////////////////////////////////////
   // UART to MUL 
   parameter   SM_LOADING  = 1'b0,
               SM_MULTIPLY = 1'b1;
   
   reg   [DATA_OUT_WIDTH-1:0] c_data;
   reg                        state;

   assign mul_valid = (state == SM_MULTIPLY);

	always@(posedge pll_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         uart_transmit  <= 1'b0; 
         c_data         <= 'd0;
	      state          <= SM_LOADING;	
		end else begin
		   uart_transmit <= 1'b0;
         case(state)
            SM_LOADING:    if(uart_recieved)
                              case(uart_data_rx[3:0])
                                 4'h0: mul_a    <= {mul_a[31-4:0], uart_data_rx[7:4]}; 
                                 4'h1: mul_b    <= {mul_b[31-4:0], uart_data_rx[7:4]}; 
                                 4'h2: begin
                                          c_data         <= c_data >> 8;
                                          uart_transmit  <= 1'b1;
                                       end 
                                 4'h3: state    <= SM_MULTIPLY;
                              endcase
            SM_MULTIPLY:   if(mul_accept) begin
                              state    <= SM_LOADING;
                              c_data   <= mul_c;
                           end
         endcase
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
      .i_data_tx     (c_data[8-1:0]       ),
      .i_rx          (uart_rx_sync        ),
      .o_busy_rx     (                    ),
      .o_busy_tx     (                    ),
      .o_recieved    (uart_recieved       ),
      .o_data_rx     (uart_data_rx        ),
      .o_tx          (o_tx                )
   );
   ///////////////////////////////////////////////////

  
endmodule
