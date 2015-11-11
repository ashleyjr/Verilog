module clk_divider_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            update;
   reg   [31:0]   div;
   wire           div_clk;

	clk_divider clk_divider(
		.clk	   (clk),
		.nRst	   (nRst),
      .update  (update),
      .div     (div),
      .div_clk (div_clk)
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("clk_divider.vcd");
		$dumpvars(0,clk_divider_tb);
	end

	initial begin
               update   = 0;
               div      = 0;

					nRst     = 1;
		#100		nRst     = 0;
		#100		nRst     = 1;
		


      // Set up to divide input clock by 10
      #1000    update   = 1;
      #100     div      = 32'd10;
      #100     update   = 0;
      #1000

      // Set up to divide input clock by 100
      #1000    update   = 1;
      #100     div      = 32'd100;
      #100     update   = 0;
      #10000

      // Set up to divide input clock by 0
      #1000    update   = 1;
      #100     div      = 32'd0;
      #100     update   = 0;
      #1000

		$finish;
	end

endmodule
