module up_memory_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg   [7:0] in;
   reg   [7:0] address;
   reg         we;
   wire  [7:0] out;
   wire        re;

	up_memory up_memory(
		.clk	      (clk     ),
		.nRst	      (nRst    ),
      .in         (in      ),
      .address    (address ),
      .we         (we      ),
      .out        (out     ),
	   .re         (re      )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_memory.vcd");
		$dumpvars(0,up_memory_tb);
	end

	initial begin
					nRst     = 1;
		         in       = 8'h00;
               address  = 8'h00;
               we       = 0;
      #100		nRst     = 0;
		#100		nRst     = 1;
   


      // Write
      #100     address  = 8'hFF;
      #100     in       = 8'hAA;
      #100     we       = 1;
      #100     we       = 0;  
     
      #100     address  = 8'hAA;
      #100     in       = 8'hFF;
      #100     we       = 1;
      #100     we       = 0;  

      #100     address  = 8'h00;
      #100     in       = 8'h01;
      #100     we       = 1;
      #100     we       = 0;  
 
      #100     address  = 8'h01;
      #100     in       = 8'h02;
      #100     we       = 1;
      #100     we       = 0;  
 
		$finish;
	end

endmodule
