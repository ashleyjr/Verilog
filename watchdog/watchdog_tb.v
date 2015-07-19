module watchdog_tb;

	parameter CLK_PERIOD = 20;

	reg   clk;
	reg   nRst;
   reg   sleep;
   reg   sclk;
   reg   in;
   reg   sel;
   wire  woof;

	watchdog watchdog(
		.clk	   (clk),
		.nRst	   (nRst),
      .sleep   (sleep),
      .sclk    (sclk),
      .in      (in),
      .sel     (sel),
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
      while(1) begin
         #100  sclk = 0;
         #100  sclk = 1;
      end
   end
   initial begin
            nRst  = 1;
            sleep = 0;
            in    = 0;
      #100  nRst  = 0;
      #100  nRst  = 1;
      #100  sel   = 1;
      #400  in    = 1;
      #100  in    = 0;
      #20   sel   = 0;
      
      #100  nRst = 1;
      #100  nRst = 0;
      #100  nRst = 1;
      
      #3000
      $finish;
   end
endmodule
