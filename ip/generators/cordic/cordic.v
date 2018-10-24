`timescale 1ns/1ps
module cordic(
	input				                  i_clk,
	input				                  i_nrst,
	input	         signed   [19:0]   i_theta,
   input                            i_req,
   output   reg   signed   [19:0]   o_sin,
   output   reg   signed   [19:0]   o_cos,
   output   reg                     o_ack
);
   parameter   signed p_pi        = 20'd205887; 
   parameter   signed p_pi_2      = 20'd102943;

   wire                    sigma; 
   wire                    less,
                           more;
   wire  signed   [19:0]   new_beta,
                           t,
                           x_new,
                           y_new,
                           x_shift,
                           y_shift,
                           sin,
                           cos,
                           a;
   reg            [4:0]    count;
   reg   signed   [19:0]  beta,
                           x,
                           y; 
 
   assign   x_shift  = x >>> count;
   assign   y_shift  = y >>> count;
   assign   t        =  (more) ? i_theta - p_pi :
                        (less) ? i_theta + p_pi :
                                 i_theta;
   
   assign   more     = (i_theta > p_pi_2);
   
   assign   less     = (i_theta < -p_pi_2);

   assign   sigma    = (beta > t)   ?  1'b0 : 
                                       1'b1 ; 
   assign   new_beta = (sigma)      ?  beta + a : 
                                       beta - a ; 
   assign   x_new    = (sigma)      ?  x - y_shift :
                                       x + y_shift ;
	assign   y_new    = (sigma)      ?  y + x_shift :
                                       y - x_shift ;    
   
   // 0.5 + 0.0625 + 0.03125 + 0.015625 = 0.609                               
   assign   sin      = (y >>> 1) + (y >>> 4) + (y >>> 5) + (y >>> 6);
   assign   cos      = (x >>> 1) + (x >>> 4) + (x >>> 5) + (x >>> 6);
  
   // LUT
   assign   a  =  (count == 'h0)	?  20'h0c90f   :	// 0.785398163397	 = arctan(2^-0)	= arctan(1.0)
		            (count == 'h1)	?  20'h076b1   :	// 0.463647609001	 = arctan(2^-1)	= arctan(0.5)
		            (count == 'h2)	?  20'h03eb6   :	// 0.244978663127	 = arctan(2^-2)	= arctan(0.25)
		            (count == 'h3)	?  20'h01fd5   :	// 0.124354994547	 = arctan(2^-3)	= arctan(0.125)
		            (count == 'h4)	?  20'h00ffa   :	// 0.062418809996	 = arctan(2^-4)	= arctan(0.0625)
		            (count == 'h5)	?  20'h007ff   :	// 0.031239833430	 = arctan(2^-5)	= arctan(0.03125)
		            (count == 'h6)	?  20'h003ff   :	// 0.015623728620	 = arctan(2^-6)	= arctan(0.015625)
		            (count == 'h7)	?  20'h001ff   :	// 0.007812341060	 = arctan(2^-7)	= arctan(0.0078125)
		            (count == 'h8)	?  20'h000ff   :	// 0.003906230132	 = arctan(2^-8)	= arctan(0.00390625)
		            (count == 'h9)	?  20'h0007f   :	// 0.001953122516	 = arctan(2^-9)	= arctan(0.001953125)
		            (count == 'ha)	?  20'h0003f   :	// 0.000976562190	 = arctan(2^-10)	= arctan(0.0009765625)
		            (count == 'hb)	?  20'h0001f   :	// 0.000488281211	 = arctan(2^-11)	= arctan(0.00048828125)
		            (count == 'hc)	?  20'h0000f   :	// 0.000244140620	 = arctan(2^-12)	= arctan(0.000244140625)
		            (count == 'hd)	?  20'h00007   :	// 0.000122070312	 = arctan(2^-13)	= arctan(0.0001220703125)
		            (count == 'he)	?  20'h00003   :	// 0.000061035156	 = arctan(2^-14)	= arctan(6.103515625e-05)
		            //count == 'hf
                                    20'h00001   ;	// 0.000030517578	 = arctan(2^-15)	= arctan(3.0517578125e-05)
                           
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin 
         beta  <= 'd0;
         count <= 'd0;
         x     <= 'h0FFFF;
         y     <= 'd0;
         o_ack <= 1'b0;
         o_sin <= 'd0;
         o_cos <= 'd0;
      end else begin 
         o_ack <= 1'b0;
         if (count < 'h10) begin  
            count <= count + 'b1; 
            beta  <= new_beta; 
            x     <= x_new;
            y     <= y_new;
         end else begin
            o_sin <= (less | more) ? -sin : sin; 
            o_cos <= (less | more) ? -cos : cos;
            o_ack <= 1'b1;
            if(!i_req) begin
               beta  <= 'd0;
               count <= 'd0;
               x     <= 'h0FFFF;
               y     <= 'd0;
               o_ack <= 1'b0;
               o_sin <= 'd0;
               o_cos <= 'd0;
            end
         end
      end
	end
endmodule
