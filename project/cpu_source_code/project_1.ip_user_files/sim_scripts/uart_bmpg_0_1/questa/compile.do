vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv \
"E:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"E:/Vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
"../../../../project_1.srcs/sources_1/ip/uart_bmpg_0_1/uart_bmpg.v" \
"../../../../project_1.srcs/sources_1/ip/uart_bmpg_0_1/upg.v" \
"../../../../project_1.srcs/sources_1/ip/uart_bmpg_0_1/sim/uart_bmpg_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

