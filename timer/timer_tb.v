module timer_tb;

	parameter CLK_PERIOD = 20;

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
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("timer_syn.vcd");
			$dumpvars(0,timer_tb);
		`else
			$dumpfile("timer.vcd");
			$dumpvars(0,timer_tb);
		`endif
	end

	initial begin
               nRst        = 1;
		#100		nRst        = 0; 
      #100		nRst        = 1;
		#100000         
               
         // TODO: Change clock source to match
         // TODO: More test cases
      
               // Division of 400
               period_ns            = 32'd50000;         // 50us
               clk_frequency_hz     = 32'd8000000;       // 8Mhz
      #100000
               
               period_ns            = 32'd1000000;       // 1ms
               clk_frequency_hz     = 32'd3140000;       // 3.14Mhz
      #100000

      $finish;
	end

endmodule
