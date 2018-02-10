-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
-- Date        : Wed Feb  7 21:38:27 2018
-- Host        : ashley-VirtualBox running 64-bit Ubuntu 16.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/ashley/Verilog/vga_out/vivado/vivado.srcs/sources_1/bd/top/ip/top_vga_out_0_0/top_vga_out_0_0_stub.vhdl
-- Design      : top_vga_out_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_vga_out_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    nRst : in STD_LOGIC;
    vga_h_sync : out STD_LOGIC;
    vga_v_sync : out STD_LOGIC;
    R : out STD_LOGIC;
    G : out STD_LOGIC;
    B : out STD_LOGIC
  );

end top_vga_out_0_0;

architecture stub of top_vga_out_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,nRst,vga_h_sync,vga_v_sync,R,G,B";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vga_out,Vivado 2017.4";
begin
end;
