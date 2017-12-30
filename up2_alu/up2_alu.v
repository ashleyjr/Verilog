`timescale 1ns/1ps

module up2_alu(
	input				    clk,
	input				    nRst,	
	input   wire            i_r_write,
    input   wire    [3:0]   i_r0,
    input   wire    [3:0]   i_r1,
    input   wire    [3:0]   i_r2,
    input   wire    [3:0]   i_mux_sel,
    input   wire    [3:0]   i_alu_op,
	output	wire	[3:0]   o_r0,
	output	wire    [3:0]   o_r1,
	output	wire    [3:0]   o_r2,
    output  wire            o_zero_flag
);

    reg     [3:0]   r0;
    reg     [3:0]   r1;
    reg     [3:0]   r2;

    wire    [3:0]   alu_a;
    wire    [3:0]   alu_b;
    wire    [3:0]   alu_out;

    // Swap regs
    assign o_r0 = r0;
    assign o_r1 = r1;
    assign o_r2 = r2;

    // ALU inputs
    assign alu_a    = (i_mux_sel[3])        ?   1'b1            :
                                                r0              ;
    assign alu_b    = (i_mux_sel[2])        ?   r1              :
                                                r2              ;
    // ALU operations
    assign alu_out  = (4'h0 == i_alu_op)    ?   alu_a + alu_b   :
                                                alu_a - alu_b   ;
    // Zero flag
    assign o_zero_flag = (4'h0 == alu_out);

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
	        r0 <= 4'h0;
            r1 <= 4'h0;
            r2 <= 4'h0;
		end else begin 
            if(i_r_write) begin
	            r0 <= i_r0;
                r1 <= i_r1;
                r2 <= i_r2;
            end else begin
                // Write back
                case(i_mux_sel[1:0])
                    2'b00:   r0 <= alu_out;
                    2'b01:   r1 <= alu_out;
                    2'b10:   r2 <= alu_out;
                endcase
            end
		end
	end
endmodule
