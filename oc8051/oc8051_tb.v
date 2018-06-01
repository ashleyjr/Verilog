//////////////////////////////////////////////////////////////////////
////                                                              ////
////  8051 top level test bench                                   ////
////                                                              ////
////  This file is part of the 8051 cores project                 ////
////  http://www.opencores.org/cores/8051/                        ////
////                                                              ////
////  Description                                                 ////
////   top level test bench.                                      ////
////                                                              ////
////  To Do:                                                      ////
////   nothing                                                    ////
////                                                              ////
////  Author(s):                                                  ////
////      - Simon Teran, simont@opencores.org                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.15  2003/06/05 17:14:27  simont
// Change test monitor from ports to external data memory.
//
// Revision 1.14  2003/06/05 12:54:38  simont
// remove dumpvars.
//
// Revision 1.13  2003/06/05 11:13:39  simont
// add FREQ paremeter.
//
// Revision 1.12  2003/04/16 09:55:56  simont
// add support for external rom from xilinx ramb4
//
// Revision 1.11  2003/04/10 12:45:06  simont
// defines for pherypherals added
//
// Revision 1.10  2003/04/03 19:20:55  simont
// Remove instruction cache and wb_interface
//
// Revision 1.9  2003/04/02 15:08:59  simont
// rename signals
//
// Revision 1.8  2003/01/13 14:35:25  simont
// remove wb_bus_mon
//
// Revision 1.7  2002/10/28 16:43:12  simont
// add module oc8051_wb_iinterface
//
// Revision 1.6  2002/10/24 13:36:53  simont
// add instruction cache and DELAY parameters for external ram, rom
//
// Revision 1.5  2002/10/17 19:00:50  simont
// add external rom
//
// Revision 1.4  2002/09/30 17:33:58  simont
// prepared header
//
//

// synopsys translate_off
`include "oc8051_timescale.v"
// synopsys translate_on

`include "oc8051_defines.v"


module oc8051_tb;


//parameter FREQ  = 20000; // frequency in kHz
parameter FREQ  = 12000; // frequency in kHz

parameter DELAY = 500000/FREQ;

reg  rst, clk;
reg  [7:0] p0_in, p1_in, p2_in;
wire [15:0] ext_addr, iadr_o;
wire write, write_xram, write_uart, txd, rxd, int_uart,  t0, t1, bit_out, stb_o, ack_i;
wire ack_xram, ack_uart, cyc_o, iack_i, istb_o, icyc_o, t2, t2ex;
wire [7:0] data_in, data_out, p0_out, p1_out, p2_out, p3_out, data_out_uart, data_out_xram, p3_in;
wire wbi_err_i, wbd_err_i;

`ifdef OC8051_XILINX_RAMB
  reg  [31:0] idat_i;
`else
  wire [31:0] idat_i;
`endif

///
/// buffer for test vectors
///
//
// buffer
reg [23:0] buff [0:255];

reg next;

integer num;

assign wbd_err_i = 1'b0;
assign wbi_err_i = 1'b0;

//
// oc8051 controller
//
oc8051 oc8051_top_1(
   .wb_rst_i   (rst        ), 
   .wb_clk_i   (clk        ),
   
   .wbd_dat_i  (data_in    ), 
   .wbd_we_o   (write      ), 
   .wbd_dat_o  (data_out   ),
   .wbd_adr_o  (ext_addr   ), 
   .wbd_err_i  (wbd_err_i  ),
   .wbd_ack_i  (ack_i      ), 
   .wbd_stb_o  (stb_o      ), 
   .wbd_cyc_o  (cyc_o      ),
   
   .wbi_adr_o  (iadr_o     ), 
   .wbi_stb_o  (istb_o     ), 
   .wbi_ack_i  (iack_i     ),
   .wbi_cyc_o  (icyc_o     ), 
   .wbi_dat_i  (idat_i     ), 
   .wbi_err_i  (wbi_err_i  ),

   .rd_addr    (rd_addr    ),
   .wr_addr    (wr_addr    ),
   .wr_dat     (wr_dat     ),
   .ram_data   (ram_data   ),
   .desCy      (desCy      ),
   .bit_data   (bit_data   ),
   .wr_ram     (wr_ram     ),
   .bit_addr_o (bit_addr_o )
       
);


//
// Internal data ram
//
wire  [7:0] rd_addr;
wire  [7:0] wr_addr;
wire  [7:0] wr_dat;
wire  [7:0] ram_data;
wire        desCy;
wire        bit_data;
wire        wr_ram;
wire        bit_addr_o;

oc8051_ram_top oc8051_ram_top1(
   .clk           (clk        ),
   .rst           (rst        ),
   .rd_addr       (rd_addr    ),
   .rd_data       (ram_data   ),
   .wr_addr       (wr_addr    ),
   .bit_addr      (bit_addr_o ),
   .wr_data       (wr_dat     ),
   .wr            (wr_ram     ),
   .bit_data_in   (desCy      ),
   .bit_data_out  (bit_data   )
);



//
// external data ram
//
oc8051_xram oc8051_xram1 (
    .clk(clk), 
    .rst(rst), 
    .wr(write_xram), 
    .addr(ext_addr), 
    .data_in(data_out), 
    .data_out(data_out_xram), 
    .ack(ack_xram), 
    .stb(stb_o)
);


defparam oc8051_xram1.DELAY = 2;


//
// external rom
//
oc8051_xrom oc8051_xrom1(
    .rst(rst), 
    .clk(clk), 
    .addr(iadr_o),
    .data(idat_i),
    .stb_i(istb_o), 
    .cyc_i(icyc_o), 
    .ack_o(iack_i)
);

defparam oc8051_xrom1.DELAY = 0;




assign write_xram = write;
assign write_uart = !p3_out[7] & write;
assign data_in = data_out_xram ;
assign ack_i = ack_xram ;
assign p3_in = {6'h0, bit_out, int_uart};
assign t0 = p3_out[5];
assign t1 = p3_out[6];


assign t2 = p3_out[5];
assign t2ex = p3_out[2];


task test_code;  
   begin
      @(posedge next);  
      rst = 1'b1;
      #220
      rst = 1'b0;
   end
endtask

initial begin
   rst= 1'b1;
   p0_in = 8'h00;
   p1_in = 8'h00;
   p2_in = 8'h00;
   #220
   rst = 1'b0; 
   //$readmemh("code/leds.mem", oc8051_xrom1.buff);        test_code(); 
   $readmemh("code/loop.mem", oc8051_xrom1.buff);        test_code(); 
   $readmemh("code/function.mem", oc8051_xrom1.buff);    test_code();
   $readmemh("code/fib.mem", oc8051_xrom1.buff);         test_code();
   $readmemh("code/fib_large.mem", oc8051_xrom1.buff);   test_code();
   $finish;
end

integer test_time;
initial begin
   test_time = 0;
   forever begin
      #1 
      test_time = test_time + 1;
      if(next)
         test_time = 0;
      if(test_time > 1000000) begin
         $display("time ",$time, " Fail: Timeout");
         $finish;
      end
   end
end

initial
begin
  clk = 0;
  forever #DELAY clk <= ~clk;
end


reg [15:0] interest;

always @(ext_addr or write or stb_o or data_out)
begin
   
   // Terminate
   next = 0;
  if ((ext_addr==16'h0010) & write & stb_o) begin
    if (data_out==8'h7f) begin
      $display("time ",$time, " Passed");
      next = 1;
    end else begin 
      $display("time ",$time," Error: %h", data_out);
      $finish;
    end
  end

   // Data of interest
   if (write & stb_o) begin
     if(ext_addr==16'h0) begin
         $display("time ",$time," Interest bottom byte");
         interest[7:0] = data_out;
      end
      if(ext_addr==16'h1) begin
         $display("time ",$time," Interest topm byte");
         interest[15:8] = data_out;
      end
       $display("time ",$time," Interest: %h,%d", interest, interest);
   end
end

initial begin
	$dumpfile("oc8051.vcd");
	$dumpvars(0,oc8051_tb);	
end


endmodule
