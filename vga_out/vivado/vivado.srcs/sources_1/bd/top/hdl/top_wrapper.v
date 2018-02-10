//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
//Date        : Sat Feb 10 11:24:47 2018
//Host        : ashley-VirtualBox running 64-bit Ubuntu 16.04.3 LTS
//Command     : generate_target top_wrapper.bd
//Design      : top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top_wrapper
   (B_0,
    G_0,
    R_0,
    sys_clock,
    vga_h_sync_0,
    vga_v_sync_0);
  output B_0;
  output G_0;
  output R_0;
  input sys_clock;
  output vga_h_sync_0;
  output vga_v_sync_0;

  wire B_0;
  wire G_0;
  wire R_0;
  wire sys_clock;
  wire vga_h_sync_0;
  wire vga_v_sync_0;

  top top_i
       (.B_0(B_0),
        .G_0(G_0),
        .R_0(R_0),
        .sys_clock(sys_clock),
        .vga_h_sync_0(vga_h_sync_0),
        .vga_v_sync_0(vga_v_sync_0));
endmodule
