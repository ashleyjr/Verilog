`timescale 1ns/1ps
module up2_code_tb;

    reg     [127:0]     address;
    wire    [3:0]       data;

    up2_code up2_code(
		.address	(address),
		.data	    (data   )	
	);

	initial begin
	    $dumpfile("up2_code.vcd");
	    $dumpvars(0,up2_code_tb);
	end

	initial begin
	    repeat(100) begin
            #1 address = $random;
        end
		$finish;
	end

endmodule
