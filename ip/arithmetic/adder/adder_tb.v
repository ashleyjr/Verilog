`timescale 1ns/1ps
module adder_tb;

	parameter   CLK_PERIOD = 20;
   parameter   DATA_WIDTH = 32;
	
   
   reg   [DATA_WIDTH-1:0]  i_a;
	reg   [DATA_WIDTH-1:0]  i_b;
	wire  [DATA_WIDTH-1:0]  o_q;
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

	initial begin 
	   i_a   = 32'h0;
      i_b   = 32'h0;
      
      #5
      i_a   = 32'hFFFFFFFF;
      i_b   = 32'h00000001;
      
      #5
      i_a   = 32'h00000001;
      i_b   = 32'h00000001;
      
      #5
      i_a   = 32'h80000000;
      i_b   = 32'h80000000;
      

      #5
     	$finish;
	end

endmodule
