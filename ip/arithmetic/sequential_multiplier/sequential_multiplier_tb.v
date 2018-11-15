`timescale 1ns/1ps
module sequential_multiplier_tb;

	parameter   CLK_PERIOD        = 20,
               DATA_WIDTH_A      = 64,
               DATA_WIDTH_B      = 64,
               DATA_WIDTH_C_TB   = 128;

	reg	                        i_clk;
	reg	                        i_nrst;
   reg   [DATA_WIDTH_A-1:0]      i_a;
   reg   [DATA_WIDTH_B-1:0]      i_b;
   wire  [DATA_WIDTH_C_TB-1:0]   o_c;
   reg                           i_valid;
   wire                          o_accept;

	sequential_multiplier #(
      .DATA_WIDTH_A  (DATA_WIDTH_A  ),
      .DATA_WIDTH_B  (DATA_WIDTH_B  )
   ) shift_and_add_multiplier(
      .i_clk         (i_clk         ),
      .i_nrst        (i_nrst        ),
      .i_a           (i_a           ),
      .i_b           (i_b           ),
      .o_c           (o_c           ),
      .i_valid       (i_valid       ),
      .o_accept      (o_accept      )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
		$dumpfile("sequential_multiplier.vcd");
		$dumpvars(0,sequential_multiplier_tb);
		$display("                  TIME");	
	end


   task request_multiply; 
      input    [DATA_WIDTH_A-1:0]      a;
      input    [DATA_WIDTH_B-1:0]      b;
      reg      [DATA_WIDTH_C_TB-1:0]   test;
      begin
         i_a      = a;
         i_b      = b;
         i_valid  = 1'b1;
         while(o_accept == 1'b0)
            @(posedge i_clk);

         test = a * b;
         $display("%tps\t%x *\t%x =\t%x\t(TB =\t%x)",
               $time,
               i_a,
               i_b,
               o_c,
               test);		

         if(test != o_c) begin
            $error("Incorrect multiplication");
            $finish;
         end
         i_valid  = 1'b0;
         @(posedge i_clk);
      end
   endtask

	initial begin
	         i_nrst   = 1;
            i_valid  = 0;
      #77   i_nrst   = 0;
      #77   i_nrst   = 1;
      #777

      request_multiply(0,0);
      repeat(100) begin
         request_multiply($urandom,0);
         request_multiply(0,$urandom);
      end
      repeat(100) begin
         request_multiply($urandom,1);
         request_multiply(1,$urandom);
      end
      repeat(1000) begin
         request_multiply($random, $random);
      end

      $finish;
	end

endmodule

