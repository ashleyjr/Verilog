// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Wed Feb  7 21:38:27 2018
// Host        : ashley-VirtualBox running 64-bit Ubuntu 16.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/ashley/Verilog/vga_out/vivado/vivado.srcs/sources_1/bd/top/ip/top_vga_out_0_0/top_vga_out_0_0_stub.v
// Design      : top_vga_out_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vga_out,Vivado 2017.4" *)
module top_vga_out_0_0(clk, nRst, vga_h_sync, vga_v_sync, R, G, B)
/* synthesis syn_black_box black_box_pad_pin="clk,nRst,vga_h_sync,vga_v_sync,R,G,B" */;
  input clk;
  input nRst;
  output vga_h_sync;
  output vga_v_sync;
  output R;
  output G;
  output B;
endmodule
