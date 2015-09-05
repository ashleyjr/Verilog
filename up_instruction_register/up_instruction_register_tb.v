module up_instruction_register_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg         we;
   reg         sel;
   reg   [7:0] in;
   wire  [3:0] ir;

	up_instruction_register up_instruction_register(
		.clk	(clk  ),
		.nRst	(nRst ),
      .we   (we   ),
      .sel  (sel  ),
      .in   (in   ),
      .ir   (ir   )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_instruction_register.vcd");
		$dumpvars(0,up_instruction_register_tb);
	end

	initial begin
					nRst  = 1;
               we    = 0;
               sel   = 0;
               in    = 0;

		#100		nRst  = 0;
		#100		nRst  = 1;

      #100     in    = 8'hAB;
      #100     we    = 1;
      #100     we    = 0;
      #100     sel   = 1;
      #100     we    = 1;
      #100     we    = 0; 

		#10000
		$finish;
	end

endmodule
