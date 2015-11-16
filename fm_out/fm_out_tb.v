module fm_out_tb;

	parameter CLK_PERIOD = 20;
	parameter CENTRE_PERIOD = 11000;


	reg 			clk;
	reg 			nRst;
	reg 			centre;
	reg 			update;
	reg 	[7:0]	data;
	wire			fm;

	fm_out fm_out(
		.clk	(clk 	),
		.nRst	(nRst	),
		.centre	(centre	),
		.update	(update	),
		.data	(data	),
		.fm 	(fm 	)
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("fm_out.vcd");
		$dumpvars(0,fm_out_tb);
	end

	initial begin
		while(1) begin
			#(CENTRE_PERIOD/2) centre = 0;
			#(CENTRE_PERIOD/2) centre = 1;
		end	
	end

	initial begin
					data 	= 0;
					update 	= 0;
					nRst 	= 1;
		#100		nRst 	= 0;
		#100		nRst 	= 1;


		repeat(10) begin
						data = data + 20;
			#100000	update = 1;
			#100 		update = 0;
		end

		$finish;
	end

endmodule
