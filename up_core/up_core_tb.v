module up_core_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            int;
   reg            load;
   reg   [7:0]    mem_in;
   wire  [7:0]    mem_out;
   wire  [7:0]    map_01;


	up_core up_core(
		.clk	   (clk        ),
		.nRst	   (nRst       ),
	   .int     (int        ),
      .load    (load       ),
      .mem_in  (mem_in     ),
      .mem_out (mem_out    ),
      .map_01  (map_01     )
   );

   integer i;
   reg   [7:0] code [255:0];

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up_core.vcd");
		$dumpvars(0,up_core_tb);
      for(i=0;i<256;i=i+1) $dumpvars(0,up_core_tb.up_core.mem[i]); 
      for(i=0;i<256;i=i+1) $dumpvars(0,up_core_tb.code[i]); 
      $readmemh("../up/code/_code.hex",code); 
   end

	initial begin
				   int      = 1;
               load     = 0;
               nRst     = 1;
		#100		nRst     = 0;
		#100		nRst     = 1;
		#10000

      #100     load     = 1;
	  
      #5
      for(i=0;i<256;i=i+1) begin
         #20   mem_in   = code[255-i]; 
      end
     
      #20      load     = 0;
      #100
      for(i=0;i<256;i=i+1) begin
         #1000 int = 0;
         #1000 int = 1;
      end
      $finish;
	end

endmodule
