`timescale 1ns/1ps
module up2_mem#(
    parameter                       addr_nibbles,
    parameter                       data_nibbles,
    parameter                       shift_width = 4*(addr_nibbles+data_nibbles),
    parameter                       addr_width = (4*addr_nibbles),
    parameter                       data_width = (4*data_nibbles)
)(
	input				            clk,
	input				            nRst,

    // Mem side
    input                           i_read_ack,
    output                          o_read_req,

    input                           i_write_ack,
    output                          o_write_req,
    
    output  [data_width-1:0]        i_data,
    output  [addr_width-1:0]        o_addr,
    output  [data_width-1:0]        o_data

    // Regs side
    input                           i_shift,
    input   [3:0]                   i_shift_data,
    output  [3:0]                   o_shift_data,
    input                           i_swap_req,
    output                          o_swap_ack,
);

    parameter   ONE
    parameter   TWO
    parameter   THREE

    reg [shift_width-1:0] shift;
    reg state
    wire    [data_width-1]  shift_update;

    assign  o_data          =   shift[data_width-1:0] ^ i_data;
    assign  o_addr          =   shift[shift_width-1:data_width];
    assign  o_shift         =   shift[3:0];
    assign  shift_update    =   o_data ^ i_data;

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
		    shift       <= 'd0;
        end else begin
            o_read_req  <= 1'b0;
            o_write_req <= 1'b0;
            case(state)
                IDLE:       begin
                                if(i_shift) begin
                                    shift       <= {i_shift,shift[shift_width-1:4]};
                                end 
                                if(i_swap) begin
                                    o_read_req  <= 1'b1;
                                    state       <= READ_REQ_1;
                                end
                            end
                READ_REQ_1: begin
                                if(i_read_ack) begin
                                    shift[data_width-1:0]   <= shift_update;
                                    o_write_req             <= 1'b1;
                                    state                   <= WRITE_REQ
                                end else begin
                                    o_read_req <= 1'b1
                                end
                            end
                WRITE_REQ:  begin
                                if(i_write_ack) begin
                                    o_read_req              <= 1'b1;
                                    state                   <= READ_REQ_2;
                                end else begin
                                    o_write_req             <= 1'b1;
                                end
                            end
                READ_REQ_2: begin
                                if(i_read_ack) begin
                                    shift[data_width-1:0]   <= shift_update; 
                                    state                   <= IDLE
                                end else begin
                                    o_read_req              <= 1'b1;
                                end
                            end
            endcase
		end
	end
endmodule
