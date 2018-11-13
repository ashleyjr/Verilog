`timescale 1ns/1ps
module sequential_multiplier_signed(	
   input    wire                                i_clk,
	input	   wire                                i_nrst,
	input	   wire  signed   [DATA_WIDTH_A-1:0]   i_a,
	input    wire  signed   [DATA_WIDTH_B-1:0]   i_b,
   output   wire  signed   [DATA_WIDTH_C-1:0]   o_c,
	input	   wire                                i_valid,
	output	wire	                              o_accept
);
   
   parameter   DATA_WIDTH_A   = 0;
   parameter   DATA_WIDTH_B   = 0;
   parameter   DATA_WIDTH_C   = DATA_WIDTH_A + DATA_WIDTH_B;

   wire  [DATA_WIDTH_A-1:0]   a; 
   wire  [DATA_WIDTH_B-1:0]   b;
   wire  [DATA_WIDTH_C-1:0]   c;
   wire                       negative;
   
   assign a =  (i_a[DATA_WIDTH_A-1]) ? 
                  ((~i_a) + 'd1) : 
                  i_a;
   
   assign b =  (i_b[DATA_WIDTH_B-1]) ? 
                  ((~i_b) + 'd1) : 
                  i_b;
   
   assign negative   = i_a[DATA_WIDTH_A-1] ^ i_b[DATA_WIDTH_B-1];
   
   assign o_c        = (negative) ?
                        ((~c) + 'd1)   :
                        c;
   
   sequential_multiplier #(
      .DATA_WIDTH_A  (DATA_WIDTH_A),
      .DATA_WIDTH_B  (DATA_WIDTH_B)
   ) sequential_multiplier (
      .i_clk         (i_clk            ),
      .i_nrst        (i_nrst           ),
      .i_a           (a                ),
      .i_b           (b                ),
      .o_c           (c                ),
      .i_valid       (i_valid          ),
      .o_accept      (o_accept         )
	);

endmodule
