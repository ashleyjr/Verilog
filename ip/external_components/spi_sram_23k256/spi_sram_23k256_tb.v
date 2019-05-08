`timescale 1ns/1ps
module spi_sram_23k256_tb;

	parameter CLK_PERIOD = 20;

	reg	         i_clk;
	reg	         i_nrst;
	reg	[14:0]   i_addr;
	reg	[7:0]    i_data;
   wire  [7:0]    o_data;
	reg	         i_rnw;
	reg            i_valid;
	wire	         o_accept;
	wire	         o_sck;
	wire	         o_ncs;
	wire	         o_s;
	reg            i_s;

	spi_sram_23k256 spi_sram_23k256(  
      .i_clk      (i_clk   ),
      .i_nrst     (i_nrst  ),          
      .i_addr     (i_addr  ),
      .i_data     (i_data  ),
      .o_data     (o_data  ),
      .i_rnw      (i_rnw   ),
      .i_valid    (i_valid ),
      .o_accept   (o_accept),   
      .o_sck      (o_sck   ),
      .o_ncs      (o_ncs   ),
      .o_s        (o_s     ),
      .i_s        (i_s     ) 
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2)   i_clk = 0;
			#(CLK_PERIOD/2)   i_clk = 1;
		end
	end

	initial begin
			$dumpfile("spi_sram_23k256.vcd");
			$dumpvars(0,spi_sram_23k256_tb);
   end

   initial begin
      #50000    $finish;
   end
	
   initial begin
               i_valid     = 0;
               i_s         = 0;
               i_rnw       = 0;
				   i_nrst		= 1;
      #10      i_nrst      = 0;
      #10      i_nrst      = 1;

               i_data      = 8'hAA;
               i_addr      = 16'h5555;
      #10007   i_valid     = 1;
      #77      i_addr      = 16'h5556;
      #20000   i_valid     = 0;
	end

endmodule
