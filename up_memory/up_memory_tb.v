module up_memory_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg         prog;
   reg   [7:0] in;
   reg   [7:0] address;
   reg         we;
   reg   [7:0] load_in;
   reg         busy_tx;
   reg         recived;
   wire  [7:0] out;
   wire        re;
   wire        transmit;
   wire  [7:0] load_out;
   wire  [7:0] leds;

	up_memory up_memory(
		.clk	      (clk        ),
		.nRst	      (nRst       ),
      .prog       (prog       ),
      .in         (in         ),
      .address    (address    ),
      .we         (we         ),
      .load_in    (load_in    ),
      .busy_tx    (busy_tx    ),
      .recived    (recived    ),
      .out        (out        ),
	   .re         (re         ),
      .transmit   (transmit   ),
      .load_out   (load_out   ),
      .leds       (leds       )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	
   end

   integer idx;

	initial begin
		$dumpfile("up_memory.vcd");
		$dumpvars(0,up_memory_tb);
	   for (idx = 0; idx < 256; idx = idx + 1) $dumpvars(0,up_memory_tb.up_memory.mem[idx]);
   end
	
   initial begin
					nRst     = 1'b1;
		         prog     = 1'b0;
               in       = 8'h00;
               address  = 8'h00;
               we       = 1'b0;
               load_in  = 8'h00;
               busy_tx  = 1'b0;
               recived  = 1'b0;
               
      #100		nRst     = 1'b0;
		#100		nRst     = 1'b1;
  
      #1000    load_in  = 8'hAA;
      #1000    prog     = 1'b1;
      #1000    recived  = 1'b1;

      #10000   prog     = 1'b0;
      #10000
		$finish;
	end

endmodule
