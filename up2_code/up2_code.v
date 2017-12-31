`timescale 1ns/1ps
module up2_code(
	input  [$clog2(SIZE)-1:0]   address,
	output [3:0]                data
);
	parameter SIZE = 20;
	assign data = 
		(address == 'd0) ? 4'h7 :
		(address == 'd1) ? 4'h1 :
		(address == 'd2) ? 4'h0 :
		(address == 'd3) ? 4'h0 :
		(address == 'd4) ? 4'hC :
		(address == 'd5) ? 4'h0 :
		(address == 'd6) ? 4'h0 :
		(address == 'd7) ? 4'hC :
		(address == 'd8) ? 4'hD :
		(address == 'd9) ? 4'hC :
		(address == 'd10) ? 4'hC :
		(address == 'd11) ? 4'h4 :
		(address == 'd12) ? 4'h4 :
		(address == 'd13) ? 4'h4 :
		(address == 'd14) ? 4'h5 :
		(address == 'd15) ? 4'h4 :
		(address == 'd16) ? 4'h4 :
		(address == 'd17) ? 4'hA :
		(address == 'd18) ? 4'h0 :
		(address == 'd19) ? 4'h2 :
		'h0;
endmodule
