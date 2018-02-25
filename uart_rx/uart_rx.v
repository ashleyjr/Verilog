///////////////////////////////////////////////////////////
// uart_rx.v
// Recieve only 8-bit UART with fixed baud rate
//
///////////////////////////////////////////////////////////

`timescale 1ns/1ps

module uart_rx(
	input   wire            i_clk,
	input   wire		    i_nrst,

    output	reg	    [7:0]   o_data,
	input   wire            i_rx,
	
    output  reg             o_valid,
    input   wire            i_accept
);

    parameter   CLK_MHZ     = 1,
                CLK_HZ      = CLK_MHZ*1000000,
                BAUD_RATE   = 9600,
                SAMPLE      = CLK_HZ/BAUD_RATE,  
                RX_IDLE     = 4'h0,
                RX_START    = 4'h1,
                RX_1        = 4'h2,
                RX_2        = 4'h3,
                RX_3        = 4'h4,
                RX_4        = 4'h5,
                RX_5        = 4'h6,
                RX_6        = 4'h7,
                RX_7        = 4'h8,
                RX_8        = 4'h9,
                RX_ACCEPT   = 4'hA,
                RX_WAIT     = 4'hB;

    reg [3:0]                   state;
    reg [$clog2(SAMPLE)-1:0]    count;
	
    assign full_sample = (count == SAMPLE);
    assign half_sample = (count == (SAMPLE >> 1));

    always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
	        state   <= RX_IDLE;	
            count   <= 'b0;
            o_valid <= 1'b0;
		end else begin
            if(!full_sample) begin
                count <= count + 'b1;
            end
            case(state)
                RX_IDLE:    if(!rx) begin
                                state   <= RX_START;
                                count   <= 'b0; 
                            end

                RX_START:   if(half_sample) begin
                                state   <= RX_0;
                                count   <= 'b0;
                            end
                RX_0,
                RX_1, 
                RX_2, 
                RX_3,
                RX_4, 
                RX_5, 
                RX_6, 
                RX_7:       if(full_sample) begin
                                data    <= {rx,data[7:1]}; 
                                state   <= state + 'b1;
                                count   <= 'b0;
                                o_valid <= 1'b1;
                            end
                RX_ACCEPT:  if(i_accept) begin                
                                state   <= RX_WAIT;
                            end
                RX_WAIT:    if(full_sample) begin
                                state   <= RX_IDLE;  
                            end
                default:    state       <= RX_IDLE;
             endcase
        end
	end
endmodule
