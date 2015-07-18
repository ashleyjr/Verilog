module watchdog_tb;

	parameter CLK_PERIOD = 20;

	reg   clk;
	reg   nRst;
   reg   sleep;
   wire  woof;

	watchdog watchdog(
		.clk	   (clk),
		.nRst	   (nRst),
      .sleep   (sleep),
      .woof    (woof)
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("watchdog.vcd");
		$dumpvars(0,watchdog_tb);
	end

   initial begin
            nRst = 1;
            sleep = 0;
      #100  nRst = 0;
      #100  nRst = 1;
      #100  sleep = 1;
      #3000
      $finish;
   end
endmodule
