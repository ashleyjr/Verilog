`timescale 1ns/1ps
module watchdog_tb;

	parameter CLK_PERIOD = 20;    // 50Mhz

	reg            clk;
	reg            nRst;
   reg   [31:0]   time_ns;
   reg            pet;
   wire           woof;

	watchdog watchdog(
		`ifdef POST_SYNTHESIS
			.clk	   (clk),
			.nRst	   (nRst)
		`else
			.clk	   (clk     ),
			.nRst	   (nRst    ),
		   .time_ns (time_ns ),
         .pet     (pet     ),
         .woof    (woof    )
      `endif
	);

	initial begin          
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("watchdog_syn.vcd");
			$dumpvars(0,watchdog_tb);
		`else
			$dumpfile("watchdog.vcd");
			$dumpvars(0,watchdog_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);	end

	initial begin
					   pet      = 0;
                  time_ns  = 32'd1000000; // 1ms
                  nRst     = 1;
		#100		   nRst     = 0;
		#100		   nRst     = 1;
      #500000     pet      = 0;
		#500000     pet      = 1;
      #100        pet      = 0;
      #600000     pet      = 1;
      #100        pet      = 0;
      #700000     pet      = 1;
      #100        pet      = 0;
      #800000     pet      = 1;
      #100        pet      = 0;
      #900000     pet      = 1;
      #100        pet      = 0;
      #990000     pet      = 1;
      #100        pet      = 0;
      #1000000    pet      = 1;
      #100        pet      = 0;
      #1000015    pet      = 1;
      #100        pet      = 0;
      #1000030    pet      = 1;  // One clock edge over limt
      #100        pet      = 0;
      #1000000    pet      = 1;
      #100        pet      = 0;
      #15000000   pet      = 1;
      #100        pet      = 0;
      #30000000   pet      = 1;
      #100        pet      = 0;
      #10000000   pet      = 1;
      #100        pet      = 0;
      #1000       pet      = 1;
      #100        pet      = 0;
      #100        pet      = 1;
      #100        pet      = 0;
      #10         pet      = 1;
      #100        pet      = 0;

      #100000
		$finish;
	end

endmodule
