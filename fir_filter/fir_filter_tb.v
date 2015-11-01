
module fir_filter_tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD_1 = 8700;
   parameter BAUD_PERIOD_2 = 100;

   reg            clk;
   reg            nRst;
   reg   [31:0]   in;
   wire  [31:0]   out;
   reg            sample;
      
   fir_filter fir_filter(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .in         (in         ),
      .out        (out        ),
      .sample     (sample     )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
      $dumpfile("fir_filter.vcd");
      $dumpvars(0,fir_filter_tb);
   end

   reg [31:0] data_in [255:0];
   reg [7:0] i; 
   reg [7:0] j;
   reg [7:0] k;
   initial begin
               $readmemh("sine.hex",data_in);
               sample   = 1;
      #100     nRst     = 1;
      #100     nRst     = 0;
      #50      nRst     = 1;
               for(i=0;i<50;i=i+1) begin
                  for(j=0;j<255;j=j+1) begin
                     for(k=0;k<i;k=k+1) begin
                        #1;
                     end
                     in = data_in[j];
                  end
               end
      $finish;
	end





endmodule

