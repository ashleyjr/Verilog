`timescale 1ns/1ps
module mandelbrot(
	input    wire		                        i_clk,
	input	   wire		                        i_nrst,
	input	   wire	signed   [WIDTH-1:0]       i_c_re,
	input	   wire  signed   [WIDTH-1:0]		   i_c_im,
	input    wire				                  i_valid,
	output   reg            [WIDTH_ITERS-1:0] o_iter,
	output	wire	                           o_done
); 
   parameter   WIDTH       = 16;
   parameter   ITERS       = 256;
   parameter   WIDTH_ITERS = $clog2(ITERS);

   wire           [WIDTH_ITERS-1:0] iter_next;
   wire                             reset;
   reg   signed   [WIDTH-1:0]       re;
   wire  signed   [WIDTH-1:0]       re_sq;
   wire  signed   [WIDTH-1:0]       re_next;
   reg   signed   [WIDTH-1:0]       im;
   wire  signed   [WIDTH-1:0]       im_sq;
   wire  signed   [WIDTH-1:0]       im_next;
   wire  signed   [WIDTH-1:0]       abs;

   assign reset      = o_done | ~i_valid;
   
   assign re_sq      = re*re;
   assign im_sq      = im*im;
   
   assign re_next    = (reset) ? 'd0 : (re_sq) - (im_sq) + i_c_re;   
   assign im_next    = (reset) ? 'd0 : ((im*re) << 1) + i_c_im;

   assign abs        = re_sq + im_sq;
   assign unbounded  = (abs > (2 ** (WIDTH-1)));

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
