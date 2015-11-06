
module fir_filter_tb;
   
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter SAMPLE_PERIOD_LOW = 60;

   reg            clk;
   reg            nRst;
   reg            sample;
   reg            coeffs_shift;
   reg   [31:0]   data_in;
   reg   [7:0]    coeffs_in;
   wire  [31:0]   data_out;
   wire  [7:0]    coeffs_out;
      
   fir_filter fir_filter(
      .clk           (clk           ),
      .nRst          (nRst          ),
      .sample        (sample        ),
      .coeffs_shift  (coeffs_shift  ),
      .data_in       (data_in       ),
      .coeffs_in     (coeffs_in     ),
      .data_out      (data_out      ),
      .coeffs_out    (coeffs_out    )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

   initial begin
      while(1) begin
         #(SAMPLE_PERIOD_LOW) sample = 1;
         #(CLK_PERIOD)        sample = 0;
      end
   end


	initial begin
      $dumpfile("fir_filter.vcd");
      $dumpvars(0,fir_filter_tb);
   end

   reg [31:0] file_in [255:0];
   reg [7:0] i; 
   reg [7:0] j;
   reg [7:0] k;
   initial begin
               $readmemh("sine.hex",file_in);
      #100     nRst     = 1;
      #100     nRst     = 0;
      #50      nRst     = 1;

               for(i=0;i<30;i=i+1)begin
                coeffs_in = 8'b1;
                  #100  coeffs_shift = 1;
                  #20   coeffs_shift = 0;
               end


               for(i=0;i<50;i=i+1) begin
                  for(j=0;j<255;j=j+1) begin
                     for(k=0;k<i;k=k+1) begin
                        #1;
                     end
                     data_in = file_in[j];
                  end
               end
      $finish;
	end





endmodule

