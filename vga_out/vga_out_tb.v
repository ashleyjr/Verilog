`timescale 1ns/1ps
module vga_out_tb;

	parameter CLK_PERIOD = 20;

	reg	clk;
	reg	nRst;
	wire	vga_h_sync;
	wire	vga_v_sync;
	wire	R;
	wire	G;
	wire	B;

	vga_out vga_out(			
	   .clk	      (clk		   ),			
		.nRst		   (nRst		   ),
		.vga_h_sync	(vga_h_sync	),
		.vga_v_sync	(vga_v_sync	),
		.R		      (R		      ),
		.G		      (G		      ),
		.B		      (B		      )	
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin			
		$dumpfile("vga_out.vcd");			
		$dumpvars(0,vga_out_tb);
	end

	initial begin				
		      nRst		= 1;
		#17	nRst		= 0;
		#17	nRst		= 1;
		#10000000
		$finish;
	end

endmodule
