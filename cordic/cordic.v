`timescale 1ns/1ps
module cordic(
	input				         i_clk,
	input				         i_nrst,
	input	         [15:0]   i_theta,
   input                   i_req,
   output   reg   [15:0]   o_sin,
   output   reg   [15:0]   o_cos,
   output   reg            o_ack
);

   wire                    sigma; 
   wire  signed   [17:0]   new_beta,
                           t;
   
   reg            [4:0]    count;
   reg   signed   [17:0]   a,
                           beta; 

   assign   t        = i_theta;
   assign   sigma    = (beta > t)   ?  1'b0 : 
                                       1'b1 ; 
   assign   new_beta = (sigma)      ?  beta + a : 
                                       beta - a ; 

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst | !i_req) begin 
         beta  <= 'd0;
         count <= 'd0;
      end else begin 
         if (count < 'h10) begin  
            count <= count + 'b1; 
            beta  <= new_beta; 
         end else begin
            o_ack <= 1'b1;
         end
      end
	end

   always @(count) begin
	   case(count)
		   'h0:	a = 16'hc90f;	// 0.785398163397	 = arctan(2^-0)	= arctan(1.0)
		   'h1:	a = 16'h76b1;	// 0.463647609001	 = arctan(2^-1)	= arctan(0.5)
		   'h2:	a = 16'h3eb6;	// 0.244978663127	 = arctan(2^-2)	= arctan(0.25)
		   'h3:	a = 16'h1fd5;	// 0.124354994547	 = arctan(2^-3)	= arctan(0.125)
		   'h4:	a = 16'h0ffa;	// 0.062418809996	 = arctan(2^-4)	= arctan(0.0625)
		   'h5:	a = 16'h07ff;	// 0.031239833430	 = arctan(2^-5)	= arctan(0.03125)
		   'h6:	a = 16'h03ff;	// 0.015623728620	 = arctan(2^-6)	= arctan(0.015625)
		   'h7:	a = 16'h01ff;	// 0.007812341060	 = arctan(2^-7)	= arctan(0.0078125)
		   'h8:	a = 16'h00ff;	// 0.003906230132	 = arctan(2^-8)	= arctan(0.00390625)
		   'h9:	a = 16'h007f;	// 0.001953122516	 = arctan(2^-9)	= arctan(0.001953125)
		   'ha:	a = 16'h003f;	// 0.000976562190	 = arctan(2^-10)	= arctan(0.0009765625)
		   'hb:	a = 16'h001f;	// 0.000488281211	 = arctan(2^-11)	= arctan(0.00048828125)
		   'hc:	a = 16'h000f;	// 0.000244140620	 = arctan(2^-12)	= arctan(0.000244140625)
		   'hd:	a = 16'h0007;	// 0.000122070312	 = arctan(2^-13)	= arctan(0.0001220703125)
		   'he:	a = 16'h0003;	// 0.000061035156	 = arctan(2^-14)	= arctan(6.103515625e-05)
		   'hf:	a = 16'h0001;	// 0.000030517578	 = arctan(2^-15)	= arctan(3.0517578125e-05)
	   endcase
   end
endmodule
