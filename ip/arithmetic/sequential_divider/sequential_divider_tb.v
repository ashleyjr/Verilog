`timescale 1ns/1ps
module sequential_divider_tb;

	parameter CLK_PERIOD = 20;

   parameter   DATA_WIDTH  = 64;
	reg	                  i_clk;
	reg	                  i_nrst;
	reg   [DATA_WIDTH-1:0]  i_n;
   reg   [DATA_WIDTH-1:0]  i_d;
   wire  [DATA_WIDTH-1:0]  o_q;
   reg                     i_valid;
   wire                    o_accept;
   
   sequential_divider #(
      .DATA_WIDTH (DATA_WIDTH ) 
   ) sequential_divider(
		.i_clk	   (i_clk      ),
		.i_nrst	   (i_nrst     ),
	   .i_n        (i_n        ),
      .i_d        (i_d        ),
      .o_q        (o_q        ),
      .i_valid    (i_valid    ),
      .o_accept   (o_accept   )
   
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
			$dumpfile("sequential_divider.vcd");
			$dumpvars(0,sequential_divider_tb);
		$display("                  TIME    nrst");		$monitor("%tps       %d",$time,i_nrst);
	end

   task request_divide; 
      input    [DATA_WIDTH-1:0]  n;
      input    [DATA_WIDTH-1:0]  d;
      reg      [DATA_WIDTH-1:0]  test;
      begin
         i_d      = d;
         i_n      = n;
         i_valid  = 1'b1;
         while(o_accept == 1'b0)
            @(posedge i_clk);

         test = n / d;
         $display("%tps\t%d /\t%d =\t%d\t(TB =\t%d)",
               $time,
               i_n,
               i_d,
               o_q,
               test);		

         if(test != o_q) begin
            $error("Incorrect division");
            #777
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

      repeat(100) begin
         request_divide($random, $random);
      end

      #777
      $finish;
	end
endmodule
