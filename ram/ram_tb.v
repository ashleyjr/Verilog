`timescale 1ns/1ps
module ram_tb;

	parameter WCLK_PERIOD = 23;
   parameter RCLK_PERIOD = 17;

	reg         wclk;
   reg         rclk;
   reg   [7:0] wdata;
   wire  [7:0] rdata;
   reg   [8:0] waddr;
   reg   [8:0] raddr;
   reg         we;
   reg         re;

	ram ram(
      .i_wclk     (wclk    ),
      .i_waddr    (waddr   ),
      .i_we       (we      ),
      .i_wdata    (wdata   ),
      .i_rclk     (rclk    ),
      .i_raddr    (raddr   ),
      .i_re       (re      ),
      .o_rdata    (rdata   )
	);

	initial begin
		while(1) begin
			#(WCLK_PERIOD/2) wclk = 0;
			#(WCLK_PERIOD/2) wclk = 1;
		end
	end

   initial begin
		while(1) begin
			#(RCLK_PERIOD/2) rclk = 0;
			#(RCLK_PERIOD/2) rclk = 1;
		end
	end

   integer i;

   initial begin
		$dumpfile("ram.vcd");
		$dumpvars(0,ram_tb);	
	   for(i=0;i<512;i=i+1) 
         $dumpvars(0,ram.mem[i]); 
   end

	initial begin
	   repeat(1000) begin
         #10   wdata = $random;
         #10   waddr = $random; 
         #10   raddr = $random;
         #10   we    = $random;
         #10   re    = $random;
      end
		$finish;
	end

endmodule
