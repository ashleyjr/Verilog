`timescale 1ns/1ps
module ice_fm_tx(
	input				i_clk,
	input				i_nrst,
	input				i_rx,
	input				i_sw2,
	input				i_sw1,
	input				i_sw0,
	output	reg	o_tx,
	output	reg	o_led4,
	output	reg	o_led3,
	output	reg	o_led2,
	output	reg	o_led1,
	output	reg	o_led0
);

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
			o_tx   <= 1'b0;
			o_led4 <= 1'b0;
			o_led3 <= 1'b0;
			o_led2 <= 1'b0;
			o_led1 <= 1'b0;
			o_led0 <= 1'b0;
		end else begin
			o_tx   <= i_rx;
			o_led4 <= i_sw1;
			o_led3 <= 1'b1;
			o_led2 <= i_sw2;
			o_led1 <= 1'b1;
			o_led0 <= i_sw0;
		end
	end
endmodule
