`timescale 1ns/1ps
module up2_mem(
	input				clk,
	input				nRst,
	input				rx,
	input				sw2,
	input				sw1,
	input				sw0,
	output	reg	tx,
	output	reg	led4,
	output	reg	led3,
	output	reg	led2,
	output	reg	led1,
	output	reg	led0
);

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
			tx   <= 1'b0;
			led4 <= 1'b0;
			led3 <= 1'b0;
			led2 <= 1'b0;
			led1 <= 1'b0;
			led0 <= 1'b0;
		end else begin
			tx   <= rx;
			led4 <= sw1;
			led3 <= 1'b1;
			led2 <= sw2;
			led1 <= 1'b1;
			led0 <= sw0;
		end
	end
endmodule
