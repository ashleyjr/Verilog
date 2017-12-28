`timescale 1ns/1ps
module up2_mem (
	input				            clk,
	input				            nRst,

    // Mem side
    input                           i_read_ack,
    output                          o_read_req,

    input                           i_write_ack,
    output                          o_write_req,
    
    input   [DATA_WIDTH-1:0]        i_data,
    output  [ADDR_WIDTH-1:0]        o_addr,
    output  [DATA_WIDTH-1:0]        o_data,

    // Regs side
    input                           i_shift,
    input   [3:0]                   i_shift_data,
    output  [3:0]                   o_shift_data,
    input                           i_swap_req,
    output                          o_swap_ack
);

    parameter   ADDR_NIBBLES    = 1;
    parameter   DATA_NIBBLES    = 1;
    parameter   SHIFT_WIDTH     = 4 * (ADDR_NIBBLES+DATA_NIBBLES);
    parameter   ADDR_WIDTH      = 4 * ADDR_NIBBLES;
    parameter   DATA_WIDTH      = 4 * DATA_NIBBLES;
    parameter   IDLE            = 2'b00;
    parameter   READ_REQ_1      = 2'b01;
    parameter   WRITE_REQ       = 2'b10;
    parameter   READ_REQ_2      = 2'b11;

    reg     [SHIFT_WIDTH-1:0]   shift;
    reg     [1:0]               state;
    wire    [DATA_WIDTH-1:0]    shift_update;

    assign  o_data              =   shift[DATA_WIDTH-1:0] ^ i_data;
    assign  o_addr              =   shift[SHIFT_WIDTH-1:DATA_WIDTH];
    assign  o_shift_data        =   shift[3:0];
    assign  shift_update        =   o_data ^ i_data;
    assign  o_read_req          =   (   ((state == IDLE)        && (i_swap_req))    ||
                                        ((state == READ_REQ_1)  && (~i_read_ack))   ||
                                        ((state == WRITE_REQ)   && (i_write_ack))   ||
                                        ((state == READ_REQ_2)  && (~i_read_ack)));
    assign  o_write_req         =   (   ((state == READ_REQ_1)  && (i_read_ack))    ||
                                        ((state == WRITE_REQ)   && (~i_write_ack)));
    assign  o_swap_ack          =   (   ( state == READ_REQ_2)  && (i_read_ack));


	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
		    shift       <= 'd0;
            state       <= IDLE;
        end else begin
            if(i_shift) begin
                shift   <= {i_shift_data,shift[SHIFT_WIDTH-1:4]};
            end 
            case(state)
                IDLE:       if(i_swap_req) begin
                                state                   <= READ_REQ_1;
                            end
                READ_REQ_1: if(i_read_ack) begin
                                shift[DATA_WIDTH-1:0]   <= shift_update;
                                state                   <= WRITE_REQ;
                            end 
                WRITE_REQ:  if(i_write_ack) begin
                                state                   <= READ_REQ_2;
                            end 
                READ_REQ_2: if(i_read_ack) begin
                                shift[DATA_WIDTH-1:0]   <= shift_update; 
                                state                   <= IDLE;
                            end 
            endcase
		end
	end
endmodule
