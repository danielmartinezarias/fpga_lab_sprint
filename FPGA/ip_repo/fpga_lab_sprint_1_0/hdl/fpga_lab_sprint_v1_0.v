
`timescale 1 ns / 1 ps

	module fpga_lab_sprint_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 10
	)
	(
		// Users to add ports here

		//clocks
        input wire clk_100MHz,
        input wire clk_350MHz,
        //IO
		inout [31:0] gpio_breakout,
        output wire [7:0] led,

		// User ports ends

		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);


	///////////////////////////////////
    /////////wires declaration/////////
    ///////////////////////////////////

	//TimeTagger//
    wire [5:0] signal;
    wire [15:0] samplingWindow;
    wire [15:0] CoinWindow;
    wire [31:0] intTime;//1s
    wire startTT;
	wire done_TT;
    wire [15:0] delayTT0;
    wire [15:0] delayTT1;
    wire [15:0] delayTT2;
    wire [15:0] delayTT3;
    wire [15:0] delayTT4;
    wire [15:0] delayTT5;
    wire reset_TT;
    //singleCounts
    wire [31:0] C_0;
    wire [31:0] C_1;
    wire [31:0] C_2;
    wire [31:0] C_3;
    wire [31:0] C_4;
    wire [31:0] C_5;
    //coincidende ij
    wire [31:0] CC_01;
    wire [31:0] CC_02;
    wire [31:0] CC_03;
    wire [31:0] CC_04;
    wire [31:0] CC_05;
    wire [31:0] CC_12;
    wire [31:0] CC_13;
    wire [31:0] CC_14;
    wire [31:0] CC_15;
    wire [31:0] CC_23;
    wire [31:0] CC_24;
    wire [31:0] CC_25;
    wire [31:0] CC_34;
    wire [31:0] CC_35;
    wire [31:0] CC_45;
    //dac904
    wire [13:0] data_dac904;
    wire [7:0] control_dac904;
    // version and test
    wire master_reset;
    wire [7:0] test_reg;
    wire [7:0] version;

    ///////////////////////////////////
    /////////// Assignments ///////////
    ///////////////////////////////////

    assign led = version;
    assign signal = gpio_breakout[6:0];

	///////////////////////////////////
    /////////////TimeTagger////////////
    ///////////////////////////////////

    TimeTagger #(.NTaps(8'b11000000)) 
    TimeTagger1 (
        .clk(clk_350MHz),
        .signal(signal),
        .start(startTT),
        .a_rst(reset_TT),
        .done(done_TT),
        .intTime(intTime),
        .samplingWindow(samplingWindow),
        .CoinWindow(CoinWindow),
        .dontcareC(),
        .C_0(C_0),
        .C_1(C_1),
        .C_2(C_2),
        .C_3(C_3),
        .C_4(C_4),
        .C_5(C_5),
        .CC_01(CC_01),
        .CC_02(CC_02),
        .CC_03(CC_03),
        .CC_04(CC_04),
        .CC_05(CC_05),
        .CC_12(CC_12),
        .CC_13(CC_13),
        .CC_14(CC_14),
        .CC_15(CC_15),
        .CC_23(CC_23),
        .CC_24(CC_24),
        .CC_25(CC_25),
        .CC_34(CC_34),
        .CC_35(CC_35),
        .CC_45(CC_45),
        .delayTT0(delayTT0),
        .delayTT1(delayTT1),
        .delayTT2(delayTT2),
        .delayTT3(delayTT3),
        .delayTT4(delayTT4),
        .delayTT5(delayTT5)
    );

    dac904 dac904_inst(
        .clk(clk_100MHz),
        .control(control_dac904),
        .data(data_dac904),
        .dac_in(gpio_breakout[20:7])
    );

	
// Instantiation of Axi Bus Interface S00_AXI
	fpga_lab_sprint_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) fpga_lab_sprint_v1_0_S00_AXI_inst (
		//TimeTagger//
        .samplingWindow(samplingWindow),
        .CoinWindow(CoinWindow),
        .intTime(intTime),//1ms
        .startTT(startTT),
        .done_TT(done_TT),
        .reset_TT(reset_TT),
        .delayTT0(delayTT0),
        .delayTT1(delayTT1),
        .delayTT2(delayTT2),
        .delayTT3(delayTT3),
        .delayTT4(delayTT4),
        .delayTT5(delayTT5),
        //singleCounts
        .C_0(C_0),
        .C_1(C_1),
        .C_2(C_2),
        .C_3(C_3),
        .C_4(C_4),
        .C_5(C_5),
        //coincidende ij
        .CC_01(CC_01),
        .CC_02(CC_02),
        .CC_03(CC_03),
        .CC_04(CC_04),
        .CC_05(CC_05),
        .CC_12(CC_12),
        .CC_13(CC_13),
        .CC_14(CC_14),
        .CC_15(CC_15),
        .CC_23(CC_23),
        .CC_24(CC_24),
        .CC_25(CC_25),
        .CC_34(CC_34),
        .CC_35(CC_35),
        .CC_45(CC_45),
        //dac904
        .data_dac904(data_dac904),
        .control_dac904(control_dac904),
        // version and test
        .master_reset(master_reset),
        .test_reg(test_reg),
        .version(version),
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
