module up_tb;

	parameter CLK_PERIOD = 20;

	integer idx;

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
		for (idx = 0; idx < 256; idx = idx + 1) $dumpvars(0,up_tb.up.up_memory.mem[idx]);
	end

	initial begin
					nRst     = 1; 
		         int      = 0;
      #100		nRst     = 0;
		#10		nRst     = 1;
     
      //repeat(25) begin
      //   #10000   int      = 1;
		//   #10000   int      = 0;
      //end
      //#10000   int = 1;
      //#10000     int = 0;
      //repeat(25) begin
      //   #2300     int = 1;
      //   #2300     int = 0;
      //end

      #100000
      $finish;
	end

endmodule
