`timescale 1ns/1ps
module ice_fm_tx(
	input	   wire  i_clk,
	input	   wire  i_nrst,
	output   wire  o_fm
);
   wire clk;
 
   reg   signed   [19:0]      theta;
   reg   signed   [19:0]      theta_d;
   wire                       ack;
   wire  signed   [19:0]      sin;
   wire  signed   [19:0]      sin_shift;
   reg            [27-1:0]    shift;

   // PLL out is 67.5 MHz
   ice_pll #(
      .p_divr     (4'd0          ),
      .p_divf     (7'd44         ),
      .p_divq     (3'd3          )
   
   )ice_pll(
	   .i_clk	   (i_clk         ),
	   .i_nrst	   (i_nrst        ),
	   .i_bypass   (1'b0          ),
      .o_clk      (clk           ),
      .o_lock     (              )	
	);

   assign sin_shift = 20'd70000 + sin;    
      

   always@(posedge clk or negedge i_nrst) begin
      if(!i_nrst) begin
         theta    <= -20'd205887;
         theta_d  <= 'd0;
         shift    <= 'd0;
      end else begin
         if(theta == 20'd205887) 
            theta <= -20'd205887;
         else
            theta <= theta + 'd1;
         if(ack) begin  
            theta_d  <= theta[19:0];
            shift    <= sin_shift[19:0];
         end
      end
   end

   cordic cordic  (
      .i_clk      (i_clk         ),
      .i_nrst     (i_nrst        ),
      .i_theta    (theta_d       ),
      .i_req      (!ack          ),
      .o_sin      (sin           ),
      .o_cos      (              ),    // Unused
      .o_ack      (ack           )
   );

   fm_tx #(
      .p_hz_sz    (27            )
   )fm_tx(
      .i_clk      (clk           ),
      .i_nrst     (i_nrst        ),
      .i_clk_hz   (27'd67500000  ),
      .i_base_hz  (27'd30000000  ),
      .i_shift_hz ({1'b0,shift[27-2:0]}         ),
      .o_fm       (o_fm          )
   );

endmodule
