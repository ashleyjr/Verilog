module up_program_counter_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg   [1:0] op;
   reg   [7:0] in;
   wire  [7:0] pc;

	up_program_counter up_program_counter(
		.clk	(clk  ),
		.nRst	(nRst ),
      .op   (op   ),
      .in   (in   ),
      .pc   (pc   )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_program_counter.vcd");
		$dumpvars(0,up_program_counter_tb);
	end

	initial begin
					nRst = 1;
               in = 0;
               op = 0;

		#100		nRst = 0;
		#100		nRst = 1;
		
      #100     op = 2'b01;
      #500     op = 2'b10;
      #100     op = 2'b11;

      #100     in = 8'hAA;
      #100     in = 8'h77; 

      #10000
		$finish;
	end

endmodule
