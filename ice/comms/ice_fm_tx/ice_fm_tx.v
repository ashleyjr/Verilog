`timescale 1ns/1ps
module ice_fm_tx(
	input	   wire  i_clk,
	input	   wire  i_nrst,
	output   wire  o_fm
);
   wire clk;
    
   reg            [10-0:0]    count;
   reg            [6-1:0]     theta;
   wire           [10-1:0]    sin;
   reg            [10-1:0]    sin_d;
   
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
   
   always@(posedge clk or negedge i_nrst) begin
      if(!i_nrst) begin
         count    <= 10'd0;
         theta    <= 6'd0;
      end else begin
         if(count == 'd1000) begin
            count <= 'd0;
            if(theta == 'd63) begin
               theta <= 'd0;
            end else begin
               theta <= theta + 'd1;
            end
         end else begin
            count <= count + 'd1;
         end   
      end
   end

   sin_lut sin_lut (
      .i_theta    (theta         ),
      .o_sin      (sin           )
   );

   always@(posedge clk or negedge i_nrst) begin
      if(!i_nrst) begin
         sin_d <= 10'd0; 
      end else begin
         sin_d <= sin;
      end
   end


   
   fm_tx #(
      .p_hz_sz    (27            )
   )fm_tx(
      .i_clk      (clk           ),
      .i_nrst     (i_nrst        ),
      .i_clk_hz   (27'd67500000  ),
      .i_base_hz  (27'd30000000  ),
      .i_shift_hz ({{17{1'b0}},sin_d}),
      .o_fm       (o_fm          )
   );

endmodule
