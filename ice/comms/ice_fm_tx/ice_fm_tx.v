`timescale 1ns/1ps
module ice_fm_tx(
	input	   wire  i_clk,
	input	   wire  i_nrst,
	output   wire  o_fm
);
   wire clk;
  
   reg [31:0]  count;

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         count <= 32'd0;
      end else begin
         if (count == 32'd1000000) begin
            count <= 32'd0;
         end else begin
            count <= count + 32'd1;
         end
      end
   end

   // PLL out is 192 MHz
   ice_pll #(
      .p_divr     (4'd0          ),
      .p_divf     (7'd63         ),
      .p_divq     (3'd2          )
   
   )ice_pll(
	   .i_clk	   (i_clk         ),
	   .i_nrst	   (i_nrst        ),
	   .i_bypass   (1'b0          ),
      .o_clk      (clk           ),
      .o_lock     (              )	
	);

   fm_tx #(
      .p_hz_sz    (32            )
   )fm_tx(
      .i_clk      (clk           ),
      .i_nrst     (i_nrst        ),
      .i_clk_hz   (32'd192000000 ),
      .i_base_hz  (32'd090000000 ),
      .i_shift_hz (count         ),
      .o_fm       (o_fm          )
   );

endmodule
