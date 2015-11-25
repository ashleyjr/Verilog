module pwm_in_tb;

	parameter CLK_PERIOD = 20;

	reg         clk;
	reg         nRst;
   reg         pwm_clk;
   reg   [7:0] duty_in;
   reg         update;
   wire        out;
   wire        valid;
   wire  [7:0] duty_out;
	
   reg   [7:0] i;
   
   pwm_out pwm_out(
		.clk	      (clk     ),
		.nRst	      (nRst    ),
	   .pwm_clk    (pwm_clk ),
      .duty       (duty_in ),
      .update     (update  ),
      .out        (out     ) 
   );

   pwm_in pwm_in(
      .clk        (clk     ),
      .nRst       (nRst    ),
      .in         (out     ),
      .valid      (valid   ),
      .duty       (duty_out)
   );



	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	
   end

	initial begin
		$dumpfile("pwm_in.vcd");
		$dumpvars(0,pwm_in_tb);
	end
 
   initial begin
		while(1) begin
			#(5000/2) pwm_clk = 0;
			#(5000/2) pwm_clk = 1;
		end	
   end


	initial begin

               duty_in     = 8'd0;
               update   = 1'b0;
					nRst     = 1;
		
      #100		nRst     = 0;
		#100		nRst     = 1;
    
      i = 128;
      repeat(10) begin
         #1000000   duty_in     = i;
         #100     update   = 1'b1;
         #100     update   = 1'b0;
         i = i + 1;
      end
      
      
      #100000

      
      
      $finish;
	end

endmodule
