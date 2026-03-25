// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Tue Mar 24 22:37:15 2026
// Host        : Donaufeld running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/daniel/github/fpga_lab_sprint/FPGA/ip_repo/fpga_lab_sprint_1_0/src/dac904_mem/dac904_mem_stub.v
// Design      : dac904_mem
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *)
module dac904_mem(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="wea[0:0],addra[7:0],dina[13:0],douta[13:0]" */
/* synthesis syn_force_seq_prim="clka" */;
  input clka /* synthesis syn_isclock = 1 */;
  input [0:0]wea;
  input [7:0]addra;
  input [13:0]dina;
  output [13:0]douta;
endmodule
