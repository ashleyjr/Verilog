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
		


      // Set up to divide input clock by 2
      #1000    update   = 1;
      #100     div      = 32'd2;
      #100     update   = 0;
      #1000

      // Set up to divide input clock by 3
      #1000    update   = 1;
      #100     div      = 32'd3;
      #100     update   = 0;
      #10000

      // Set up to divide input clock by 4
      #1000    update   = 1;
      #100     div      = 32'd4;
      #100     update   = 0;
      #1000

	// Set up to divide input clock by 5
      #1000    update   = 1;
      #100     div      = 32'd5;
      #100     update   = 0;
      #1000

      // Set up to divide input clock by 400
      #1000    update   = 1;
      #100     div      = 32'd400;
      #100     update   = 0;
      #10000

      // Set up to divide input clock by 100
      #1000    update   = 1;
      #100     div      = 32'd100;
      #100     update   = 0;
      #1000

      // Set up to divide input clock by 50
      #1000    update   = 1;
      #100     div      = 32'd50;
      #100     update   = 0;
      #1000

      // Set up to divide input clock by 20
      #1000    update   = 1;
      #100     div      = 32'd20;
      #100     update   = 0;
      #10000


      // Change div input
      #1000 		div = 32'd10;
      #1000 		div = 32'd345;
      #1000 		div = 32'd1345;
      #1000 		div = 32'd3453;
      #1000 		div = 32'd3;

		$finish;
	end

endmodule
