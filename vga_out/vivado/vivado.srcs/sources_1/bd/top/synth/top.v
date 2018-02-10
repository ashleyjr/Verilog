//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
//Date        : Sat Feb 10 11:24:46 2018
//Host        : ashley-VirtualBox running 64-bit Ubuntu 16.04.3 LTS
//Command     : generate_target top.bd
//Design      : top
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "top,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=top,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,da_board_cnt=3,da_clkrst_cnt=1,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "top.hwdef" *) 
module top
   (B_0,
    G_0,
    R_0,
    sys_clock,
    vga_h_sync_0,
    vga_v_sync_0);
  output B_0;
  output G_0;
  output R_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.SYS_CLOCK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.SYS_CLOCK, CLK_DOMAIN top_sys_clock, FREQ_HZ 125000000, PHASE 0.000" *) input sys_clock;
  output vga_h_sync_0;
  output vga_v_sync_0;

  wire clk_wiz_clk_out1;
  wire [0:0]nRst_1;
  wire sys_clock_1;
  wire vga_out_0_B;
  wire vga_out_0_G;
  wire vga_out_0_R;
  wire vga_out_0_vga_h_sync;
  wire vga_out_0_vga_v_sync;

  assign B_0 = vga_out_0_B;
  assign G_0 = vga_out_0_G;
  assign R_0 = vga_out_0_R;
  assign sys_clock_1 = sys_clock;
  assign vga_h_sync_0 = vga_out_0_vga_h_sync;
  assign vga_v_sync_0 = vga_out_0_vga_v_sync;
  top_clk_wiz_0 clk_wiz
       (.clk_in1(sys_clock_1),
        .clk_out1(clk_wiz_clk_out1),
        .resetn(nRst_1));
  top_vga_out_0_0 vga_out_0
       (.B(vga_out_0_B),
        .G(vga_out_0_G),
        .R(vga_out_0_R),
        .clk(clk_wiz_clk_out1),
        .nRst(nRst_1),
        .vga_h_sync(vga_out_0_vga_h_sync),
        .vga_v_sync(vga_out_0_vga_v_sync));
  top_xlconstant_0_0 xlconstant_0
       (.dout(nRst_1));
endmodule
