module prng8_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            reseed;
   reg   [7:0]    seed;
   wire  [7:0]    rand;

	prng8 prng8(
		`ifdef POST_SYNTHESIS
			.clk	      (clk     ),
			.nRst	      (nRst    ),
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
         . \rand[0]  (rand[0] ),
      `else
			.clk	      (clk     ),
			.nRst	      (nRst    ),
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
			$dumpfile("prng8_syn.vcd");
			$dumpvars(0,prng8_tb);
		`else
			$dumpfile("prng8.vcd");
			$dumpvars(0,prng8_tb);
		`endif
	end

   task plant;
      input [7:0] value;
      begin
         #1000    reseed   = 1;
         #1000    seed     = value;
         #100     reseed   = 0;
         #100000  reseed   = 0;
      end
   endtask

	initial begin
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;
		plant(8'h88);      
      plant(8'h66);      
      plant(8'h77);      
      plant(8'h00);      
      plant(8'hFF);      
      plant(8'h28);      
      plant(8'h39);      
      plant(8'h46);      
      $finish;
	end

endmodule
