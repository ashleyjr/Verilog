`timescale 1ns/1ps
module ice_fm_tx_tb;

	parameter CLK_PERIOD = 83; // 12Mhz

	reg	         clk;
	reg	         nrst; 
	wire	         fm;

	ice_fm_tx  ice_fm_tx(
		.i_clk	   (clk           ),
		.i_nrst	   (nrst          ),
      .o_fm       (fm            )
   );

   integer  period,
            freq_hz,
            samples,
            period_acc,
            avg_freq_hz;
   reg      fm_last;

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("ice_fm_tx.vcd");
		$dumpvars(0,ice_fm_tx_tb);
		$display("                  TIME                 freq (hz)       Avg freq (hz)");		 
      $monitor("%tps       %d\t%d",$time, freq_hz, avg_freq_hz); 
   end

   initial begin
      period         = 0;
      fm_last        = 0;
      freq_hz       = 0;
      samples        = 0;
      period_acc     = 0;
      avg_freq_hz   = 0;
      forever begin
         #1

         // Rising edge
         if(2'b10 == {fm_last,fm}) begin 
            freq_hz       = 1e9/period; 
            samples        = samples + 1;
            period_acc     = period_acc + period;
            avg_freq_hz   = (1e9*samples) / period_acc;
            period         = 0; 
         end else begin
            period   = period + 1;
         end
         fm_last = fm;
      end
   end

	initial begin
                  nrst		   = 1;
		#17         nrst        = 0;
      #17         nrst        = 1;
		            period_acc  = 0;
                  samples     = 0;
      repeat(80) begin
         #100000  period_acc  = 0;
                  samples     = 0;
      end
      $finish;
	end

endmodule

