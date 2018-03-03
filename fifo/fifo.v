`timescale 1ns/1ps
module fifo(
	input				               i_clk,
	input				               i_nrst,
   input    [WIDTH-1:0]          i_data,
   output   [WIDTH-1:0]          o_data,	
	input			                  i_write,
	input			                  i_read,
   output   [$clog2(DEPTH)-1:0]  o_level,
   input                         o_full,
   input                         o_empty
);

   parameter   DEPTH = 1,
               WIDTH = 1;
   
   reg   [WIDTH-1:0]          data  [DEPTH-1:0];
   reg   [$clog2(DEPTH)-1:0]  rptr;
   reg   [$clog2(DEPTH)-1:0]  wptr;
   
   assign   o_data   = data[rptr];
   assign   o_level  = (wptr >= rptr) ? 
                        wptr - rptr : 
                        wptr + DEPTH - rptr; 
   assign   o_full   = (o_level == (DEPTH-1));
   assign   o_empty  = (o_level == 0);

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         rptr  <= 0;
         wptr  <= 0;
		end else begin
         if(i_write && !o_full) begin
            wptr <= (wptr + 1) % DEPTH;  
            data[wptr] <= i_data; 
         end
         if(i_read && !o_empty) begin
            rptr <= (rptr + 1) % DEPTH;  
         end
		end
	end
endmodule
