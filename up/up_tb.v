module up_tb;

	parameter CLK_PERIOD = 20;

	reg      clk;
	reg      nRst;
   reg      int;	
   
   up up(
		.clk     (clk     ),
		.nRst    (nRst    ),
	   .int     (int     ) 
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up.vcd");
		$dumpvars(0,up_tb);
	end

	initial begin
					nRst     = 1; 
		         int      = 0;
      #100		nRst     = 0;
		#100		nRst     = 1;
      
      #10000   int      = 1;
		$finish;
	end

endmodule
