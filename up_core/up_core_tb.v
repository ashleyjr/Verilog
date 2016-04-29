module up_core_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            int;
   reg            load;
   reg            mem_map_load;
   reg   [8:0]    mem_map_address;
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
   end

   task load_mem;
      input [8:0] address;
      input [7:0] data;
      begin
                           mem_map_address   = address;
                           mem_map_in        = data;
         #(CLK_PERIOD*2)   mem_map_load      = 1;  
         #(CLK_PERIOD*2)   mem_map_load      = 0;
                           mem_map_address   = 9'd256;
         #(CLK_PERIOD*2)   mem_map_load      = 1;  
         #(CLK_PERIOD*2)   mem_map_load      = 0;
      end
   endtask

   task test_code;
      begin
                           int            = 1;
                           mem_map_load   = 0;
                           mem_map_in     = 8'h00;
                           nRst           = 0;
         #1000             nRst           = 1;
         #1000             for(i=0;i<256;i=i+1)     
                              load_mem(i,code[i]);
         #1000             load_mem(9'd256,8'h00); // Soft reset
         repeat(20) begin
            #10000         int = 0; 
            #10000         int = 1;
         end
         #10000            int = 0;
      end
   endtask
	
   initial begin 
      $readmemh("code/fib.hex",code); 
      test_code();
      $readmemh("code/for_loop.hex",code); 
      test_code(); 
      $readmemh("code/isr_copy.hex",code); 
      test_code(); 
      $finish;
	end

endmodule
