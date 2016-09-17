`timescale 1ns/1ps
module clk_div8_tb;

	parameter CLK_PERIOD = 20;

	reg	      clk;
	reg	      nRst;
	reg	[7:0] div;
	reg	      set;	
	wire	      clk_div;

	clk_div8 clk_div8(
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
			.clk	   (clk     ),
			.nRst	   (nRst    ),
			.div	   (div     ),
			.set	   (set     ),
			.clk_div (clk_div )
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
			$dumpfile("clk_div8_syn.vcd");
			$dumpvars(0,clk_div8_tb);
		`else
			$dumpfile("clk_div8.vcd");
			$dumpvars(0,clk_div8_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

	initial begin
					div      = 8'h00;
               set      = 1'b0;
               nRst		= 1;
		#100     nRst     = 0;
      #100     nRst     = 1;

      // sweep through clock div combos
      repeat(300) begin
         #100000  div = div + 8'h01;
                  set = 1'b1;
         #100     set = 1'b0;
      end

		#10000
		$finish;
	end

endmodule
