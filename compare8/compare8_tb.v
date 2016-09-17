`timescale 1ns/1ps
module compare8_tb;

	parameter CLK_PERIOD = 20;

	reg	      clk;
	reg	      nRst;
	reg	      set;
	reg	[7:0] cmp_static;
	reg	[7:0] cmp;
	wire	      out;
		
   compare8 compare8(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst),
			.rx	(rx),
			.sw2	(sw2),
			.sw1	(sw1),
			.sw0	(sw0),
			.tx	(tx),
			.led4	(led4),
			.led3	(led3),
			.led2	(led2),
			.led1	(led1),
			.led0	(led0)
		`else
			.clk	      (clk        ),
			.nRst	      (nRst       ),
			.set	      (set        ),
			.cmp_static	(cmp_static ),
			.cmp	      (cmp        ),
			.out	      (out        )
		`endif
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("compare8_syn.vcd");
			$dumpvars(0,compare8_tb);
		`else
			$dumpfile("compare8.vcd");
			$dumpvars(0,compare8_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
               set         = 1'b0;
               cmp_static  = 8'h00;
               cmp         = 8'h00;
					nRst		   = 1;
		#100     nRst        = 0;
      #100     nRst        = 1;
               

       // Freeze output low
      #100     cmp_static  = 8'h00;
      #100     set         = 1'b1;
      #100     set         = 1'b0;
      repeat(1000) begin
         #100     cmp         = 8'hFF;
         #100     cmp_static  = 8'hAA;
         #100     cmp         = 8'hEE;
         #100     cmp_static  = 8'h88;
      end

      // Sweep
      #100     cmp_static  = 8'hAA;
      #100     set         = 1'b1;
      #100     set         = 1'b0;
      #100     cmp         = 8'h00;
      repeat(1000) begin
         #50   cmp = cmp + 8'h1; 
      end
      #100     cmp_static  = 8'hBB;
      #100     set         = 1'b1;
      #100     set         = 1'b0;
      repeat(1000) begin
         #50   cmp = cmp + 8'h1; 
      end
      #100     cmp_static  = 8'h01;
      #100     set         = 1'b1;
      #100     set         = 1'b0;
      repeat(1000) begin
         #50   cmp = cmp + 8'h1; 
      end
      #100     cmp_static  = 8'hFF;
      #100     set         = 1'b1;
      #100     set         = 1'b0;
      repeat(1000) begin
         #50   cmp = cmp + 8'h1; 
      end
      

      


      #1000
      $finish;
	end

endmodule
