`timescale 1ns/1ps
module vga_out_tb;

   // 25MHz clock
	parameter CLK_PERIOD = 40;

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
      $display("V,H,R,G,B");
      // Write every 1ns
      while(1) begin
         @(posedge clk)
            $display("%d,%d,%d,%d,%d",
               vga_v_sync,
               vga_h_sync,
               R,
               G,
               B
            );
      end
   end

	initial begin				
		      nRst		= 1;
		#17	nRst		= 0;
		#17	nRst		= 1;
		#50000000
		$finish;
	end

endmodule
