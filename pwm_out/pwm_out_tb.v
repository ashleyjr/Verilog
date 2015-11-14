module pwm_out_tb;

	parameter CLK_PERIOD = 20;

	reg   clk;
	reg   nRst;
   reg   sclk;
   reg   sin;
   reg   sen;
   wire  out;
	
   integer j,k;
   
   pwm_out pwm_out(
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
		$dumpfile("pwm_out.vcd");
		$dumpvars(0,pwm_out_tb);
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
            #3   sclk = 1;
            #3   sclk = 0;
         end
         for(i=31;i>=0;i=i-1) begin
                  sin = duty[i];
            #3   sclk = 1;
            #3   sclk = 0;     
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
	

      for(j=100;j<120;j=j+1) begin
         for(k=0;k<j;k=k+1) begin
            #1000 set(j,k);
         end
      end
      #100000

      
      
      $finish;
	end

endmodule
