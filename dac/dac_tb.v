module dac_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   wire  [7:0] out;

   integer  i;
   real     analog;

	dac dac(
		.clk	(clk),
		.nRst	(nRst),
	   .out  (out)
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("dac.vcd");
		$dumpvars(0,dac_tb);
	end

	initial begin
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;
	

      for(i=0;i<10000;i=i+1) begin
         #1 analog = 0;
            if(out[0]) analog = analog + 0.01289;
            if(out[1]) analog = analog + 0.02578;
            if(out[2]) analog = analog + 0.05156;
            if(out[3]) analog = analog + 0.10312;
            if(out[4]) analog = analog + 0.20625;
            if(out[5]) analog = analog + 0.41250;
            if(out[6]) analog = analog + 0.82500;
            if(out[7]) analog = analog + 1.65000;

      end
      #10000
		$finish;
	end

endmodule
