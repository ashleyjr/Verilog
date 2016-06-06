`timescale 1ns/1ps
module parity_bit_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            start;
   reg   [31:0]   data;
   reg            parity;
   wire           finished;
   wire           error;

	parity_bit 
      #(.WIDTH(32)) 
   parity_bit(
		`ifdef POST_SYNTHESIS
			.clk	(clk),
			.nRst	(nRst)
		`else
			.clk	         (clk        ),
			.nRst	         (nRst       ),
		   .start         (start      ),
         .data          (data       ),
         .parity        (parity     ),
         .finished      (finished   ),
         .error         (error      )
      `endif
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("parity_bit_syn.vcd");
			$dumpvars(0,parity_bit_tb);
		`else
			$dumpfile("parity_bit.vcd");
			$dumpvars(0,parity_bit_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);	end

	initial begin
               start    = 0;
               data     = 32'hAAAAAAAA;
					parity   = 0;
               nRst     = 1;
		#100		nRst     = 0;
		#100		nRst     = 1;
      #100     start    = 1;
      #1000    start    = 0;
		#10000
		$finish;
	end

endmodule
