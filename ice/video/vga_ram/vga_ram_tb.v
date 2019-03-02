`timescale 1ns/1ps
module vga_ram_tb;
   
   parameter CLK_PERIOD    = 83; // 12Mhz
   parameter BAUD_PERIOD   = 1000;

	reg	      i_clk;
	reg	      i_nrst;
   wire        o_hs;
   wire        o_vs;
   wire  [1:0] o_r;
   wire  [1:0] o_g;
   wire  [1:0] o_b;
   reg         i_rx;	

   vga_ram vga_ram(
		.i_clk	(i_clk   ),
		.i_nrst	(i_nrst  ),
	   .o_hs    (o_hs    ),
      .o_vs    (o_vs    ),
      .o_r     (o_r     ),
      .o_g     (o_g     ),
      .o_b     (o_b     ),
      .i_rx    (i_rx    )
   );
	
   initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         i_rx = 0;
         for(i=0;i<=7;i=i+1) begin    
            #BAUD_PERIOD i_rx = send[i];
         end 
         #BAUD_PERIOD i_rx = 1;
      end
   endtask


	initial begin
	   $dumpfile("vga_ram.vcd");
	   $dumpvars(0,vga_ram_tb);
		$display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,i_nrst);
	end
	
   initial begin
               i_rx        = 1;
					i_nrst		= 1;	
		#177		i_nrst		= 0;
		#17		i_nrst		= 1;
		
      #50000   uart_send(8'b01010101);
      #50000   uart_send(8'b01010101);
      
      repeat(20) 
         #2000 uart_send(8'b00000001); 

      uart_send(8'b10000011); 
      repeat(80) 
         #200000 uart_send(8'b10000010); 

		#30000	
      $finish;
	end

endmodule
