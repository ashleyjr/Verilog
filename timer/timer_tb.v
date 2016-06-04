`timescale 1ns/1ps

module timer_tb;

   parameter   CLK_BREAK         = 10000;    // 10us break
	parameter   CLK_PERIOD_50MHZ  = 20;       // 20ns period   
   parameter   CLK_50MHZ_4_1MS   = 50000;    // Cycles to get 1ms
   parameter   CLK_PERIOD_1MHZ   = 1000;     // 1us period 
   parameter   CLK_1MHZ_4_1MS    = 1000;     // Cycles to get 1ms

	reg         clk;
	reg         nRst;
   reg [31:0]  period_ns;
   reg [31:0]  clk_frequency_hz;
   wire        hit;

	timer timer(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst)
		`else
			.clk	               (clk                 ),
			.nRst	               (nRst                ),
	      .period_ns           (period_ns           ),
         .clk_frequency_hz    (clk_frequency_hz    ),
         .hit                 (hit                 )
      `endif
	);

	initial begin
      // 50MHz clock
      // Last for 1ms
		repeat(CLK_50MHZ_4_1MS) begin   
			#(CLK_PERIOD_50MHZ/2) clk = 0;
			#(CLK_PERIOD_50MHZ/2) clk = 1;
		end

      #CLK_BREAK 
      
      // 1MHz clock
      // Last for 1ms
		repeat(CLK_1MHZ_4_1MS) begin   
			#(CLK_PERIOD_1MHZ/2) clk = 0;
			#(CLK_PERIOD_1MHZ/2) clk = 1;
		end

   end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("timer_syn.vcd");
			$dumpvars(0,timer_tb);
		`else
			$dumpfile("timer.vcd");
			$dumpvars(0,timer_tb);
		`endif
   end

   
   // Find falling edges of hit and count the time between 
   // hit is high during reset so release from reset gives a falling edge
   integer  count_ns;
   reg      hit_last; 
   initial begin
      $display("   HIT_PERIOD   HIT   PERIOD_NS   CLK_FREQUENCY_HZ");
      count_ns = 0;
      while(1) begin
         #1
         if({hit_last,hit} == 2'b10) begin
            $display("%dus     %d  %d         %d",count_ns,hit,period_ns,clk_frequency_hz);
            count_ns = 0;
         end
         hit_last = hit;
         count_ns = count_ns + 1;
      end
   end


	initial begin
               period_ns            = 32'd50000;         // 50us
               clk_frequency_hz     = 32'd50000000;      // 50Mhz

               nRst        = 0; 
      #10000	nRst        = 1;
               
      #200000 
               period_ns            = 32'd20000;         // 20us
               clk_frequency_hz     = 32'd50000000;      // 50Mhz
      #200000
               period_ns            = 32'd127000;        // 127us
               clk_frequency_hz     = 32'd50000000;      // 50Mhz
      #600000
               period_ns            = 32'd127000;        // 127us
               clk_frequency_hz     = 32'd1000000;       // 1Mhz
      #1000000

      $finish;
	end

endmodule
