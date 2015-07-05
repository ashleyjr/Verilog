
module fir_filter_tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD_1 = 8700;
   parameter BAUD_PERIOD_2 = 100;

   reg            clk;
   reg            nRst;
   reg   [31:0]   in;
   wire  [31:0]   out;
      
   fir_filter fir_filter(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .in         (in         ),
      .out        (out        )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
      $dumpfile("fir_filter.vcd");
      $dumpvars(0,fir_filter_tb);
   end
	
   initial begin
               in    = 32'd100;
      #100     nRst  = 1;
      #100     nRst  = 0;
      #50      nRst  = 1;
      #300     in    = 32'd101;
      #300     in    = 32'd102;
	   $finish;
	end





endmodule

