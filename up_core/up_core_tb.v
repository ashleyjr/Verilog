module up_core_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            int;
   reg            load;
   reg   [8:0]    mem_map_in_0;
   reg   [8:0]    mem_map_in_1;
   reg   [8:0]    mem_map_in_2;
   reg   [8:0]    mem_map_in_3;   
   wire  [7:0]    mem_map_out_0;
   wire  [7:0]    mem_map_out_1;
   wire  [7:0]    mem_map_out_2;
   wire  [7:0]    mem_map_out_3;




	up_core up_core(
		.clk	            (clk              ),
		.nRst	            (nRst             ),
	   .int              (int              ),
      .mem_map_in_0     (mem_map_in_0     ),
      .mem_map_in_1     (mem_map_in_1     ),
      .mem_map_in_2     (mem_map_in_2     ),
      .mem_map_in_3     (mem_map_in_3     ), 
      .mem_map_out_0    (mem_map_out_0    ),
      .mem_map_out_1    (mem_map_out_1    ),
      .mem_map_out_2    (mem_map_out_2    ),
      .mem_map_out_3    (mem_map_out_3    ) 
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
              
               mem_map_in_0 = 0;
               mem_map_in_1 = 0;
               mem_map_in_2 = 0;
               mem_map_in_3 = 0;

               nRst     = 1;
		#100		nRst     = 0;
		#100		nRst     = 1;
		#10005

   
      nRst = 0;
      for(i=0;i<256;i=i+1) up_core_tb.up_core.mem[i] = code[i];  
      #1000 nRst = 1;
      #10000   
      for(i=0;i<256;i=i+1) begin
         #1000 int = 0;
         #1000 int = 1;
      end
      #100000 nRst = 1;
      $finish;
	end

endmodule
