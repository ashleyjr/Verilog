// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Wed Feb  7 21:38:27 2018
// Host        : ashley-VirtualBox running 64-bit Ubuntu 16.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/ashley/Verilog/vga_out/vivado/vivado.srcs/sources_1/bd/top/ip/top_vga_out_0_0/top_vga_out_0_0_sim_netlist.v
// Design      : top_vga_out_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "top_vga_out_0_0,vga_out,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "vga_out,Vivado 2017.4" *) 
(* NotValidForBitStream *)
module top_vga_out_0_0
   (clk,
    nRst,
    vga_h_sync,
    vga_v_sync,
    R,
    G,
    B);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 25000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_clk_out1" *) input clk;
  input nRst;
  output vga_h_sync;
  output vga_v_sync;
  output R;
  output G;
  output B;

  wire B;
  wire G;
  wire R;
  wire clk;
  wire nRst;
  wire vga_h_sync;
  wire vga_v_sync;

  top_vga_out_0_0_vga_out inst
       (.B(B),
        .G(G),
        .R(R),
        .clk(clk),
        .nRst(nRst),
        .vga_h_sync(vga_h_sync),
        .vga_v_sync(vga_v_sync));
endmodule

(* ORIG_REF_NAME = "vga_out" *) 
module top_vga_out_0_0_vga_out
   (G,
    B,
    R,
    vga_h_sync,
    vga_v_sync,
    clk,
    nRst);
  output G;
  output B;
  output R;
  output vga_h_sync;
  output vga_v_sync;
  input clk;
  input nRst;

  wire B;
  wire \CounterX[9]_i_2_n_0 ;
  wire \CounterX[9]_i_3_n_0 ;
  wire [9:0]CounterX_reg__0;
  wire \CounterY[6]_i_1_n_0 ;
  wire \CounterY[8]_i_1_n_0 ;
  wire \CounterY[8]_i_3_n_0 ;
  wire [8:0]CounterY_reg__0;
  wire [3:3]CounterY_reg__1;
  wire G;
  wire R;
  wire R_INST_0_i_1_n_0;
  wire clk;
  wire nRst;
  wire [9:0]p_0_in;
  wire [8:0]p_0_in__0;
  wire p_0_in__1;
  wire vga_HS_inv_i_2_n_0;
  wire vga_VS_inv_i_1_n_0;
  wire vga_VS_inv_i_2_n_0;
  wire vga_h_sync;
  wire vga_v_sync;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFF0001)) 
    B_INST_0
       (.I0(R_INST_0_i_1_n_0),
        .I1(CounterX_reg__0[6]),
        .I2(CounterX_reg__0[5]),
        .I3(CounterX_reg__0[7]),
        .I4(CounterX_reg__0[4]),
        .O(B));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \CounterX[0]_i_1 
       (.I0(CounterX_reg__0[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \CounterX[1]_i_1 
       (.I0(CounterX_reg__0[0]),
        .I1(CounterX_reg__0[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \CounterX[2]_i_1 
       (.I0(CounterX_reg__0[2]),
        .I1(CounterX_reg__0[0]),
        .I2(CounterX_reg__0[1]),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \CounterX[3]_i_1 
       (.I0(CounterX_reg__0[3]),
        .I1(CounterX_reg__0[1]),
        .I2(CounterX_reg__0[0]),
        .I3(CounterX_reg__0[2]),
        .O(p_0_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \CounterX[4]_i_1 
       (.I0(CounterX_reg__0[4]),
        .I1(CounterX_reg__0[2]),
        .I2(CounterX_reg__0[0]),
        .I3(CounterX_reg__0[1]),
        .I4(CounterX_reg__0[3]),
        .O(p_0_in[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \CounterX[5]_i_1 
       (.I0(CounterX_reg__0[5]),
        .I1(CounterX_reg__0[2]),
        .I2(CounterX_reg__0[0]),
        .I3(CounterX_reg__0[1]),
        .I4(CounterX_reg__0[3]),
        .I5(CounterX_reg__0[4]),
        .O(p_0_in[5]));
  LUT4 #(
    .INIT(16'hA6AA)) 
    \CounterX[6]_i_1 
       (.I0(CounterX_reg__0[6]),
        .I1(CounterX_reg__0[4]),
        .I2(\CounterX[9]_i_2_n_0 ),
        .I3(CounterX_reg__0[5]),
        .O(p_0_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    \CounterX[7]_i_1 
       (.I0(CounterX_reg__0[7]),
        .I1(CounterX_reg__0[5]),
        .I2(\CounterX[9]_i_2_n_0 ),
        .I3(CounterX_reg__0[4]),
        .I4(CounterX_reg__0[6]),
        .O(p_0_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hE0E1)) 
    \CounterX[8]_i_1 
       (.I0(\CounterX[9]_i_2_n_0 ),
        .I1(\CounterX[9]_i_3_n_0 ),
        .I2(CounterX_reg__0[8]),
        .I3(CounterX_reg__0[9]),
        .O(p_0_in[8]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hFC02)) 
    \CounterX[9]_i_1 
       (.I0(CounterX_reg__0[8]),
        .I1(\CounterX[9]_i_2_n_0 ),
        .I2(\CounterX[9]_i_3_n_0 ),
        .I3(CounterX_reg__0[9]),
        .O(p_0_in[9]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \CounterX[9]_i_2 
       (.I0(CounterX_reg__0[2]),
        .I1(CounterX_reg__0[0]),
        .I2(CounterX_reg__0[1]),
        .I3(CounterX_reg__0[3]),
        .O(\CounterX[9]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \CounterX[9]_i_3 
       (.I0(CounterX_reg__0[5]),
        .I1(CounterX_reg__0[4]),
        .I2(CounterX_reg__0[7]),
        .I3(CounterX_reg__0[6]),
        .O(\CounterX[9]_i_3_n_0 ));
  FDCE \CounterX_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[0]),
        .Q(CounterX_reg__0[0]));
  FDCE \CounterX_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[1]),
        .Q(CounterX_reg__0[1]));
  FDCE \CounterX_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[2]),
        .Q(CounterX_reg__0[2]));
  FDCE \CounterX_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[3]),
        .Q(CounterX_reg__0[3]));
  FDCE \CounterX_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[4]),
        .Q(CounterX_reg__0[4]));
  FDCE \CounterX_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[5]),
        .Q(CounterX_reg__0[5]));
  FDCE \CounterX_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[6]),
        .Q(CounterX_reg__0[6]));
  FDCE \CounterX_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[7]),
        .Q(CounterX_reg__0[7]));
  FDCE \CounterX_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[8]),
        .Q(CounterX_reg__0[8]));
  FDCE \CounterX_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in[9]),
        .Q(CounterX_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \CounterY[0]_i_1 
       (.I0(CounterY_reg__0[0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \CounterY[1]_i_1 
       (.I0(CounterY_reg__0[0]),
        .I1(CounterY_reg__0[1]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \CounterY[2]_i_1 
       (.I0(CounterY_reg__0[2]),
        .I1(CounterY_reg__0[0]),
        .I2(CounterY_reg__0[1]),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \CounterY[3]_i_1 
       (.I0(CounterY_reg__0[1]),
        .I1(CounterY_reg__0[0]),
        .I2(CounterY_reg__0[2]),
        .I3(CounterY_reg__1),
        .O(p_0_in__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \CounterY[4]_i_1 
       (.I0(CounterY_reg__0[4]),
        .I1(CounterY_reg__0[1]),
        .I2(CounterY_reg__0[0]),
        .I3(CounterY_reg__0[2]),
        .I4(CounterY_reg__1),
        .O(p_0_in__0[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \CounterY[5]_i_1 
       (.I0(CounterY_reg__0[5]),
        .I1(CounterY_reg__1),
        .I2(CounterY_reg__0[2]),
        .I3(CounterY_reg__0[0]),
        .I4(CounterY_reg__0[1]),
        .I5(CounterY_reg__0[4]),
        .O(p_0_in__0[5]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \CounterY[6]_i_1 
       (.I0(CounterY_reg__0[6]),
        .I1(CounterY_reg__0[4]),
        .I2(\CounterY[8]_i_3_n_0 ),
        .I3(CounterY_reg__0[5]),
        .O(\CounterY[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \CounterY[7]_i_1 
       (.I0(CounterY_reg__0[7]),
        .I1(CounterY_reg__0[5]),
        .I2(\CounterY[8]_i_3_n_0 ),
        .I3(CounterY_reg__0[4]),
        .I4(CounterY_reg__0[6]),
        .O(p_0_in__0[7]));
  LUT4 #(
    .INIT(16'h0004)) 
    \CounterY[8]_i_1 
       (.I0(CounterX_reg__0[8]),
        .I1(CounterX_reg__0[9]),
        .I2(\CounterX[9]_i_3_n_0 ),
        .I3(\CounterX[9]_i_2_n_0 ),
        .O(\CounterY[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \CounterY[8]_i_2 
       (.I0(CounterY_reg__0[8]),
        .I1(CounterY_reg__0[6]),
        .I2(CounterY_reg__0[4]),
        .I3(\CounterY[8]_i_3_n_0 ),
        .I4(CounterY_reg__0[5]),
        .I5(CounterY_reg__0[7]),
        .O(p_0_in__0[8]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \CounterY[8]_i_3 
       (.I0(CounterY_reg__1),
        .I1(CounterY_reg__0[2]),
        .I2(CounterY_reg__0[0]),
        .I3(CounterY_reg__0[1]),
        .O(\CounterY[8]_i_3_n_0 ));
  FDCE \CounterY_reg[0] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[0]),
        .Q(CounterY_reg__0[0]));
  FDCE \CounterY_reg[1] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[1]),
        .Q(CounterY_reg__0[1]));
  FDCE \CounterY_reg[2] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[2]),
        .Q(CounterY_reg__0[2]));
  FDCE \CounterY_reg[3] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[3]),
        .Q(CounterY_reg__1));
  FDCE \CounterY_reg[4] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[4]),
        .Q(CounterY_reg__0[4]));
  FDCE \CounterY_reg[5] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[5]),
        .Q(CounterY_reg__0[5]));
  FDCE \CounterY_reg[6] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(\CounterY[6]_i_1_n_0 ),
        .Q(CounterY_reg__0[6]));
  FDCE \CounterY_reg[7] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[7]),
        .Q(CounterY_reg__0[7]));
  FDCE \CounterY_reg[8] 
       (.C(clk),
        .CE(\CounterY[8]_i_1_n_0 ),
        .CLR(vga_HS_inv_i_2_n_0),
        .D(p_0_in__0[8]),
        .Q(CounterY_reg__0[8]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00FFFF01)) 
    G_INST_0
       (.I0(R_INST_0_i_1_n_0),
        .I1(CounterX_reg__0[7]),
        .I2(CounterX_reg__0[4]),
        .I3(CounterX_reg__0[6]),
        .I4(CounterX_reg__0[5]),
        .O(G));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAAAAAB)) 
    R_INST_0
       (.I0(CounterY_reg__1),
        .I1(R_INST_0_i_1_n_0),
        .I2(CounterX_reg__0[6]),
        .I3(CounterX_reg__0[5]),
        .I4(CounterX_reg__0[7]),
        .I5(CounterX_reg__0[4]),
        .O(R));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFD)) 
    R_INST_0_i_1
       (.I0(CounterX_reg__0[8]),
        .I1(CounterX_reg__0[9]),
        .I2(CounterX_reg__0[0]),
        .I3(CounterX_reg__0[1]),
        .I4(CounterX_reg__0[2]),
        .I5(CounterX_reg__0[3]),
        .O(R_INST_0_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    vga_HS_inv_i_1
       (.I0(CounterX_reg__0[4]),
        .I1(CounterX_reg__0[7]),
        .I2(CounterX_reg__0[5]),
        .I3(CounterX_reg__0[6]),
        .I4(CounterX_reg__0[9]),
        .I5(CounterX_reg__0[8]),
        .O(p_0_in__1));
  LUT1 #(
    .INIT(2'h1)) 
    vga_HS_inv_i_2
       (.I0(nRst),
        .O(vga_HS_inv_i_2_n_0));
  FDPE vga_HS_reg_inv
       (.C(clk),
        .CE(1'b1),
        .D(p_0_in__1),
        .PRE(vga_HS_inv_i_2_n_0),
        .Q(vga_h_sync));
  LUT4 #(
    .INIT(16'hFFFE)) 
    vga_VS_inv_i_1
       (.I0(CounterY_reg__0[7]),
        .I1(CounterY_reg__0[8]),
        .I2(CounterY_reg__0[6]),
        .I3(vga_VS_inv_i_2_n_0),
        .O(vga_VS_inv_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    vga_VS_inv_i_2
       (.I0(CounterY_reg__0[1]),
        .I1(CounterY_reg__0[0]),
        .I2(CounterY_reg__0[4]),
        .I3(CounterY_reg__0[5]),
        .I4(CounterY_reg__1),
        .I5(CounterY_reg__0[2]),
        .O(vga_VS_inv_i_2_n_0));
  FDPE vga_VS_reg_inv
       (.C(clk),
        .CE(1'b1),
        .D(vga_VS_inv_i_1_n_0),
        .PRE(vga_HS_inv_i_2_n_0),
        .Q(vga_v_sync));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
