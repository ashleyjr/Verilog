module up_stack_pointer_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg         add;
   reg         sub;
   wire [7:0]  sp;

	up_stack_pointer up_stack_pointer(
		.clk	(clk  ),
		.nRst	(nRst ),
	   .add  (add  ),
      .sub  (sub  ),
      .sp   (sp   )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_stack_pointer.vcd");
		$dumpvars(0,up_stack_pointer_tb);
	end

	initial begin
					nRst  = 1;
               add   = 0;
               sub   = 0;
               
		#100		nRst  = 0;
		#100		nRst  = 1;
		
      #100     sub   = 1;
      #100     add   = 1;
      #100     sub   = 0;
      #50      add   = 0;
      #100     sub   = 1;
      #500     sub   = 0;
      #10000
		$finish;
	end

endmodule
