`timescale 1ns/1ps

module uart_tx(
	input   wire	        i_clk,
	input   wire	        i_nrst,
	
    input   wire    [7:0]   i_data,
    output  reg             o_tx 
     
    input   wire	        i_valid,
    output	reg	            o_accept 

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
