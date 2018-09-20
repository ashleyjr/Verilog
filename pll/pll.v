module pll(  
   input    i_clk,
   input    i_nrst,
   input    i_bypass,
   output   o_clk, 
   output   o_lock
);

// All PLL settings available on the icestick
// Select one...

// PLLOUT = 16.875MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd44;
//     parameter p_divq = 3'd5;
// PLLOUT = 17.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd45;
//     parameter p_divq = 3'd5;
// PLLOUT = 17.625MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd46;
//     parameter p_divq = 3'd5;
// PLLOUT = 18.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd47;
//     parameter p_divq = 3'd5;
// PLLOUT = 18.375MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd48;
//     parameter p_divq = 3'd5;
// PLLOUT = 18.75MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd49;
//     parameter p_divq = 3'd5;
// PLLOUT = 19.125MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd50;
//     parameter p_divq = 3'd5;
// PLLOUT = 19.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd51;
//     parameter p_divq = 3'd5;
// PLLOUT = 19.875MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd52;
//     parameter p_divq = 3'd5;
// PLLOUT = 20.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd53;
//     parameter p_divq = 3'd5;
// PLLOUT = 20.625MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd54;
//     parameter p_divq = 3'd5;
// PLLOUT = 21.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd55;
//     parameter p_divq = 3'd5;
// PLLOUT = 21.375MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd56;
//     parameter p_divq = 3'd5;
// PLLOUT = 21.75MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd57;
//     parameter p_divq = 3'd5;
// PLLOUT = 22.125MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd58;
//     parameter p_divq = 3'd5;
// PLLOUT = 22.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd59;
//     parameter p_divq = 3'd5;
// PLLOUT = 22.875MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd60;
//     parameter p_divq = 3'd5;
// PLLOUT = 23.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd61;
//     parameter p_divq = 3'd5;
// PLLOUT = 23.625MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd62;
//     parameter p_divq = 3'd5;
// PLLOUT = 24.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd63;
//     parameter p_divq = 3'd5;
// PLLOUT = 33.75MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd44;
//     parameter p_divq = 3'd4;
// PLLOUT = 34.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd45;
//     parameter p_divq = 3'd4;
// PLLOUT = 35.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd46;
//     parameter p_divq = 3'd4;
// PLLOUT = 36.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd47;
//     parameter p_divq = 3'd4;
// PLLOUT = 36.75MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd48;
//     parameter p_divq = 3'd4;
// PLLOUT = 37.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd49;
//     parameter p_divq = 3'd4;
// PLLOUT = 38.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd50;
//     parameter p_divq = 3'd4;
// PLLOUT = 39.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd51;
//     parameter p_divq = 3'd4;
// PLLOUT = 39.75MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd52;
//     parameter p_divq = 3'd4;
// PLLOUT = 40.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd53;
//     parameter p_divq = 3'd4;
// PLLOUT = 41.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd54;
//     parameter p_divq = 3'd4;
// PLLOUT = 42.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd55;
//     parameter p_divq = 3'd4;
// PLLOUT = 42.75MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd56;
//     parameter p_divq = 3'd4;
// PLLOUT = 43.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd57;
//     parameter p_divq = 3'd4;
// PLLOUT = 44.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd58;
//     parameter p_divq = 3'd4;
// PLLOUT = 45.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd59;
//     parameter p_divq = 3'd4;
// PLLOUT = 45.75MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd60;
//     parameter p_divq = 3'd4;
// PLLOUT = 46.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd61;
//     parameter p_divq = 3'd4;
// PLLOUT = 47.25MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd62;
//     parameter p_divq = 3'd4;
// PLLOUT = 48.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd63;
//     parameter p_divq = 3'd4;
// PLLOUT = 67.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd44;
//     parameter p_divq = 3'd3;
// PLLOUT = 69.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd45;
//     parameter p_divq = 3'd3;
// PLLOUT = 70.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd46;
//     parameter p_divq = 3'd3;
// PLLOUT = 72.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd47;
//     parameter p_divq = 3'd3;
// PLLOUT = 73.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd48;
//     parameter p_divq = 3'd3;
// PLLOUT = 75.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd49;
//     parameter p_divq = 3'd3;
// PLLOUT = 76.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd50;
//     parameter p_divq = 3'd3;
// PLLOUT = 78.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd51;
//     parameter p_divq = 3'd3;
// PLLOUT = 79.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd52;
//     parameter p_divq = 3'd3;
// PLLOUT = 81.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd53;
//     parameter p_divq = 3'd3;
// PLLOUT = 82.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd54;
//     parameter p_divq = 3'd3;
// PLLOUT = 84.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd55;
//     parameter p_divq = 3'd3;
// PLLOUT = 85.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd56;
//     parameter p_divq = 3'd3;
// PLLOUT = 87.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd57;
//     parameter p_divq = 3'd3;
// PLLOUT = 88.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd58;
//     parameter p_divq = 3'd3;
// PLLOUT = 90.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd59;
//     parameter p_divq = 3'd3;
// PLLOUT = 91.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd60;
//     parameter p_divq = 3'd3;
// PLLOUT = 93.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd61;
//     parameter p_divq = 3'd3;
// PLLOUT = 94.5MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd62;
//     parameter p_divq = 3'd3;
// PLLOUT = 96.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd63;
//     parameter p_divq = 3'd3;
// PLLOUT = 135.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd44;
//     parameter p_divq = 3'd2;
// PLLOUT = 138.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd45;
//     parameter p_divq = 3'd2;
// PLLOUT = 141.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd46;
//     parameter p_divq = 3'd2;
// PLLOUT = 144.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd47;
//     parameter p_divq = 3'd2;
// PLLOUT = 147.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd48;
//     parameter p_divq = 3'd2;
// PLLOUT = 150.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd49;
//     parameter p_divq = 3'd2;
// PLLOUT = 153.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd50;
//     parameter p_divq = 3'd2;
// PLLOUT = 156.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd51;
//     parameter p_divq = 3'd2;
// PLLOUT = 159.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd52;
//     parameter p_divq = 3'd2;
// PLLOUT = 162.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd53;
//     parameter p_divq = 3'd2;
// PLLOUT = 165.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd54;
//     parameter p_divq = 3'd2;
// PLLOUT = 168.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd55;
//     parameter p_divq = 3'd2;
// PLLOUT = 171.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd56;
//     parameter p_divq = 3'd2;
// PLLOUT = 174.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd57;
//     parameter p_divq = 3'd2;
// PLLOUT = 177.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd58;
//     parameter p_divq = 3'd2;
// PLLOUT = 180.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd59;
//     parameter p_divq = 3'd2;
// PLLOUT = 183.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd60;
//     parameter p_divq = 3'd2;
// PLLOUT = 186.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd61;
//     parameter p_divq = 3'd2;
// PLLOUT = 189.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd62;
//     parameter p_divq = 3'd2;
// PLLOUT = 192.0MHz
     parameter p_divr = 4'd0;
     parameter p_divf = 7'd63;
     parameter p_divq = 3'd2;
// PLLOUT = 270.0MHz
//     parameter p_divr = 4'd0;
//     parameter p_divf = 7'd44;
//     parameter p_divq = 3'd1;
 
   SB_PLL40_CORE #(
      .FEEDBACK_PATH ("SIMPLE"   ),
      .PLLOUT_SELECT ("GENCLK"   ),
      .DIVR          (p_divr     ),
      .DIVF          (p_divf     ),
      .DIVQ          (p_divq     ),
      .FILTER_RANGE  (3'b001     )  // Always 1 https://www.reddit.com/r/yosys/comments/3yrq6d/are_plls_supported_on_the_icestick_hw/
   ) uut (
      .LOCK          (o_lock     ),
      .RESETB        (i_nrst     ),
      .BYPASS        (i_bypass   ),
      .REFERENCECLK  (i_clk      ),
      .PLLOUTCORE    (o_clk      )
   );

endmodule

