module up_core_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            int;
   reg            load;
   reg            mem_map_load;
   reg   [7:0]    mem_map_address;
   reg   [7:0]    mem_map_in;
   wire  [7:0]    mem_map_out;

	up_core up_core(
		.clk	            (clk              ),
		.nRst	            (nRst             ),
	   .int              (int              ),
      .mem_map_load     (mem_map_load     ),
      .mem_map_address  (mem_map_address  ),
      .mem_map_in       (mem_map_in       ), 
      .mem_map_out      (mem_map_out      ) 
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

   task load_mem;
      input [7:0] address;
      input [7:0] data;
      begin
         #(CLK_PERIOD*3)   mem_map_load      = 1;
         #(CLK_PERIOD*3)   mem_map_address   = address;
         #(CLK_PERIOD*3)   mem_map_in        = data;
         #(CLK_PERIOD*3)   mem_map_load      = 0;
      end
   endtask
	initial begin 
      
                           int            = 1;
                           mem_map_load   = 0;
                           mem_map_in     = 8'h00;
                           nRst           = 0;
      #1000                nRst           = 1;
      #1000                for(i=0;i<256;i=i+1)     
                              load_mem(i,code[i]);
      
      #10000   
      $finish;
	end

endmodule
