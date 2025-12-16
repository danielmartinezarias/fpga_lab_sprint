# project creation
create_project project FPGA/project -part xc7z020clg484-1
# set part
set_property board_part digilentinc.com:zedboard:part0:1.1 [current_project]
# set constraints
add_files -fileset constrs_1 -norecurse FPGA/srcs/constraints/Zedboard-Master.xdc
# add user ip repo
set_property  ip_repo_paths  FPGA/ip_repo/fpga_lab_sprint_1_0 [current_project]
update_ip_catalog
# create block design
create_bd_design "design_1"
update_compile_order -fileset sources_1
# add Zynq7
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
# add fpga_lab_sprint ip
startgroup
create_bd_cell -type ip -vlnv user.org:user:fpga_lab_sprint:1.0 fpga_lab_sprint_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/fpga_lab_sprint_0/S00_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins fpga_lab_sprint_0/S00_AXI]
# add clocking wizard
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
endgroup
set_property -dict [list \
  CONFIG.CLKOUT1_JITTER {126.133} \
  CONFIG.CLKOUT1_PHASE_ERROR {94.994} \
  CONFIG.CLKOUT2_JITTER {99.963} \
  CONFIG.CLKOUT2_PHASE_ERROR {94.994} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {350} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.CLK_OUT1_PORT {clk100MHz} \
  CONFIG.CLK_OUT2_PORT {clk350MHz} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {10.500} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.500} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {3} \
  CONFIG.NUM_OUT_CLKS {2} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
] [get_bd_cells clk_wiz_0]
# create ports and make connections
create_bd_port -dir O -from 7 -to 0 led
create_bd_port -dir IO -from 31 -to 0 gpio_breakout
connect_bd_net [get_bd_ports led] [get_bd_pins fpga_lab_sprint_0/led]
connect_bd_net [get_bd_ports gpio_breakout] [get_bd_pins fpga_lab_sprint_0/gpio_breakout]
connect_bd_net [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins clk_wiz_0/clk100MHz] [get_bd_pins fpga_lab_sprint_0/clk_100MHz]
connect_bd_net [get_bd_pins clk_wiz_0/clk350MHz] [get_bd_pins fpga_lab_sprint_0/clk_350MHz]
# create HDL Wrapper
make_wrapper -files [get_files FPGA/project/project.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse FPGA/project/project.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
# enable BIN file generation
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
# Synth, Impl, Bitsteam
launch_runs impl_1 -to_step write_bitstream -jobs 12
wait_on_run -timeout 180 impl_1
# Generate XSA Hardware file
file rm FPGA/outputs/design_1_wrapper.xsa
write_hw_platform -fixed -include_bit -force -file FPGA/outputs/design_1_wrapper.xsa
file copy -force FPGA/project/project.runs/impl_1/design_1_wrapper.bit FPGA/outputs/
file copy -force FPGA/project/project.runs/impl_1/design_1_wrapper.bin FPGA/outputs/
