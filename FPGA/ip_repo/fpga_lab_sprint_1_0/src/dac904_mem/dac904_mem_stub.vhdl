-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
-- Date        : Tue Mar 24 22:37:15 2026
-- Host        : Donaufeld running 64-bit Ubuntu 24.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/daniel/github/fpga_lab_sprint/FPGA/ip_repo/fpga_lab_sprint_1_0/src/dac904_mem/dac904_mem_stub.vhdl
-- Design      : dac904_mem
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dac904_mem is
  Port ( 
    clka : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 7 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 13 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 13 downto 0 )
  );

end dac904_mem;

architecture stub of dac904_mem is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,wea[0:0],addra[7:0],dina[13:0],douta[13:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_7,Vivado 2023.2";
begin
end;
