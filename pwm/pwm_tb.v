module pwm_tb;

	parameter CLK_PERIOD = 20;

	reg   clk;
	reg   nRst;
   reg   sclk;
   reg   sin;
   reg   sen;
   wire  out;
	
   
   pwm pwm(
		.clk	(clk),
		.nRst	(nRst),
	   .out  (out),
      .sclk (sclk),
      .sin  (sin),
      .sen  (sen) 
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	
   end

	initial begin
		$dumpfile("pwm.vcd");
		$dumpvars(0,pwm_tb);
	end
   
   task set;
      input [31:0] period;
      input [31:0] duty;
      integer i;
      begin
         sen = 1;
         sclk = 0;
         for(i=31;i>=0;i=i-1) begin
                  sin = period[i];
            #30   sclk = 1;
            #30   sclk = 0;
         end
         for(i=31;i>=0;i=i-1) begin
                  sin = duty[i];
            #30   sclk = 1;
            #30   sclk = 0;     
         end
         sen = 0;
      end
   endtask

	initial begin
               sen   = 0;
               sclk  = 0;
               sin   = 0;
					nRst  = 1;
		
      #100		nRst  = 0;
		#100		nRst  = 1;
		
      set(32'h00000010,32'h00000008); 
      #100000
		set(32'h00000100,32'h00000080); 
      #100000
      set(32'h00001000,32'h00000800); 
      #100000

      
      
      $finish;
	end

endmodule
