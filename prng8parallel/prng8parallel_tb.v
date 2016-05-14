module prng8parallel_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            update;
   reg            reseed;
   reg   [7:0]    seed;
   wire  [7:0]    rand;

	prng8parallel prng8parallel(
		`ifdef POST_SYNTHESIS
			.clk	      (clk     ),
			.nRst	      (nRst    ),
		   .update     (update  ),
         .reseed     (reseed  ),
         . \seed[7]  (seed[7] ),
         . \seed[6]  (seed[6] ),
         . \seed[5]  (seed[5] ),
         . \seed[4]  (seed[4] ),
         . \seed[3]  (seed[3] ),
         . \seed[2]  (seed[2] ),
         . \seed[1]  (seed[1] ),
         . \seed[0]  (seed[0] ),
         . \rand[7]  (rand[7] ),
         . \rand[6]  (rand[6] ),
         . \rand[5]  (rand[5] ),
         . \rand[4]  (rand[4] ),
         . \rand[3]  (rand[3] ),
         . \rand[2]  (rand[2] ),
         . \rand[1]  (rand[1] ),
         . \rand[0]  (rand[0] )
      `else
			.clk	      (clk     ),
			.nRst	      (nRst    ),
         .update     (update  ),
         .reseed     (reseed  ),
		   .seed       (seed    ),
         .rand       (rand    )
      `endif
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("prng8parallel_syn.vcd");
			$dumpvars(0,prng8parallel_tb);
		`else
			$dumpfile("prng8parallel.vcd");
			$dumpvars(0,prng8parallel_tb);
		`endif
	end

   task plant;
      input [63:0]   value; 
      begin
         #1005          reseed   = 1;
         #CLK_PERIOD    seed     = value[7:0];
         #CLK_PERIOD    seed     = value[15:8];
         #CLK_PERIOD    seed     = value[23:16];
         #CLK_PERIOD    seed     = value[31:24];
         #CLK_PERIOD    seed     = value[37:32];
         #CLK_PERIOD    seed     = value[45:38];
         #CLK_PERIOD    seed     = value[53:46];
         #CLK_PERIOD    seed     = value[61:54];
         #100           reseed   = 0;
         #100000        reseed   = 0;
      end
   endtask

	initial begin
					update   = 1;
               reseed   = 0;
               nRst     = 1;
		#100		nRst     = 0;
		#100		nRst     = 1;
		         plant(64'h1234783916791684);       
               $finish;
	end

endmodule
