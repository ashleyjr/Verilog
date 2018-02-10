vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/xlconstant_v1_1_3

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap xlconstant_v1_1_3 activehdl/xlconstant_v1_1_3

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" \
"/opt/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"/opt/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" \
"../../../bd/top/ip/top_vga_out_0_0/sim/top_vga_out_0_0.v" \
"../../../bd/top/ip/top_clk_wiz_0/top_clk_wiz_0_clk_wiz.v" \
"../../../bd/top/ip/top_clk_wiz_0/top_clk_wiz_0.v" \
"../../../bd/top/sim/top.v" \

vlog -work xlconstant_v1_1_3  -v2k5 "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" \
"../../../../vivado.srcs/sources_1/bd/top/ipshared/0750/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" "+incdir+../../../../vivado.srcs/sources_1/bd/top/ipshared/4868" \
"../../../bd/top/ip/top_xlconstant_0_0/sim/top_xlconstant_0_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

