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

   parameter   SM_IDLE  = 4'h0;
   parameter   SM_RE_RE = 4'h1;
   parameter   SM_RE_IM = 4'h2;
   parameter   SM_IM_IM = 4'h3;

   reg            [3:0]             state;
   wire           [3:0]             state_next;

   wire           [WIDTH_ITERS-1:0] iter_next;
   wire                             iter_upd;   

   wire                             reset;
   wire  signed   [WIDTH-1:0]       a;
   wire  signed   [WIDTH-1:0]       b;
   wire  signed   [(2*WIDTH)-1:0]   c;
   wire  signed   [(2*WIDTH)-1:0]   c_shift;
   reg   signed   [WIDTH-1:0]       re;
   reg   signed   [(2*WIDTH)-1:0]   re_sq;
   wire  signed   [(2*WIDTH)-1:0]   re_calc;
   wire  signed   [(2*WIDTH)-1:0]   re_next;
   reg   signed   [WIDTH-1:0]       im;
   reg   signed   [(2*WIDTH)-1:0]   im_sq;
   wire  signed   [(2*WIDTH)-1:0]   im_calc;
   wire  signed   [(2*WIDTH)-1:0]   im_next;
   reg   signed   [(2*WIDTH)-1:0]   re_im;
   wire  signed   [(2*WIDTH)-1:0]   abs;
   wire  signed   [(2*WIDTH)-1:0]   cmp;
   reg                              next_upd;

   assign reset      = o_done | ~i_valid;
   
   assign re_calc    = re_sq - im_sq + i_c_re;
   assign im_calc    = (re_im <<< 1) + i_c_im;

   assign re_next    =  (reset) ? i_c_re : re_calc;   
   assign im_next    =  (reset) ? i_c_im : im_calc;

   assign abs        = re_sq + im_sq;
   assign cmp        = 2 ** (WIDTH-2);
   assign unbounded  = (abs > cmp) & (next_upd);   
   assign o_bounded  = ~unbounded;

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin             
         re <= 'd0;
         im <= 'd0;
      end else begin 
         if(next_upd|reset) begin 
            re <= re_next;
            im <= im_next;
         end
      end
	end 

   assign iter_next  =  (reset) ? 'd0 : o_iter + 'd1;
   assign iter_upd   = reset | ((state == SM_IM_IM) & acc);


   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)       o_iter <= 'd0;
      else if(iter_upd) o_iter <= iter_next;	
	end
   
   assign o_done  = unbounded | (o_iter == (ITERS-1));
 
   assign val = (SM_IDLE != state); 

   assign state_next =  ((state == SM_IDLE)  & i_valid & ~reset)  ? SM_RE_RE :
                        ((state == SM_RE_RE) & acc)      ? SM_RE_IM :
                        ((state == SM_RE_IM) & acc)      ? SM_IM_IM :
                        ((state == SM_IM_IM) & acc)      ? SM_IDLE  :
                                                           state;

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) state <= SM_IDLE; 
      else        state <= state_next; 
	end 
   
   assign a = ((SM_RE_RE == state)|(SM_RE_IM == state)) ? re : im;

   assign b = (SM_RE_RE == state) ? re : im;
 
   assign c_shift   = (reset) ? 'd0 : c >>> (WIDTH-4);
   assign re_sq_upd = reset | (SM_RE_RE == state) & acc;
   assign im_sq_upd = reset | (SM_IM_IM == state) & acc;
   assign re_im_upd = reset | (SM_RE_IM == state) & acc;

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst)          re_sq <= 'd0; 
      else if(re_sq_upd)   re_sq <= c_shift;
	end 
   
   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst)          im_sq <= 'd0; 
      else if(im_sq_upd)   im_sq <= c_shift;
	end 
   
   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst)          re_im <= 'd0; 
      else if(re_im_upd)   re_im <= c_shift;
	end   
   
   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) next_upd <= 1'b1; 
      else        next_upd <= im_sq_upd;
	end   
   
   sequential_multiplier_signed #(
      .DATA_WIDTH_A  (WIDTH      ),
      .DATA_WIDTH_B  (WIDTH      ),
      .DATA_WIDTH_C  (WIDTH*2    )
   ) mul (
      .i_clk         (i_clk      ),
      .i_nrst        (i_nrst     ),
      .i_a           (a          ),
      .i_b           (b          ),
      .o_c           (c          ),
      .i_valid       (val        ),
      .o_accept      (acc        )
   );


endmodule
