// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Tue Mar 24 22:37:15 2026
// Host        : Donaufeld running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/daniel/github/fpga_lab_sprint/FPGA/ip_repo/fpga_lab_sprint_1_0/src/dac904_mem/dac904_mem_sim_netlist.v
// Design      : dac904_mem
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dac904_mem,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module dac904_mem
   (clka,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [13:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [13:0]douta;

  wire [7:0]addra;
  wire clka;
  wire [13:0]dina;
  wire [13:0]douta;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [13:0]NLW_U0_doutb_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [13:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.78965 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "dac904_mem.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "255" *) 
  (* C_READ_DEPTH_B = "255" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "14" *) 
  (* C_READ_WIDTH_B = "14" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "255" *) 
  (* C_WRITE_DEPTH_B = "255" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "14" *) 
  (* C_WRITE_WIDTH_B = "14" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  dac904_mem_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[13:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[13:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20304)
`pragma protect data_block
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
WdNOb5ExGSIXeyEd
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
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
    reg GRESTORE_int;

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
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

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

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
