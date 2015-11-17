module fm_out_tb;

	parameter CLK_PERIOD = 20;
	parameter CENTRE_PERIOD = 30000;


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

	reg [31:0] file_in [255:0];
	reg [7:0] i; 
   	reg [7:0] j;
   	reg [7:0] k;
	initial begin
					$readmemh("sine.hex",file_in);
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
		for(i=0;i<1;i=i+1) begin
         	for(j=0;j<255;j=j+1) begin
           		#10000 	data = file_in[j];
           		#100	update = 1;
				#100 	update = 0;
           	end
     	end

		$finish;
	end

endmodule
