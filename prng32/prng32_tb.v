module prng32_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            reseed;
   reg   [31:0]   seed;
   wire  [31:0]   rand;

	prng32 prng32(
		`ifdef POST_SYNTHESIS
			.clk	         (clk        ),
			.nRst	         (nRst       ),
		   .reseed        (reseed     ), 
         . \seed[31]    (seed[31]   ),   
         . \seed[30]    (seed[30]   ), 
         . \seed[29]    (seed[29]   ), 
         . \seed[28]    (seed[28]   ), 
         . \seed[27]    (seed[27]   ), 
         . \seed[26]    (seed[26]   ), 
         . \seed[25]    (seed[25]   ), 
         . \seed[24]    (seed[24]   ), 
         . \seed[23]    (seed[23]   ), 
         . \seed[22]    (seed[22]   ), 
         . \seed[21]    (seed[21]   ), 
         . \seed[20]    (seed[20]   ), 
         . \seed[19]    (seed[19]   ), 
         . \seed[18]    (seed[18]   ), 
         . \seed[17]    (seed[17]   ), 
         . \seed[16]    (seed[16]   ), 
         . \seed[15]    (seed[15]   ), 
         . \seed[14]    (seed[14]   ), 
         . \seed[13]    (seed[13]   ), 
         . \seed[12]    (seed[12]   ), 
         . \seed[11]    (seed[11]   ), 
         . \seed[10]    (seed[10]   ), 
         . \seed[9]     (seed[9]    ), 
         . \seed[8]     (seed[8]    ), 
         . \seed[7]     (seed[7]    ), 
         . \seed[6]     (seed[6]    ), 
         . \seed[5]     (seed[5]    ), 
         . \seed[4]     (seed[4]    ), 
         . \seed[3]     (seed[3]    ), 
         . \seed[2]     (seed[2]    ), 
         . \seed[1]     (seed[1]    ), 
         . \seed[0]     (seed[0]    )  
         . \rand[31]    (rand[31]   ),   
         . \rand[30]    (rand[30]   ), 
         . \rand[29]    (rand[29]   ), 
         . \rand[28]    (rand[28]   ), 
         . \rand[27]    (rand[27]   ), 
         . \rand[26]    (rand[26]   ), 
         . \rand[25]    (rand[25]   ), 
         . \rand[24]    (rand[24]   ), 
         . \rand[23]    (rand[23]   ), 
         . \rand[22]    (rand[22]   ), 
         . \rand[21]    (rand[21]   ), 
         . \rand[20]    (rand[20]   ), 
         . \rand[19]    (rand[19]   ), 
         . \rand[18]    (rand[18]   ), 
         . \rand[17]    (rand[17]   ), 
         . \rand[16]    (rand[16]   ), 
         . \rand[15]    (rand[15]   ), 
         . \rand[14]    (rand[14]   ), 
         . \rand[13]    (rand[13]   ), 
         . \rand[12]    (rand[12]   ), 
         . \rand[11]    (rand[11]   ), 
         . \rand[10]    (rand[10]   ), 
         . \rand[9]     (rand[9]    ), 
         . \rand[8]     (rand[8]    ), 
         . \rand[7]     (rand[7]    ), 
         . \rand[6]     (rand[6]    ), 
         . \rand[5]     (rand[5]    ), 
         . \rand[4]     (rand[4]    ), 
         . \rand[3]     (rand[3]    ), 
         . \rand[2]     (rand[2]    ), 
         . \rand[1]     (rand[1]    ), 
         . \rand[0]     (rand[0]    ) 
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
			$dumpvars(0,prng32_tb);
		`else
			$dumpfile("prng32.vcd");
			$dumpvars(0,prng32_tb);
		`endif
	end

   task plant;
      input [31:0] value;
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
		plant(32'h88888888);      
      plant(32'h66666666);      
      plant(32'h77777777);      
      plant(32'h00000000);      
      plant(32'hFFFFFFFF);      
      plant(32'h28282828);      
      plant(32'h27340972);      
      plant(32'h23984729);      
      $finish;
	end

endmodule
