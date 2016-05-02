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
      end
   endtask

   task test_code;
      begin
                           int            = 1; 
                           load_mem(9'd256,8'h00);    // soft reset
                           load_mem(9'd4,8'h98);      // put into loop  
                           for(i=5;i<256;i=i+1)       // Load all above loop    
                              load_mem(i,code[i]);
                           for(i=0;i<4;i=i+1)         // Load below loop    
                              load_mem(i,code[i]);
                           load_mem(9'd256,8'h00);    // soft reset
                           load_mem(9'd4,code[4]);    // replace the loop

         repeat(20) begin
            #10000         int = 0; 
            #10000         int = 1;
         end
         #10000            int = 0;
      end
   endtask
	
   initial begin
      #100  nRst = 1;
      #100  nRst = 0;
      #100  nRst = 1;
      $readmemh("code/all_ops.hex",code); 
      test_code();
      $readmemh("code/fin.hex",code); 
      test_code(); 
      $readmemh("code/for_loop.hex",code); 
      test_code(); 
      $readmemh("code/isr_copy.hex",code); 
      test_code(); 
      $readmemh("code/subroutines.hex",code); 
      test_code(); 

      $finish;
	end

endmodule
