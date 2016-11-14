`timescale 1ns/1ps
module spi_slave_regs_tb;

	parameter CLK_PERIOD = 20;

	reg	clk;
	reg	nRst;
	reg	nCs;
	reg   sclk;
	reg   mosi;
	wire  miso;	

	spi_slave_regs spi_slave_regs(	
			.clk	(clk  ),
			.nRst	(nRst ),
         .nCs  (nCs  ),
         .sclk (sclk ),
         .mosi (mosi ),
         .miso (miso )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("spi_slave_regs_syn.vcd");
			$dumpvars(0,spi_slave_regs_tb);
		`else
			$dumpfile("spi_slave_regs.vcd");
			$dumpvars(0,spi_slave_regs_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

   task swap;
      input    [7:0] put;
      output   [7:0] get;
      reg      [2:0] ptr;
      begin
         #100  sclk  = 0;
               nCs   = 1;
         #100  nCs   = 0;
         ptr = 7;
         repeat(8) begin   
                  mosi     = put[ptr];
            #100  sclk     = ~sclk;
                  get[ptr] = miso;
            #100  sclk     = ~sclk;
                  ptr      = ptr - 1;
         end
         #100  nCs   = 1;
      end
   endtask

   task write;
      input    [6:0] addr;
      input    [7:0] data;
      reg      [7:0] k;
      begin
         #1000     swap({1'b0,addr},k);
         #1000     swap(data,k);
      end
   endtask
   
   task read;
      input    [6:0] addr;
      output   [7:0] data;
      reg      [7:0] k;
      begin
         #1000     swap({1'b1,addr},k);
         #1000     swap(8'h00,data);
      end
   endtask



   reg   [7:0] j;
   reg   [7:0] data_out;

	initial begin
					nRst		= 1;
	   #100     nRst     = 0;
      #100     nRst     = 1;
		
      #5000    write(8'h00,8'hAA); 
      #5000    write(8'h01,8'h34);
      #5000    write(8'h02,8'h67);
	
      #5000    read(8'h00,data_out); 
      #5000    read(8'h01,data_out);
      #5000    read(8'h02,data_out);
      
      #5000
      $finish;
	end

endmodule
