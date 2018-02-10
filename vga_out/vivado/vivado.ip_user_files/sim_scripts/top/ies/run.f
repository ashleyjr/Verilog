-makelib ies_lib/xil_defaultlib -sv \
  "/opt/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "/opt/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/top/ip/top_vga_out_0_0/sim/top_vga_out_0_0.v" \
  "../../../bd/top/ip/top_clk_wiz_0/top_clk_wiz_0_clk_wiz.v" \
  "../../../bd/top/ip/top_clk_wiz_0/top_clk_wiz_0.v" \
  "../../../bd/top/sim/top.v" \
-endlib
-makelib ies_lib/xlconstant_v1_1_3 \
  "../../../../vivado.srcs/sources_1/bd/top/ipshared/0750/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/top/ip/top_xlconstant_0_0/sim/top_xlconstant_0_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

