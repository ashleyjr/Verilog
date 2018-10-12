`timescale 1ns/1ps

// Output freq (hz) = i_base_hz + i_shift_hz

module fm_tx(
	input	   wire                    i_clk,
	input    wire                    i_nrst,
   input    wire  [p_hz_sz-1:0]     i_clk_hz,
   input    wire  [p_hz_sz-1:0]     i_base_hz,
   input    wire  [p_hz_sz-1:0]     i_shift_hz,
	output   wire                    o_fm
); 
   parameter   p_hz_sz  = 1;
   parameter   p_scale  = 2 ** p_hz_sz; 

   wire  [p_hz_sz-1:0]     add;
   wire  [(2*p_hz_sz)-1:0] freq,
                           scale;

   reg   [p_hz_sz-1:0]     phase_acc;

   assign freq    = i_base_hz + i_shift_hz;
   assign scale   = freq * p_scale;
   assign add     = scale / i_clk_hz;
   assign o_fm    = phase_acc[p_hz_sz-1];

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
		   phase_acc   <= 'd0;
      end else begin
         phase_acc   <= phase_acc + add;  
		end
	end
endmodule
