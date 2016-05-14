module prng_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            update;
   reg            reseed;
   reg   [31:0]   seed;
   wire  [7:0]    rand8_0;
   wire  [7:0]    rand8_1;
   wire  [31:0]   rand32;

	
   prng #(8,4,5) prng_0(
			`ifdef POST_SYNTHESIS
			.clk	      (clk        ),
			.nRst	      (nRst       ),
		   .update     (update     ),
         .reseed     (reseed     ),
         . \seed[7]  (seed[7]    ),
         . \seed[6]  (seed[6]    ),
         . \seed[5]  (seed[5]    ),
         . \seed[4]  (seed[4]    ),
         . \seed[3]  (seed[3]    ),
         . \seed[2]  (seed[2]    ),
         . \seed[1]  (seed[1]    ),
         . \seed[0]  (seed[0]    ),
         . \rand[7]  (rand[7]    ),
         . \rand[6]  (rand[6]    ),
         . \rand[5]  (rand[5]    ),
         . \rand[4]  (rand[4]    ),
         . \rand[3]  (rand[3]    ),
         . \rand[2]  (rand[2]    ),
         . \rand[1]  (rand[1]    ),
         . \rand[0]  (rand[0]    )
      `else
			.clk	      (clk        ),
			.nRst	      (nRst       ),
         .update     (update     ),
         .reseed     (reseed     ),
		   .seed       (seed[7:0]  ),
         .rand       (rand8_0    )
      `endif		
   );



   prng #(8,6,2) prng_1(
			`ifdef POST_SYNTHESIS
			.clk	      (clk        ),
			.nRst	      (nRst       ),
		   .update     (update     ),
         .reseed     (reseed     ),
         . \seed[7]  (seed[7]    ),
         . \seed[6]  (seed[6]    ),
         . \seed[5]  (seed[5]    ),
         . \seed[4]  (seed[4]    ),
         . \seed[3]  (seed[3]    ),
         . \seed[2]  (seed[2]    ),
         . \seed[1]  (seed[1]    ),
         . \seed[0]  (seed[0]    ),
         . \rand[7]  (rand[7]    ),
         . \rand[6]  (rand[6]    ),
         . \rand[5]  (rand[5]    ),
         . \rand[4]  (rand[4]    ),
         . \rand[3]  (rand[3]    ),
         . \rand[2]  (rand[2]    ),
         . \rand[1]  (rand[1]    ),
         . \rand[0]  (rand[0]    )
      `else
			.clk	      (clk        ),
			.nRst	      (nRst       ),
         .update     (update     ),
         .reseed     (reseed     ),
		   .seed       (seed[7:0]  ),
         .rand       (rand8_1    )
      `endif		
   );


   prng #(32,16,12) prng_2(
			`ifdef POST_SYNTHESIS
			.clk	         (clk           ),
			.nRst	         (nRst          ),
		   .update        (update        ),
         .reseed        (reseed        ), 
         . \seed[31]    (seed[31]      ),
         . \seed[30]    (seed[30]      ),
         . \seed[28]    (seed[29]      ),
         . \seed[28]    (seed[28]      ),
         . \seed[27]    (seed[27]      ),
         . \seed[26]    (seed[26]      ),
         . \seed[25]    (seed[25]      ),
         . \seed[24]    (seed[24]      )
         . \seed[23]    (seed[23]      ),
         . \seed[22]    (seed[22]      ),
         . \seed[21]    (seed[21]      ),
         . \seed[20]    (seed[20]      ),
         . \seed[19]    (seed[19]      ),
         . \seed[18]    (seed[18]      ),
         . \seed[17]    (seed[17]      ),
         . \seed[16]    (seed[16]      ),
         . \seed[15]    (seed[15]      ),
         . \seed[14]    (seed[14]      ),
         . \seed[13]    (seed[13]      ),
         . \seed[12]    (seed[12]      ),
         . \seed[11]    (seed[11]      ),
         . \seed[10]    (seed[10]      ),
         . \seed[9]     (seed[9]       ),
         . \seed[8]     (seed[9]       )
         . \seed[7]     (seed[7]       ),
         . \seed[6]     (seed[6]       ),
         . \seed[5]     (seed[5]       ),
         . \seed[4]     (seed[4]       ),
         . \seed[3]     (seed[3]       ),
         . \seed[2]     (seed[2]       ),
         . \seed[1]     (seed[1]       ),
         . \seed[0]     (seed[0]       )
         . \rand[31]    (rand[31]      ),
         . \rand[30]    (rand[30]      ),
         . \rand[28]    (rand[29]      ),
         . \rand[28]    (rand[28]      ),
         . \rand[27]    (rand[27]      ),
         . \rand[26]    (rand[26]      ),
         . \rand[25]    (rand[25]      ),
         . \rand[24]    (rand[24]      )
         . \rand[23]    (rand[23]      ),
         . \rand[22]    (rand[22]      ),
         . \rand[21]    (rand[21]      ),
         . \rand[20]    (rand[20]      ),
         . \rand[19]    (rand[19]      ),
         . \rand[18]    (rand[18]      ),
         . \rand[17]    (rand[17]      ),
         . \rand[16]    (rand[16]      ),
         . \rand[15]    (rand[15]      ),
         . \rand[14]    (rand[14]      ),
         . \rand[13]    (rand[13]      ),
         . \rand[12]    (rand[12]      ),
         . \rand[11]    (rand[11]      ),
         . \rand[10]    (rand[10]      ),
         . \rand[9]     (rand[9]       ),
         . \rand[8]     (rand[9]       )
         . \rand[7]     (rand[7]       ),
         . \rand[6]     (rand[6]       ),
         . \rand[5]     (rand[5]       ),
         . \rand[4]     (rand[4]       ),
         . \rand[3]     (rand[3]       ),
         . \rand[2]     (rand[2]       ),
         . \rand[1]     (rand[1]       ),
         . \rand[0]     (rand[0]       )
      `else
			.clk	      (clk        ),
			.nRst	      (nRst       ),
         .update     (update     ),
         .reseed     (reseed     ),
		   .seed       (seed       ),
         .rand       (rand32     )
      `endif		
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("prng_syn.vcd");
			$dumpvars(0,prng_tb);
		`else
			$dumpfile("prng.vcd");
			$dumpvars(0,prng_tb);
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
					update   = 1;
               nRst     = 1;
		#100		nRst     = 0;
		#100		nRst     = 1;
		         plant(32'h55555555);      
               plant(32'h66666666);      
               plant(32'h77777777);      
               plant(32'h00000000);      
               plant(32'hFFFFFFFF);      
               plant(32'h34543453);      
               plant(32'hAC234EFA);      
               plant(32'h34534562);    
               update   = 0;      
               plant(32'h55555555);      
               plant(32'h12323122);      
               plant(32'h12313123);
               update   = 1;      
               plant(32'h12312122);      
               plant(32'h66666666);      
               plant(32'h77777777);
               $finish;
	end


   
   endmodule
