//////////////////////////////////////////////////////////////////////
////                                                              ////
////  8051 internal ram                                           ////
////                                                              ////
////  This file is part of the 8051 cores project                 ////
////  http://www.opencores.org/cores/8051/                        ////
////                                                              ////
////  Description                                                 ////
////   256 bytes two port ram                                     ////
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
//
//

// synopsys translate_off
`include "oc8051_timescale.v"
// synopsys translate_on

`include "oc8051_defines.v"

//
// two port ram
//
module oc8051_ram_256x8_two_bist (
                     clk,
                     rst,
		     rd_addr,
		     rd_data,
		     rd_en,
		     wr_addr,
		     wr_data,
		     wr_en,
		     wr
	     );


input         clk, 
              wr, 
	      rst,
	      rd_en,
	      wr_en;
input  [7:0]  wr_data;
input  [7:0]  rd_addr,
              wr_addr;
output [7:0]  rd_data;
reg    [7:0]  rd_data;

//
// buffer
reg    [7:0]  buff [0:256];


//
// writing to ram
always @(posedge clk)
begin
 if (wr)
    buff[wr_addr] <=  wr_data;
end

//
// reading from ram
always @(posedge clk or posedge rst)
begin
  if (rst)
    rd_data <=  8'h0;
  else if ((wr_addr==rd_addr) & wr & rd_en)
    rd_data <=  wr_data;
  else if (rd_en)
    rd_data <=  buff[rd_addr];
end

endmodule
