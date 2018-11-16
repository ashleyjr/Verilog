`timescale 1ns/1ps
module sequential_divider_test(
	input				i_clk,
	input				i_nrst,
	input				i_rx,	
	output	      o_tx
);
 
   ///////////////////////////////////////////////////
   // MUL
   parameter   DATA_WIDTH     = 32; 

   reg   [DATA_WIDTH-1:0]     div_d;
   reg   [DATA_WIDTH-1:0]     div_n;
   wire  [DATA_WIDTH-1:0]     div_q;
   wire  [DATA_WIDTH-1:0]     div_r;
   wire                       div_valid;
   wire                       div_accept;
   
   sequential_divider #(
      .DATA_WIDTH    (DATA_WIDTH    )
   ) sequential_divider (
      .i_clk         (i_clk         ),
      .i_nrst        (i_nrst        ),
      .i_d           (div_d         ),
      .i_n           (div_n         ),
      .o_q           (div_q         ),
      .o_r           (div_r         ),
      .i_valid       (div_valid     ),
      .o_accept      (div_accept    )
	);
   ///////////////////////////////////////////////////
   // UART to MUL 
   parameter   SM_LOADING  = 1'b0,
               SM_DIVIDE   = 1'b1;
   
   reg   [DATA_WIDTH-1:0]     q_data;
   reg   [DATA_WIDTH-1:0]     r_data;
   reg   [7:0]                send_data;
   reg                        state;

   assign div_valid = (state == SM_DIVIDE);

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         uart_transmit  <= 1'b0; 
         q_data         <= 'd0;
         r_data         <= 'd0;
         send_data      <= 'd0;
	      state          <= SM_LOADING;	
		end else begin
		   uart_transmit <= 1'b0;
         case(state)
            SM_LOADING:    if(uart_recieved)
                              case(uart_data_rx[3:0])
                                 4'h0: div_d    <= {div_d[31-4:0], uart_data_rx[7:4]}; 
                                 4'h1: div_n    <= {div_n[31-4:0], uart_data_rx[7:4]}; 
                                 4'h2: begin
                                          q_data         <= q_data >> 8;
                                          send_data      <= q_data[7:0];
                                          uart_transmit  <= 1'b1;
                                       end 
                                 4'h3: begin
                                          r_data         <= r_data >> 8;
                                          send_data      <= r_data[7:0];
                                          uart_transmit  <= 1'b1;
                                       end 
                                 4'h4: state    <= SM_DIVIDE;
                              endcase
            SM_DIVIDE:   if(div_accept) begin
                              state    <= SM_LOADING;
                              q_data   <= div_q;
                              r_data   <= div_r;
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
      .i_clk         (i_clk               ),
      .i_nrst        (i_nrst              ),
      .i_rst_d       (1'b1                ),
      .i_d           (i_rx                ),
      .o_q           (uart_rx_sync        )
	);
   uart_autobaud uart_autobaud(
      .i_clk         (i_clk               ),
      .i_nrst        (i_nrst              ),
      .i_transmit    (uart_transmit       ),
      .i_data_tx     (send_data           ),
      .i_rx          (uart_rx_sync        ),
      .o_busy_rx     (                    ),
      .o_busy_tx     (                    ),
      .o_recieved    (uart_recieved       ),
      .o_data_rx     (uart_data_rx        ),
      .o_tx          (o_tx                )
   );
   ///////////////////////////////////////////////////

  
endmodule
