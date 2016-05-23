module up_tb;

	parameter CLK_PERIOD = 20;

	reg            clk;
	reg            nRst;
   reg            int;
   reg            load;
   reg            mem_map_load;
   reg   [8:0]    mem_map_address;
   reg   [7:0]    mem_map_in;
   wire  [7:0]    mem_map_out;

	up up(
		`ifdef POST_SYNTHESIS
         .clk	                  (clk                 ),
		   .nRst	                  (nRst                ),
	      .int                    (int                 ),
         .mem_map_load           (mem_map_load        ), 
         . \mem_map_address[0]   (mem_map_address[0]  ),
         . \mem_map_address[1]   (mem_map_address[1]  ),
         . \mem_map_address[2]   (mem_map_address[2]  ),
         . \mem_map_address[3]   (mem_map_address[3]  ),
         . \mem_map_address[4]   (mem_map_address[4]  ),
         . \mem_map_address[5]   (mem_map_address[5]  ),
         . \mem_map_address[6]   (mem_map_address[6]  ),
         . \mem_map_address[7]   (mem_map_address[7]  ),
         . \mem_map_in[0]        (mem_map_in[0]       ),
         . \mem_map_in[1]        (mem_map_in[1]       ),
         . \mem_map_in[2]        (mem_map_in[2]       ),
         . \mem_map_in[3]        (mem_map_in[3]       ),
         . \mem_map_in[4]        (mem_map_in[4]       ),
         . \mem_map_in[5]        (mem_map_in[5]       ),
         . \mem_map_in[6]        (mem_map_in[6]       ),
         . \mem_map_in[7]        (mem_map_in[7]       ),
         . \mem_map_out[0]       (mem_map_out[0]      ),
         . \mem_map_out[1]       (mem_map_out[1]      ),
         . \mem_map_out[2]       (mem_map_out[2]      ),
         . \mem_map_out[3]       (mem_map_out[3]      ),
         . \mem_map_out[4]       (mem_map_out[4]      ),
         . \mem_map_out[5]       (mem_map_out[5]      ),
         . \mem_map_out[6]       (mem_map_out[6]      ),
         . \mem_map_out[7]       (mem_map_out[7]      )
      `else
         .clk	                  (clk                 ),
		   .nRst	                  (nRst                ),
	      .int                    (int                 ),
         .mem_map_load           (mem_map_load        ),
         .mem_map_address        (mem_map_address     ),
         .mem_map_in             (mem_map_in          ), 
         .mem_map_out            (mem_map_out         ) 
      `endif
   );

   integer i;
   reg   [7:0] code [255:0];

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end
   
   initial begin
      `ifdef POST_SYNTHESIS
         $dumpfile("up_syn.vcd");  
         $dumpvars(0,up_tb);
      `else
         $dumpfile("up.vcd");
         $dumpvars(0,up_tb);
         for(i=0;i<256;i=i+1) $dumpvars(0,up_tb.up.mem[i]); 
         for(i=0;i<256;i=i+1) $dumpvars(0,up_tb.code[i]);  
         $display("--------------|TIME|-------|FIB|-------       ");
         $monitor("%d         %d",$time,up_tb.up.mem[127]);
      `endif
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

   task load_code;
      begin
         load_mem(9'd256,8'h00);    // soft reset
         load_mem(9'd4,8'h98);      // put into loop  
         for(i=5;i<256;i=i+1)       // Load all above loop    
         load_mem(i,code[i]);
         for(i=0;i<4;i=i+1)         // Load below loop    
         load_mem(i,code[i]);
         load_mem(9'd256,8'h00);    // soft reset
         load_mem(9'd4,code[4]);    // replace the loop
      end
   endtask
	
   initial begin
                        nRst              = 1;
                        int               = 1;
                        mem_map_load      = 0;
      #(CLK_PERIOD*2)   nRst              = 0;
      #(CLK_PERIOD*2)   nRst              = 1;
      
     
      /////////////
      // ALL OPS //
      /////////////
      $display("\n\n\n--- ALL OPS ---");
      $readmemh("code/all_ops.hex",code); 
      load_code();
      #10000

      /////////
      // FIB //
      /////////
      $display("\n\n\n--- FIB ---");
      $readmemh("code/fib.hex",code); 
      load_code();
      int = 0;
      #(CLK_PERIOD*30)                                   // Wait for setup to complete
      repeat(10) begin                                   // Do the first 10 interrupts fast
         #(CLK_PERIOD*45)     int = 1;                   // 1,2,3,5,8,13,21,34,55,89
         #(CLK_PERIOD*45)     int = 0;
      end
      #(CLK_PERIOD*45)        int = 1;                   // 144
      #(CLK_PERIOD*1000)      int = 0;
      #(CLK_PERIOD*1000)      int = 1;                   // 233
      #(CLK_PERIOD*1000)      int = 0;
      #(CLK_PERIOD*1000)      int = 1;                   // Over flow
      #(CLK_PERIOD*1000)
      
      
      //////////////
      // FOR LOOP //
      //////////////
      $display("\n\n\n--- FOR LOOP ---");
      $readmemh("code/for_loop.hex",code); 
      load_code(); 
      #10000

      //////////////
      // ISR COPY //
      //////////////
      $display("\n\n\n--- ISR COPY ---");
      $readmemh("code/isr_copy.hex",code); 
      load_code(); 
      #10000

      /////////////////
      // SUBROUTINES //
      /////////////////
      $display("\n\n\n--- SUBROUTINES ---");
      $readmemh("code/subroutines.hex",code); 
      load_code(); 
      #10000


      ////////////
      // RANDOM //
      ////////////
      $display("\n\n\n--- RANDOM ---");
      $readmemh("code/rand.hex",code); 
      load_code(); 
      #1000000


      #10000
      $finish;
	end

endmodule
