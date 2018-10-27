`timescale 1ns/1ps
module ice_ram_2048x16b_tb;

	parameter WCLK_PERIOD = 23;
   parameter RCLK_PERIOD = 17;

   reg            i_nrst;
	reg            i_wclk;
   reg            i_rclk;
   reg   [15:0]   i_wdata;
   wire  [15:0]   o_rdata;
   reg   [10:0]   i_waddr;
   reg   [10:0]   i_raddr;
   reg            i_we;
   reg            i_re;

	ice_ram_2048x16b ice_ram_2048x16b(
      .i_nrst   (i_nrst    ),
      .i_wclk   (i_wclk    ),
      .i_waddr  (i_waddr   ),
      .i_we     (i_we      ),
      .i_wdata  (i_wdata   ),
      .i_rclk   (i_rclk    ),
      .i_raddr  (i_raddr   ),
      .i_re     (i_re      ),
      .o_rdata  (o_rdata   )
   );
      
	initial begin
		while(1) begin
			#(WCLK_PERIOD/2) i_wclk = 0;
			#(WCLK_PERIOD/2) i_wclk = 1;
		end
	end

   initial begin
		while(1) begin
			#(RCLK_PERIOD/2) i_rclk = 0;
			#(RCLK_PERIOD/2) i_rclk = 1;
		end
	end

   integer i;

   initial begin
		$dumpfile("ice_ram_2048x16b.vcd");
		$dumpvars(0,ice_ram_2048x16b_tb);	
	   for(i=0;i<2048;i=i+1) begin
         $dumpvars(0,ice_ram_2048x16b.ram0.mem[i]); 
         $dumpvars(0,ice_ram_2048x16b.ram1.mem[i]); 
         $dumpvars(0,ice_ram_2048x16b.ram2.mem[i]); 
         $dumpvars(0,ice_ram_2048x16b.ram3.mem[i]); 
         $dumpvars(0,ice_ram_2048x16b.ram4.mem[i]); 
         $dumpvars(0,ice_ram_2048x16b.ram5.mem[i]); 
         $dumpvars(0,ice_ram_2048x16b.ram6.mem[i]); 
         $dumpvars(0,ice_ram_2048x16b.ram7.mem[i]); 
      end
   end   

	initial begin
	   repeat(1000) begin
         #10   i_wdata = $random;
         #10   i_waddr = $random; 
         #10   i_raddr = $random;
         #10   i_we    = $random;
         #10   i_re    = $random;
      end
		$finish;
	end

endmodule
