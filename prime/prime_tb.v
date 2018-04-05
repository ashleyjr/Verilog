`timescale 1ns/1ps
module prime_tb;

	parameter CLK_PERIOD = 20;

	reg	         i_clk;
	reg	         i_nrst;
   reg            i_valid;
   wire           o_accept;
   wire  [31:0]   o_prime;
	
	prime prime(
	   .i_clk      (i_clk      ),
      .i_nrst     (i_nrst     ),
      .i_valid    (i_valid    ),
      .o_accept   (o_accept   ),
      .o_prime    (o_prime    )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
      $dumpfile("prime.vcd");
      $dumpvars(0,prime_tb);
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
					i_nrst		= 1;
               i_valid     = 0;
		#17		i_nrst		= 0;
		#17		i_nrst		= 1;

      #777     
      repeat(100) begin
               i_valid     = 1;
               while(!o_accept)
                  @(posedge i_clk);
      end
		#100000
		$finish;
	end

endmodule
