// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Fri Nov 20 14:30:25 2026
// Host        : Donaufeld running 64-bit Ubuntu 24.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/daniel/github/fpga_lab_sprint/FPGA/ip_repo/fpga_lab_sprint_1_0/src/blk_mem_decay/blk_mem_decay_sim_netlist.v
// Design      : blk_mem_decay
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_decay,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module blk_mem_decay
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
  (* C_INIT_FILE = "blk_mem_decay.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
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
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "14" *) 
  (* C_WRITE_WIDTH_B = "14" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_decay_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20336)
`pragma protect data_block
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
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
