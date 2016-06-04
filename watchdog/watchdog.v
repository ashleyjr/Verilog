module watchdog(
	input	         clk,
	input	         nRst,
   input [31:0]   time_ns,
   input          pet,
   output reg     woof
);

   parameter CLK_HZ  = 32'd50000000;

   reg   petted;
   wire  hit;
   
   timer timer(
      .clk              (clk              ),
      .nRst             (nRst             ),
      .period_ns        (time_ns          ),
      .clk_frequency_hz (CLK_HZ           ),
      .hit              (hit              )
   );

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
	      woof <= 1'b0;
		end else begin
         if(hit) begin
            if(petted) begin
               woof     <= 1'b0;
               petted   <= 1'b0;
            end else begin
               woof <= 1'b1;
            end
         end else begin
            if(pet) begin
               petted   <= 1'b1;
               woof     <= 1'b0;
            end
         end 
		end
	end
endmodule
