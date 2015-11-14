module pwm_out_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg         pwm_clk;
   reg   [7:0] duty;
   reg         update;
   wire        out;
	
   reg   [7:0] i;
   
   pwm_out pwm_out(
		.clk	      (clk     ),
		.nRst	      (nRst    ),
	   .pwm_clk    (pwm_clk ),
      .duty       (duty    ),
      .update     (update  ),
      .out        (out     ) 
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
 
   initial begin
		while(1) begin
			#(100/2) pwm_clk = 0;
			#(100/2) pwm_clk = 1;
		end	
   end


	initial begin

               duty     = 8'd0;
               update   = 1'b0;
					nRst     = 1;
		
      #100		nRst     = 0;
		#100		nRst     = 1;
    
      i = 0;
      repeat(256) begin
         #100000   duty     = i;
         #100     update   = 1'b1;
         #100     update   = 1'b0;
         i = i + 1;
      end
      
      
      #100000

      
      
      $finish;
	end

endmodule
