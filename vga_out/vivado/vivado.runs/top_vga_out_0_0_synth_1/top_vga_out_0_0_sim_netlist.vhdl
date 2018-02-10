-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
-- Date        : Wed Feb  7 21:38:26 2018
-- Host        : ashley-VirtualBox running 64-bit Ubuntu 16.04.3 LTS
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ top_vga_out_0_0_sim_netlist.vhdl
-- Design      : top_vga_out_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vga_out is
  port (
    G : out STD_LOGIC;
    B : out STD_LOGIC;
    R : out STD_LOGIC;
    vga_h_sync : out STD_LOGIC;
    vga_v_sync : out STD_LOGIC;
    clk : in STD_LOGIC;
    nRst : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vga_out;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vga_out is
  signal \CounterX[9]_i_2_n_0\ : STD_LOGIC;
  signal \CounterX[9]_i_3_n_0\ : STD_LOGIC;
  signal \CounterX_reg__0\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \CounterY[6]_i_1_n_0\ : STD_LOGIC;
  signal \CounterY[8]_i_1_n_0\ : STD_LOGIC;
  signal \CounterY[8]_i_3_n_0\ : STD_LOGIC;
  signal \CounterY_reg__0\ : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal \CounterY_reg__1\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal R_INST_0_i_1_n_0 : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal \p_0_in__1\ : STD_LOGIC;
  signal vga_HS_inv_i_2_n_0 : STD_LOGIC;
  signal vga_VS_inv_i_1_n_0 : STD_LOGIC;
  signal vga_VS_inv_i_2_n_0 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of B_INST_0 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \CounterX[0]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \CounterX[1]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \CounterX[2]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \CounterX[3]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \CounterX[4]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \CounterX[7]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \CounterX[8]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \CounterX[9]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \CounterX[9]_i_2\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \CounterX[9]_i_3\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \CounterY[0]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \CounterY[1]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \CounterY[2]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \CounterY[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \CounterY[4]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \CounterY[6]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \CounterY[7]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \CounterY[8]_i_3\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of G_INST_0 : label is "soft_lutpair1";
begin
B_INST_0: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0001"
    )
        port map (
      I0 => R_INST_0_i_1_n_0,
      I1 => \CounterX_reg__0\(6),
      I2 => \CounterX_reg__0\(5),
      I3 => \CounterX_reg__0\(7),
      I4 => \CounterX_reg__0\(4),
      O => B
    );
\CounterX[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \CounterX_reg__0\(0),
      O => p_0_in(0)
    );
\CounterX[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \CounterX_reg__0\(0),
      I1 => \CounterX_reg__0\(1),
      O => p_0_in(1)
    );
\CounterX[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \CounterX_reg__0\(2),
      I1 => \CounterX_reg__0\(0),
      I2 => \CounterX_reg__0\(1),
      O => p_0_in(2)
    );
\CounterX[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \CounterX_reg__0\(3),
      I1 => \CounterX_reg__0\(1),
      I2 => \CounterX_reg__0\(0),
      I3 => \CounterX_reg__0\(2),
      O => p_0_in(3)
    );
\CounterX[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \CounterX_reg__0\(4),
      I1 => \CounterX_reg__0\(2),
      I2 => \CounterX_reg__0\(0),
      I3 => \CounterX_reg__0\(1),
      I4 => \CounterX_reg__0\(3),
      O => p_0_in(4)
    );
\CounterX[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \CounterX_reg__0\(5),
      I1 => \CounterX_reg__0\(2),
      I2 => \CounterX_reg__0\(0),
      I3 => \CounterX_reg__0\(1),
      I4 => \CounterX_reg__0\(3),
      I5 => \CounterX_reg__0\(4),
      O => p_0_in(5)
    );
\CounterX[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A6AA"
    )
        port map (
      I0 => \CounterX_reg__0\(6),
      I1 => \CounterX_reg__0\(4),
      I2 => \CounterX[9]_i_2_n_0\,
      I3 => \CounterX_reg__0\(5),
      O => p_0_in(6)
    );
\CounterX[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A6AAAAAA"
    )
        port map (
      I0 => \CounterX_reg__0\(7),
      I1 => \CounterX_reg__0\(5),
      I2 => \CounterX[9]_i_2_n_0\,
      I3 => \CounterX_reg__0\(4),
      I4 => \CounterX_reg__0\(6),
      O => p_0_in(7)
    );
\CounterX[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E0E1"
    )
        port map (
      I0 => \CounterX[9]_i_2_n_0\,
      I1 => \CounterX[9]_i_3_n_0\,
      I2 => \CounterX_reg__0\(8),
      I3 => \CounterX_reg__0\(9),
      O => p_0_in(8)
    );
\CounterX[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FC02"
    )
        port map (
      I0 => \CounterX_reg__0\(8),
      I1 => \CounterX[9]_i_2_n_0\,
      I2 => \CounterX[9]_i_3_n_0\,
      I3 => \CounterX_reg__0\(9),
      O => p_0_in(9)
    );
\CounterX[9]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \CounterX_reg__0\(2),
      I1 => \CounterX_reg__0\(0),
      I2 => \CounterX_reg__0\(1),
      I3 => \CounterX_reg__0\(3),
      O => \CounterX[9]_i_2_n_0\
    );
\CounterX[9]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \CounterX_reg__0\(5),
      I1 => \CounterX_reg__0\(4),
      I2 => \CounterX_reg__0\(7),
      I3 => \CounterX_reg__0\(6),
      O => \CounterX[9]_i_3_n_0\
    );
\CounterX_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(0),
      Q => \CounterX_reg__0\(0)
    );
\CounterX_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(1),
      Q => \CounterX_reg__0\(1)
    );
\CounterX_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(2),
      Q => \CounterX_reg__0\(2)
    );
\CounterX_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(3),
      Q => \CounterX_reg__0\(3)
    );
\CounterX_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(4),
      Q => \CounterX_reg__0\(4)
    );
\CounterX_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(5),
      Q => \CounterX_reg__0\(5)
    );
\CounterX_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(6),
      Q => \CounterX_reg__0\(6)
    );
\CounterX_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(7),
      Q => \CounterX_reg__0\(7)
    );
\CounterX_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(8),
      Q => \CounterX_reg__0\(8)
    );
\CounterX_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => '1',
      CLR => vga_HS_inv_i_2_n_0,
      D => p_0_in(9),
      Q => \CounterX_reg__0\(9)
    );
\CounterY[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \CounterY_reg__0\(0),
      O => \p_0_in__0\(0)
    );
\CounterY[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \CounterY_reg__0\(0),
      I1 => \CounterY_reg__0\(1),
      O => \p_0_in__0\(1)
    );
\CounterY[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \CounterY_reg__0\(2),
      I1 => \CounterY_reg__0\(0),
      I2 => \CounterY_reg__0\(1),
      O => \p_0_in__0\(2)
    );
\CounterY[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \CounterY_reg__0\(1),
      I1 => \CounterY_reg__0\(0),
      I2 => \CounterY_reg__0\(2),
      I3 => \CounterY_reg__1\(3),
      O => \p_0_in__0\(3)
    );
\CounterY[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \CounterY_reg__0\(4),
      I1 => \CounterY_reg__0\(1),
      I2 => \CounterY_reg__0\(0),
      I3 => \CounterY_reg__0\(2),
      I4 => \CounterY_reg__1\(3),
      O => \p_0_in__0\(4)
    );
\CounterY[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \CounterY_reg__0\(5),
      I1 => \CounterY_reg__1\(3),
      I2 => \CounterY_reg__0\(2),
      I3 => \CounterY_reg__0\(0),
      I4 => \CounterY_reg__0\(1),
      I5 => \CounterY_reg__0\(4),
      O => \p_0_in__0\(5)
    );
\CounterY[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \CounterY_reg__0\(6),
      I1 => \CounterY_reg__0\(4),
      I2 => \CounterY[8]_i_3_n_0\,
      I3 => \CounterY_reg__0\(5),
      O => \CounterY[6]_i_1_n_0\
    );
\CounterY[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \CounterY_reg__0\(7),
      I1 => \CounterY_reg__0\(5),
      I2 => \CounterY[8]_i_3_n_0\,
      I3 => \CounterY_reg__0\(4),
      I4 => \CounterY_reg__0\(6),
      O => \p_0_in__0\(7)
    );
\CounterY[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => \CounterX_reg__0\(8),
      I1 => \CounterX_reg__0\(9),
      I2 => \CounterX[9]_i_3_n_0\,
      I3 => \CounterX[9]_i_2_n_0\,
      O => \CounterY[8]_i_1_n_0\
    );
\CounterY[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \CounterY_reg__0\(8),
      I1 => \CounterY_reg__0\(6),
      I2 => \CounterY_reg__0\(4),
      I3 => \CounterY[8]_i_3_n_0\,
      I4 => \CounterY_reg__0\(5),
      I5 => \CounterY_reg__0\(7),
      O => \p_0_in__0\(8)
    );
\CounterY[8]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \CounterY_reg__1\(3),
      I1 => \CounterY_reg__0\(2),
      I2 => \CounterY_reg__0\(0),
      I3 => \CounterY_reg__0\(1),
      O => \CounterY[8]_i_3_n_0\
    );
\CounterY_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(0),
      Q => \CounterY_reg__0\(0)
    );
\CounterY_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(1),
      Q => \CounterY_reg__0\(1)
    );
\CounterY_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(2),
      Q => \CounterY_reg__0\(2)
    );
\CounterY_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(3),
      Q => \CounterY_reg__1\(3)
    );
\CounterY_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(4),
      Q => \CounterY_reg__0\(4)
    );
\CounterY_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(5),
      Q => \CounterY_reg__0\(5)
    );
\CounterY_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \CounterY[6]_i_1_n_0\,
      Q => \CounterY_reg__0\(6)
    );
\CounterY_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(7),
      Q => \CounterY_reg__0\(7)
    );
\CounterY_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => clk,
      CE => \CounterY[8]_i_1_n_0\,
      CLR => vga_HS_inv_i_2_n_0,
      D => \p_0_in__0\(8),
      Q => \CounterY_reg__0\(8)
    );
G_INST_0: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00FFFF01"
    )
        port map (
      I0 => R_INST_0_i_1_n_0,
      I1 => \CounterX_reg__0\(7),
      I2 => \CounterX_reg__0\(4),
      I3 => \CounterX_reg__0\(6),
      I4 => \CounterX_reg__0\(5),
      O => G
    );
R_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAAAAAB"
    )
        port map (
      I0 => \CounterY_reg__1\(3),
      I1 => R_INST_0_i_1_n_0,
      I2 => \CounterX_reg__0\(6),
      I3 => \CounterX_reg__0\(5),
      I4 => \CounterX_reg__0\(7),
      I5 => \CounterX_reg__0\(4),
      O => R
    );
R_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFD"
    )
        port map (
      I0 => \CounterX_reg__0\(8),
      I1 => \CounterX_reg__0\(9),
      I2 => \CounterX_reg__0\(0),
      I3 => \CounterX_reg__0\(1),
      I4 => \CounterX_reg__0\(2),
      I5 => \CounterX_reg__0\(3),
      O => R_INST_0_i_1_n_0
    );
vga_HS_inv_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \CounterX_reg__0\(4),
      I1 => \CounterX_reg__0\(7),
      I2 => \CounterX_reg__0\(5),
      I3 => \CounterX_reg__0\(6),
      I4 => \CounterX_reg__0\(9),
      I5 => \CounterX_reg__0\(8),
      O => \p_0_in__1\
    );
vga_HS_inv_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => nRst,
      O => vga_HS_inv_i_2_n_0
    );
vga_HS_reg_inv: unisim.vcomponents.FDPE
     port map (
      C => clk,
      CE => '1',
      D => \p_0_in__1\,
      PRE => vga_HS_inv_i_2_n_0,
      Q => vga_h_sync
    );
vga_VS_inv_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \CounterY_reg__0\(7),
      I1 => \CounterY_reg__0\(8),
      I2 => \CounterY_reg__0\(6),
      I3 => vga_VS_inv_i_2_n_0,
      O => vga_VS_inv_i_1_n_0
    );
vga_VS_inv_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \CounterY_reg__0\(1),
      I1 => \CounterY_reg__0\(0),
      I2 => \CounterY_reg__0\(4),
      I3 => \CounterY_reg__0\(5),
      I4 => \CounterY_reg__1\(3),
      I5 => \CounterY_reg__0\(2),
      O => vga_VS_inv_i_2_n_0
    );
vga_VS_reg_inv: unisim.vcomponents.FDPE
     port map (
      C => clk,
      CE => '1',
      D => vga_VS_inv_i_1_n_0,
      PRE => vga_HS_inv_i_2_n_0,
      Q => vga_v_sync
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    clk : in STD_LOGIC;
    nRst : in STD_LOGIC;
    vga_h_sync : out STD_LOGIC;
    vga_v_sync : out STD_LOGIC;
    R : out STD_LOGIC;
    G : out STD_LOGIC;
    B : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "top_vga_out_0_0,vga_out,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "vga_out,Vivado 2017.4";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 25000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_clk_out1";
begin
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vga_out
     port map (
      B => B,
      G => G,
      R => R,
      clk => clk,
      nRst => nRst,
      vga_h_sync => vga_h_sync,
      vga_v_sync => vga_v_sync
    );
end STRUCTURE;
