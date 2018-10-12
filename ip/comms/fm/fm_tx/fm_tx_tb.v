`timescale 10ns/1ps
module fm_tx_tb;

	parameter CLK_PERIOD = 5208;  // 192MHz

	reg	         clk;
	reg	         nrst;
   reg   [32-1:0] shift;
	wire	         fm;

	fm_tx #(
      .p_hz_sz    (32            )
   ) fm_tx(
		.i_clk	   (clk           ),
		.i_nrst	   (nrst          ),
	   .i_clk_hz   (32'd192000000 ),
      .i_base_hz  (32'd090000000 ),
      .i_shift_hz (shift         ),
      .o_fm       (fm            )
   );

   integer  period,
            freq_khz,
            samples,
            period_acc,
            avg_freq_khz;
   reg      fm_last;

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("fm_tx.vcd");
		$dumpvars(0,fm_tx_tb);
		$display("                  TIME                 freq (Khz)       Avg freq (Khz)");		 
      $monitor("%tps       %d\t%d",$time, freq_khz, avg_freq_khz); 
   end

   initial begin
      period         = 0;
      fm_last        = 0;
      freq_khz       = 0;
      samples        = 0;
      period_acc     = 0;
      avg_freq_khz   = 0;
      forever begin
         #10

         // Rising edge
         if(2'b10 == {fm_last,fm}) begin 
            freq_khz       = 1e9/period; 
            samples        = samples + 1;
            period_acc     = period_acc + period;
            avg_freq_khz   = (1e9*samples) / period_acc;
            period         = 0; 
         end else begin
            period   = period + 10;
         end
         fm_last = fm;
      end
   end

	initial begin
				   shift    = 0;
               nrst		= 1;
		#17      nrst     = 0;
      #17      nrst     = 1;
      #400000  shift    = 100000;
		#400000  shift    = 200000;
      #400000  shift    = 100000;
      $finish;
	end

endmodule
