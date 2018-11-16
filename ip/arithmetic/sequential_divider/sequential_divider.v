// o_q = i_n / i_d

`timescale 1ns/1ps
module sequential_divider(
	input		wire                    i_clk,
	input		wire                    i_nrst,
	input    wire  [DATA_WIDTH-1:0]  i_n,
   input    wire  [DATA_WIDTH-1:0]  i_d,
	output	reg	[DATA_WIDTH-1:0]  o_q,     
   output   reg   [DATA_WIDTH-1:0]  o_r,
   input    wire                    i_valid,
   output   reg                     o_accept
);

   parameter   DATA_WIDTH = 0;

   reg   [$clog2(DATA_WIDTH+1)-1:0]    i; 
   wire  [DATA_WIDTH:0]                r_shift; 
   wire                                comp;

   assign r_shift = {o_r[DATA_WIDTH-1:0],i_n[i]}; 

   assign comp = (r_shift >= i_d);

	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
	      i     <= DATA_WIDTH-1;
         o_r   <= 'd0;
         o_q   <= 'd0;
		end else begin 
         o_accept <= 1'b0; 
         if(i_valid) begin 
            i <= i - 'd1; 
            if (comp) begin
               o_r      <= r_shift - i_d;
               o_q[i]   <= 1'b1;
            end else begin
               o_r      <= r_shift; 
            end 
		   end
         if(i == 0) begin 
            o_accept    <= 1'b1; 
            o_r         <= 'd0;
            i           <= DATA_WIDTH-1; 
         end
         if(o_accept)
            o_q         <= 'd0;
      end
	end
endmodule
