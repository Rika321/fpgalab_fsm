vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../fpgalab4_fsm.srcs/sources_1/ip/clk_wiz/clk_wiz_sim_netlist.v" \


vlog -work xil_defaultlib "glbl.v"

