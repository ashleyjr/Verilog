`timescale 1ns/1ps
module sequential_alu_test(
	input			i_clk,
	input			i_nrst,
	input			i_rx,
	output	   o_tx	
);

   parameter   DATA_WIDTH = 18;

   reg   [DATA_WIDTH-1:0]  a;
   reg   [DATA_WIDTH-1:0]  b;
   wire  [DATA_WIDTH-1:0]  q;
   reg                     add;
   reg                     sub;
   reg                     mul;
   reg                     div;
   wire                    ovf;
   wire                    zero;
   wire                    accept;

   sequential_alu #(
      .DATA_WIDTH    (DATA_WIDTH ) 
   ) sequential_multiplier (
      .i_clk         (i_clk         ),
      .i_nrst        (i_nrst        ),
      .i_a           (a             ),   
      .i_b           (b             ),   
      .i_add         (~accept & add ), 
      .i_sub         (~accept & sub ), 
      .i_mul         (~accept & mul ), 
      .i_div         (~accept & div ), 
      .o_q           (q             ),
      .o_ovf         (ovf           ),
      .o_zero        (zero          ),
      .o_accept      (accept        )
	);


   ///////////////////////////////////////////////////
   // UART to MUL
   reg   [DATA_WIDTH-1:0]  r;

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         uart_transmit  <= 1'b0; 
         add            <= 1'b0;
         sub            <= 1'b0;
         mul            <= 1'b0;
         div            <= 1'b0; 
		   r              <= 'd0;
         a              <= 'd0;
         b              <= 'd0;
      end else begin
		   uart_transmit <= 1'b0;
         if(accept) begin
            add            <= 1'b0;
            sub            <= 1'b0;
            mul            <= 1'b0;
            div            <= 1'b0;
            r              <= q;
            uart_data_tx   <= {6'd0, ovf, zero};
         end else begin
            if(uart_recieved)
               case(uart_data_rx[3:0])
                  4'h0: a  <= {a[31-4:0], uart_data_rx[7:4]}; 
                  4'h1: b  <= {b[31-4:0], uart_data_rx[7:4]}; 
                  4'h2: begin
                           r              <= r >> 8;
                           uart_data_tx   <= r[7:0];
                           uart_transmit  <= 1'b1;
                        end 
                  4'h3: uart_transmit  <= 1'b1; 
                  4'h4: add            <= 1'b1;   
                  4'h5: sub            <= 1'b1;
                  4'h6: mul            <= 1'b1;
                  4'h7: div            <= 1'b1;
               endcase
         end       
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
