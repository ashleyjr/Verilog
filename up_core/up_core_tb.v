module up_core_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            int;
   reg            load;
   reg            mem_map_load;
   reg   [7:0]    mem_map_in;
   wire  [7:0]    mem_map_out;

	up_core up_core(
		.clk	            (clk              ),
		.nRst	            (nRst             ),
	   .int              (int              ),
      .mem_map_load     (mem_map_load     ),
      .mem_map_in       (mem_map_in     ), 
      .mem_map_out      (mem_map_out    ) 
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
              
               mem_map_load   = 0;
               mem_map_in     = 8'hAA;
               
         
               nRst = 0;
      for(i=0;i<256;i=i+1) up_core_tb.up_core.mem[i] = code[i];  
      #1000 nRst = 1;
                  mem_map_load = 1;
      #100      mem_map_load = 0;     
      
      #10000   
      for(i=0;i<256;i=i+1) begin
         #1000 int = 0;
         #1000 int = 1;
      end
      #100000 nRst = 1;
      $finish;
	end

endmodule
