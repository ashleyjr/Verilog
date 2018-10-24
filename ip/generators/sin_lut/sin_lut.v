`timescale 1ns/1ps
module sin_lut(
	input	[$clog2(64)-1:0]	i_theta,
	output	[10-1:0]	o_sin
);
assign o_sin =  (i_theta == 'd0) ?	'd512 : 
		(i_theta == 'd1) ?	'd562 : 
		(i_theta == 'd2) ?	'd611 : 
		(i_theta == 'd3) ?	'd660 : 
		(i_theta == 'd4) ?	'd707 : 
		(i_theta == 'd5) ?	'd753 : 
		(i_theta == 'd6) ?	'd796 : 
		(i_theta == 'd7) ?	'd836 : 
		(i_theta == 'd8) ?	'd874 : 
		(i_theta == 'd9) ?	'd907 : 
		(i_theta == 'd10) ?	'd937 : 
		(i_theta == 'd11) ?	'd963 : 
		(i_theta == 'd12) ?	'd985 : 
		(i_theta == 'd13) ?	'd1001 : 
		(i_theta == 'd14) ?	'd1014 : 
		(i_theta == 'd15) ?	'd1021 : 
		(i_theta == 'd16) ?	'd1023 : 
		(i_theta == 'd17) ?	'd1021 : 
		(i_theta == 'd18) ?	'd1014 : 
		(i_theta == 'd19) ?	'd1001 : 
		(i_theta == 'd20) ?	'd985 : 
		(i_theta == 'd21) ?	'd963 : 
		(i_theta == 'd22) ?	'd937 : 
		(i_theta == 'd23) ?	'd907 : 
		(i_theta == 'd24) ?	'd874 : 
		(i_theta == 'd25) ?	'd836 : 
		(i_theta == 'd26) ?	'd796 : 
		(i_theta == 'd27) ?	'd753 : 
		(i_theta == 'd28) ?	'd707 : 
		(i_theta == 'd29) ?	'd660 : 
		(i_theta == 'd30) ?	'd611 : 
		(i_theta == 'd31) ?	'd562 : 
		(i_theta == 'd32) ?	'd512 : 
		(i_theta == 'd33) ?	'd461 : 
		(i_theta == 'd34) ?	'd412 : 
		(i_theta == 'd35) ?	'd363 : 
		(i_theta == 'd36) ?	'd316 : 
		(i_theta == 'd37) ?	'd270 : 
		(i_theta == 'd38) ?	'd227 : 
		(i_theta == 'd39) ?	'd187 : 
		(i_theta == 'd40) ?	'd150 : 
		(i_theta == 'd41) ?	'd116 : 
		(i_theta == 'd42) ?	'd86 : 
		(i_theta == 'd43) ?	'd60 : 
		(i_theta == 'd44) ?	'd38 : 
		(i_theta == 'd45) ?	'd22 : 
		(i_theta == 'd46) ?	'd9 : 
		(i_theta == 'd47) ?	'd2 : 
		(i_theta == 'd48) ?	'd0 : 
		(i_theta == 'd49) ?	'd2 : 
		(i_theta == 'd50) ?	'd9 : 
		(i_theta == 'd51) ?	'd22 : 
		(i_theta == 'd52) ?	'd38 : 
		(i_theta == 'd53) ?	'd60 : 
		(i_theta == 'd54) ?	'd86 : 
		(i_theta == 'd55) ?	'd116 : 
		(i_theta == 'd56) ?	'd149 : 
		(i_theta == 'd57) ?	'd187 : 
		(i_theta == 'd58) ?	'd227 : 
		(i_theta == 'd59) ?	'd270 : 
		(i_theta == 'd60) ?	'd315 : 
		(i_theta == 'd61) ?	'd363 : 
		(i_theta == 'd62) ?	'd412 : 
		// i_theta == 'd63
					'd461;
endmodule
