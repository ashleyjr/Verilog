`timescale 1ns/1ps

////////////////////////////////////
// Fixed point signed
// 000.0000000000

module mandelbrot(
	input    wire		                        i_clk,
	input	   wire		                        i_nrst,
	input	   wire	signed   [WIDTH-1:0]       i_c_re,
	input	   wire  signed   [WIDTH-1:0]		   i_c_im,
	input    wire				                  i_valid,
	output   reg            [WIDTH_ITERS-1:0] o_iter,
   output   wire                             o_bounded, 
   output	wire	                           o_done
); 
   parameter   WIDTH       = 16;
   parameter   ITERS       = 256;
   parameter   WIDTH_ITERS = $clog2(ITERS); 

   wire           [WIDTH_ITERS-1:0] iter_next;
   wire                             reset;
   reg   signed   [WIDTH-1:0]       re;
   wire  signed   [(2*WIDTH)-1:0]   re_sq;
   wire  signed   [(2*WIDTH)-1:0]   re_calc;
   wire  signed   [(2*WIDTH)-1:0]   re_next;
   reg   signed   [WIDTH-1:0]       im;
   wire  signed   [(2*WIDTH)-1:0]   im_sq;
   wire  signed   [(2*WIDTH)-1:0]   im_calc;
   wire  signed   [(2*WIDTH)-1:0]   im_next;
   wire  signed   [(2*WIDTH)-1:0]   re_im;
   wire  signed   [(2*WIDTH)-1:0]   abs;
   wire  signed   [(2*WIDTH)-1:0]   cmp;

   assign reset      = o_done | ~i_valid;
   
   assign re_sq      = re*re >>> (WIDTH-4);
   assign im_sq      = im*im >>> (WIDTH-4);
   assign re_im      = re*im >>> (WIDTH-4);

   assign re_calc    = re_sq - im_sq + i_c_re;
   assign im_calc    = (re_im <<< 1) + i_c_im;

   assign re_next    =  (reset) ? i_c_re : re_calc;   
   assign im_next    =  (reset) ? i_c_im : im_calc;

   assign abs        = re_sq + im_sq;
   assign cmp        = 2 ** (WIDTH-2);
   assign unbounded  = abs > cmp;   
   assign o_bounded  = ~unbounded;

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         re <= 'd0;
         im <= 'd0;
      end else begin
         re <= re_next;
         im <= im_next;
      end
	end 

   assign iter_next  =  (o_done)    ?  'd0:
                        (i_valid)   ?  o_iter + 'd1:
                                       'd0;

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)    o_iter <= 'd0;
      else           o_iter <= iter_next;	
	end
   
   assign o_done  = unbounded | (o_iter == (ITERS-1));

endmodule
