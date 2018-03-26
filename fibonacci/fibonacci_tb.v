`timescale 1ns/1ps
module fibonacci_tb;

	parameter CLK_PERIOD = 20;


   parameter   VALUE_WIDTH    = 64,
               SEQUENCE_WIDTH = 16;

	reg	                     i_clk;
	reg	                     i_nrst;
	wire  [VALUE_WIDTH-1:0]    o_value;
   wire  [SEQUENCE_WIDTH-1:0] o_sequence;
   wire                       o_write_valid;
   reg                        i_write_accept;	

	fibonacci #(
      .VALUE_WIDTH      (VALUE_WIDTH      ),
      .SEQUENCE_WIDTH   (SEQUENCE_WIDTH   )
   ) fibonacci (
      .i_clk            (i_clk            ),
      .i_nrst           (i_nrst           ),
      .o_value          (o_value          ),
      .o_sequence       (o_sequence       ),
      .o_write_valid    (o_write_valid    ),
      .i_write_accept   (i_write_accept   )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
		$dumpfile("fibonacci.vcd");
		$dumpvars(0,fibonacci_tb);	
		$display("                  TIME    nRst");		
      $monitor("%tps       %d",$time,i_nrst);
	end

	initial begin
            i_nrst         = 1;
      #777  i_nrst         = 0;
      #777  i_nrst         = 1;
            repeat(200) begin
               @(posedge i_clk)
               i_write_accept = $random;
            end 
		$finish;
	end

endmodule
