module watchdog(
	input	         clk,
	input	         nRst,
   input [31:0]   time_ns,
   input          pet,
   output reg     woof
);

   parameter CLK_HZ  = 32'd50000000;

   reg   hit_last;
   wire  hit;
   
   timer timer(
      .clk              (clk              ),
      .nRst             (~pet & nRst      ),
      .period_ns        (time_ns          ),
      .clk_frequency_hz (CLK_HZ           ),
      .hit              (hit              )
   );

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
	      woof     <= 1'b0;
         hit_last <= 1'b0;
		end else begin
         hit_last <= hit;                    // Rising edge on hit trigger a woof
         if(hit & ~hit_last)  woof <= 1'b1;
         if(pet)              woof <= 1'b0;  // Pet at anytime will stop a woof
     end
	end
endmodule
