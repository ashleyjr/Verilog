`timescale 1ns/1ps
module fibonacci_tb;

	parameter CLK_PERIOD = 20;


   parameter   ADDR_WIDTH  = 64,
               DATA_WIDTH  = 16;

	reg	                  i_clk;
	reg	                  i_nrst;
	wire  [ADDR_WIDTH-1:0]  o_addr;
   wire  [DATA_WIDTH-1:0]  o_data;
   reg   [DATA_WIDTH-1:0]  i_data;
   wire                    o_read_valid;
   reg                     i_read_accept;
   wire                    o_write_valid;
   reg                     i_write_accept;	

	fibonacci #(
      .ADDR_WIDTH       (ADDR_WIDTH       ),
      .DATA_WIDTH       (DATA_WIDTH       )
   ) fibonacci (
      .i_clk            (i_clk            ),
      .i_nrst           (i_nrst           ),
      .o_addr           (o_addr           ),
      .o_data           (o_data           ),
      .i_data           (i_data           ),
      .o_read_valid     (o_read_valid     ),
      .i_read_accept    (i_read_accept    ),
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

   reg   [DATA_WIDTH-1:0]  mem   [199:0];

   initial begin
      while(1) begin
         while(!o_read_valid) @(posedge i_clk);
         i_data = mem[o_addr];
         i_read_accept = 1'b1;
         @(posedge i_clk);
         i_read_accept = 1'b0;
      end
   end

   initial begin
      while(1) begin
         while(!o_write_valid) @(posedge i_clk);
         mem[o_addr] = o_data;
         i_write_accept = 1'b1;
         @(posedge i_clk);
         i_write_accept = 1'b0;
      end
   end



	initial begin
            mem[0]         = 1;
            mem[1]         = 1;
            i_nrst         = 1;
            i_read_accept  = 0;
            i_write_accept = 0;
      #777  i_nrst         = 0;
      #777  i_nrst         = 1;
      #7777777 
		$finish;
	end

endmodule
