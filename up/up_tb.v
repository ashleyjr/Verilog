module up_tb;

	parameter CLK_PERIOD = 20;
   parameter BAUD_PERIOD = 100;

	integer idx;

	reg         clk;
	reg         nRst;
   reg         prog;
   reg         int;	
   reg         rx;
   wire  [7:0] leds;
   wire        tx;


   up up(
		.clk     (clk     ),
		.nRst    (nRst    ),
	   .prog    (prog    ),
      .int     (int     ), 
      .rx      (rx      ),
      .leds    (leds    ),
      .tx      (tx      )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("up.vcd");
		$dumpvars(0,up_tb);
		for (idx = 0; idx < 256; idx = idx + 1) $dumpvars(0,up_tb.up.up_memory.mem[idx]);
	end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         rx = 0;
         for(i=0;i<=7;i=i+1) begin
            #BAUD_PERIOD rx = send[i];
         end
         #BAUD_PERIOD rx = 1;
      end
   endtask

   reg [8:0] j;
	initial begin
					nRst     = 1;
               rx       = 1; 
		         prog     = 0;
               int      = 0;
      #100		nRst     = 0;
		#10		nRst     = 1;
     
     
      #1000    prog = 1;
               for(j=0;j<257;j=j+1) begin
                  #500  uart_send(j[7:0]); 
               end

      #100     prog = 0;

      #100000
      $finish;
	end

endmodule
