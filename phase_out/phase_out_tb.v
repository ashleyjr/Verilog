module phase_out_tb;

	parameter CLK_PERIOD = 20;
	parameter FREQ_PERIOD = 60000;

	reg 		clk;
	reg 		nRst;
	reg			freq;
	reg	[7:0]	phase;
	reg			update;
	wire		out;

	phase_out phase_out(
		.clk	(clk 	),
		.nRst	(nRst	),
		.freq	(freq	),
		.phase 	(phase 	),
		.update	(update	),
		.out 	(out 	)
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("phase_out.vcd");
		$dumpvars(0,phase_out_tb);
	end


	initial begin
		while(1) begin
			#(FREQ_PERIOD/2) freq = 0;
			#(FREQ_PERIOD/2) freq = 1;
		end	
	end

	reg [31:0] file_in [255:0];
	reg [7:0] i; 
   	reg [7:0] j;
   	reg [7:0] k;
	initial begin
					$readmemh("sine.hex",file_in);
					phase	= 0;
					update 	= 0;
					nRst 	= 1;
		#100		nRst 	= 0;
		#100		nRst 	= 1;


		repeat(10) begin
						phase = phase+ 20;
			#100000	update = 1;
			#100 		update = 0;
		end
		for(i=0;i<1;i=i+1) begin
         	for(j=0;j<255;j=j+1) begin
           		#10000 	phase = file_in[j];
           		#100	update = 1;
				#100 	update = 0;
           	end
     	end

		$finish;
	end

endmodule
