`timescale 1ns/1ps
module adder_tb;

	parameter   CLK_PERIOD = 20;
   parameter   DATA_WIDTH = 32;
	
   
   reg   signed [DATA_WIDTH-1:0]  i_a;
	reg   signed [DATA_WIDTH-1:0]  i_b;
	wire  signed [DATA_WIDTH-1:0]  o_q;
   wire                    o_ovf;

   adder #(
      .DATA_WIDTH (32      )
   )adder(
      .i_a        (i_a     ),
      .i_b        (i_b     ),
      .o_q        (o_q     ),
      .o_ovf      (o_ovf   )
	);

	initial begin
		$dumpfile("adder.vcd");
		$dumpvars(0,adder_tb);
	end

   reg signed [DATA_WIDTH:0]  test;
   reg signed [DATA_WIDTH:0]  top;
   reg signed [DATA_WIDTH:0]  bot;  

   initial begin
      top = 32'h7FFFFFFF; 
      bot = -32'h80000000;
      while(1) begin
         @(i_a or i_b);
         #2 
         test = i_a + i_b;
         if((test > top) || (bot > test)) begin 
            if(o_ovf != 1'b1) begin
               $display("Overflow error");
               #1
               $finish;
            end
         end else begin
            if(o_q != test) begin
               $display("Add error");
               #1
               $finish;
            end
         end
      end
   end

   initial begin 
	   i_a   = 32'h0;
      i_b   = 32'h0;
      
      #5
      i_a   = 'd5;
      i_b   = -'d1;
      
      #5
      i_a   = -'d5;
      i_b   = -'d1;

      #5
      i_a   = 32'h7FFFFFFF;
      i_b   = 32'h00000001;
      
      #5
      i_a   = 32'h7FFFFFFF;
      i_b   = -32'h7FFFFFFF;
      
      #5
      i_a   = 32'h80000000;
      i_b   = 32'h80000000;
      
      #5
      i_a   = -32'h7FFFFFFF;
      i_b   = -32'h00000001;
      
      #5
      i_a   = -32'h7FFFFFFE;
      i_b   = -32'h00000001;
      
      #5
      i_a   = -32'h80000000;
      i_b   = -32'h00000001;
      
      repeat(1000) begin
         #5
         i_a = $urandom;
         i_b = $urandom; 
      end
      #5
     	$finish;
	end

endmodule
