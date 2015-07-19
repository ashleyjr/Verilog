module watchdog_tb;

	parameter CLK_PERIOD = 20;


   integer i;

   reg   clk;
	reg   nRst;
   reg   sclk;
   reg   in;
   reg   sel;
   wire  woof;

	watchdog watchdog(
		.clk	   (clk),
		.nRst	   (nRst),
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
   
   task clock_in_top;
      input [31:0] top;
      begin
         sel = 1; 
         for(i=31;i>=0;i=i-1) begin
            #50   sclk  = 0;
            #50   in    = top[i];
            #50   sclk  = 1;
         end
         #50 sel = 0;
      end
   endtask
   
   
   initial begin
            nRst  = 1;
            in    = 0;
            sel   = 0;
            sclk  = 1;

      #100  nRst  = 0;
      #100  nRst  = 1;

      clock_in_top(32'd100);   
      #30000
      clock_in_top(32'd1234);   
      #30000
      clock_in_top(32'd1000);   
      #30000
      $finish;
   end
endmodule
