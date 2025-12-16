`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Vienna
// Engineer: Daniel Martinez
// 
// Create Date: 05/31/2024 03:48:01 PM
// Module Name: TimeTagger
// Project Name: ROQuET
// Target Devices: Zedboard and Q7 (Zynq XC7Z020)
// Description: Six independent timestamps are computed every clk cycle within a windowTT time.
//              Once the window is completed we analyze the not null timestamposand validate 
//              the coincident events.
//              The process repeats until intTime is completed, and we retrieve the counts statistics.
// 
// Dependencies: OneShot.v ALU_TimeTagger.v delayLine.vhd encoder.vhd risingEdgeDetector.vhd 
//               adderTreeLegacy.vhd
// 
// Revision:
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////


module TimeTagger #(parameter [7:0] NTaps = 8'd192)(
    input wire clk,//350MHz
    input wire [5:0] hit,
    input wire start,
    input wire a_rst,
    output reg done,
//    output reg startTx,
//    input doneTx,
    input wire [31:0] intTime, 
    input wire [15:0] samplingWindow,
    //input [7:0] FineCoinWindow, 
    input wire [15:0] CoinWindow,
    output wire [31:0] dontcareC,
    //singleCounts
    output reg [31:0] C_0,
    output reg [31:0] C_1,
    output reg [31:0] C_2,
    output reg [31:0] C_3,
    output reg [31:0] C_4,
    output reg [31:0] C_5,
    //coincidende ij
    output reg [31:0] CC_01,
    output reg [31:0] CC_02,
    output reg [31:0] CC_03,
    output reg [31:0] CC_04,
    output reg [31:0] CC_05,
    output reg [31:0] CC_12,
    output reg [31:0] CC_13,
    output reg [31:0] CC_14,
    output reg [31:0] CC_15,
    output reg [31:0] CC_23,
    output reg [31:0] CC_24,
    output reg [31:0] CC_25,
    output reg [31:0] CC_34,
    output reg [31:0] CC_35,
    output reg [31:0] CC_45,
    input wire [15:0] delayTT0,
    input wire [15:0] delayTT1,
    input wire [15:0] delayTT2,
    input wire [15:0] delayTT3,
    input wire [15:0] delayTT4,
    input wire [15:0] delayTT5
    );
    
    reg [1:0] FSM;
    reg ALU;
    reg resetALU;
    reg [5:0] dets, dets_ALU;
    reg [15:0] counter;
    reg [31:0] counter2;
    reg enableTT;
    wire [NTaps-1:0] thermo_0,thermo_1,thermo_2,thermo_3,thermo_4,thermo_5;
    wire [7:0] fine0,fine1,fine2,fine3,fine4,fine5;
    wire [5:0] valid_vect;
    wire [5:0] dets_aux; 
    reg [23:0] t0,t1,t2,t3,t4,t5;
    reg [23:0] tn_aux;
    reg [23:0] timestamp0,timestamp1,timestamp2,timestamp3,timestamp4,timestamp5;
    //singleCounts
    wire [31:0] C_0_aux, C_1_aux, C_2_aux, C_3_aux, C_4_aux, C_5_aux;
    //coincidende ij
    wire [31:0] CC_01_aux, CC_02_aux, CC_03_aux, CC_04_aux, CC_05_aux;
    wire [31:0] CC_12_aux, CC_13_aux, CC_14_aux, CC_15_aux;
    wire [31:0] CC_23_aux, CC_24_aux, CC_25_aux;
    wire [31:0] CC_34_aux, CC_35_aux;
    wire [31:0] CC_45_aux;
    // registers
    reg [31:0] intTime_reg;
    reg [15:0] samplingWindow_reg;
    reg [15:0] CoinWindow_reg;


    //initalize variables     
    initial begin
        FSM             <= 2'd0;
        ALU             <= 1'b0;
        resetALU        <= 1'b0;
        done            <= 1'b0;
        enableTT        <= 1'b0;
//        startTx         <= 1'b0;
//        dets            <= 6'b000000;
        dets_ALU        <= 6'b000000;
        counter         <= 16'd0;
        counter2        <= 32'd0;
        t0              <= 24'd0;
        t1              <= 24'd0;
        t2              <= 24'd0;
        t3              <= 24'd0;
        t4              <= 24'd0;
        t5              <= 24'd0;
        tn_aux          <= 24'd0;
        timestamp0      <= 24'd0;
        timestamp1      <= 24'd0;
        timestamp2      <= 24'd0;
        timestamp3      <= 24'd0;
        timestamp4      <= 24'd0;
        timestamp5      <= 24'd0;
    end
    
    always@(posedge clk)begin

        //registers
        intTime_reg         <= intTime;
        samplingWindow_reg  <= samplingWindow;
        CoinWindow_reg      <= CoinWindow;

        //external reset
        if(a_rst)begin
            FSM             <= 2'd3;
            resetALU        <= 1'b1;//reset state for the module ALU_TimeTagger.v
        end
        else begin
            
            case(FSM)
                //idle
                0:begin//start the TimeTagger finite state machine routine
                    if(start)begin//external start
                        enableTT <= 1'b1;//enable time tagger core
                        done     <= 1'b0;
                        FSM      <= 2'd1;
                    end
                end
                
                1:begin //time stamping
                    if(counter2 < intTime_reg)begin//checks for intTime
                        if(counter < samplingWindow_reg)begin //saves valid timestamps within samplingWindow
                            //update dets: dets_aux_os tells you have a new timestamp
                            dets        <= dets | dets_aux;//update dets if something came from encoder.vhd
                            //Timestamping and Delay line structure. 
                            //auxiliar counter adding maxTapsn units per clk cycle
                            tn_aux      <= tn_aux + {16'd0,NTaps};
                            //timestamp timestampn is saved if dets_aux[n] arrives
                            if(dets_aux[0]) begin timestamp0 <= tn_aux + {8'd0,delayTT0} - {16'd0,fine0}; end
                            if(dets_aux[1]) begin timestamp1 <= tn_aux + {8'd0,delayTT1} - {16'd0,fine1}; end
                            if(dets_aux[2]) begin timestamp2 <= tn_aux + {8'd0,delayTT2} - {16'd0,fine2}; end
                            if(dets_aux[3]) begin timestamp3 <= tn_aux + {8'd0,delayTT3} - {16'd0,fine3}; end
                            if(dets_aux[4]) begin timestamp4 <= tn_aux + {8'd0,delayTT4} - {16'd0,fine4}; end
                            if(dets_aux[5]) begin timestamp5 <= tn_aux + {8'd0,delayTT5} - {16'd0,fine5}; end
                            //counter update
                            counter     <= counter + 16'd1;
                            //analisis disabled
                            ALU         <= 1'b0;
                        end
                        //once samplingWindow is over the module ALU_TimeTagger.v analyzes the coincidences
                        else begin
                            counter     <= 16'd1;//restarts the samplingWindow counter
                            dets        <= dets_aux;//update dets if something came from encoder.vhd
                            dets_ALU    <= dets;//saves dets_ALU for the module ALU_TimeTagger.v
                            //save and resets time stamps 
                            t0             <= timestamp0;//extra register to not loose data while ALU is working
                            t1             <= timestamp1;
                            t2             <= timestamp2;
                            t3             <= timestamp3;
                            t4             <= timestamp4;
                            t5             <= timestamp5;
                            timestamp0     <= 24'd0;
                            timestamp1     <= 24'd0;
                            timestamp2     <= 24'd0;
                            timestamp3     <= 24'd0;
                            timestamp4     <= 24'd0;
                            timestamp5     <= 24'd0;
                            tn_aux          <= 24'd0;
                            ALU             <= 1'b1;//enables coincidence analyzer FOR 1 CLK CYCLE, saves current registers
                            //starts aquiring timestamps again (keeps in FSM == 1)
                        end
                        //counter intTime update
                        counter2        <= counter2 + 32'd1;
                    end
                    //once intTime is over it's time to retrieve the data
                    else begin
                        enableTT    <= 1'd0;//disables timeTagger
                        counter     <= 16'd0;//restarts the samplingWindow counter
                        counter2    <= 32'd0;// restarts the intTime counter
                        done        <= 1'b1;//done flag
                        //startTx     <= 1'b1;//starts the UART_Tx module
                        dets        <= 6'b000000;//resets the det register
                        dets_ALU    <= dets;//saves the last dets_ALU for ALU
                        //save and resets time stamps 
                        t0             <= timestamp0;//extra register to not loose data while ALU is working
                        t1             <= timestamp1;
                        t2             <= timestamp2;
                        t3             <= timestamp3;
                        t4             <= timestamp4;
                        t5             <= timestamp5;
                        timestamp0     <= 24'd0;
                        timestamp1     <= 24'd0;
                        timestamp2     <= 24'd0;
                        timestamp3     <= 24'd0;
                        timestamp4     <= 24'd0;
                        timestamp5     <= 24'd0;
                        tn_aux          <= 24'd0;
                        ALU         <= 1'b1;//enables coincidence analyzer, saves current registers
                        FSM         <= 2'd2;//finish the data adquisition and return data
                    end
                end
                
                
                2:begin
                    ALU         <= 1'b0;
                    //once the data package is complete we reset the values
                    C_0         <= C_0_aux;
                    C_1         <= C_1_aux;
                    C_2         <= C_2_aux;
                    C_3         <= C_3_aux;
                    C_4         <= C_4_aux;
                    C_5         <= C_5_aux;
                    CC_01       <= CC_01_aux;
                    CC_02       <= CC_02_aux;
                    CC_03       <= CC_03_aux;
                    CC_04       <= CC_04_aux;
                    CC_05       <= CC_05_aux;
                    CC_12       <= CC_12_aux;
                    CC_13       <= CC_13_aux;
                    CC_14       <= CC_14_aux;
                    CC_15       <= CC_15_aux;
                    CC_23       <= CC_23_aux;
                    CC_24       <= CC_24_aux;
                    CC_25       <= CC_25_aux;
                    CC_34       <= CC_34_aux;
                    CC_35       <= CC_35_aux;
                    CC_45       <= CC_45_aux;
                    FSM         <= 2'd3;//reset
                    resetALU    <= 1'b1;//reset state for the module ALU_TimeTagger.v
                end
                
                                
                3:begin
                //general reset
                    FSM             <= 2'd0;
                    ALU             <= 1'b0;
                    resetALU        <= 1'b0;
                    enableTT        <= 1'b0;
//                    startTx         <= 1'b0;
                    dets            <= 6'b000000;
                    counter         <= 16'd0;
                    counter2        <= 32'd0;
                    t0              <= 24'd0;
                    t1              <= 24'd0;
                    t2              <= 24'd0;
                    t3              <= 24'd0;
                    t4              <= 24'd0;
                    t5              <= 24'd0;
                    tn_aux          <= 24'd0;
                    timestamp0      <= 24'd0;
                    timestamp1      <= 24'd0;
                    timestamp2      <= 24'd0;
                    timestamp3      <= 24'd0;
                    timestamp4      <= 24'd0;
                    timestamp5      <= 24'd0;
                end
                
            endcase
            
        end//end from else (reset)
    end
    
    ////////////////////////////////////////
    /////////Algorithmic Logic Unit/////////
    //////for coincidence verification//////
    ////////////////////////////////////////
    
    ALU_TimeTagger ALU_TimeTagger1(
        .clk(clk),
        .reset(resetALU),
        .dets(dets_ALU),
        .ALU(ALU),
        .CoinWindow({8'd0,CoinWindow_reg}),
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .t3(t3),
        .t4(t4),
        .t5(t5),
        .dontcareC(dontcareC),
        .C_0(C_0_aux),
        .C_1(C_1_aux),
        .C_2(C_2_aux),
        .C_3(C_3_aux),
        .C_4(C_4_aux),
        .C_5(C_5_aux),
        .CC_01(CC_01_aux),
        .CC_02(CC_02_aux),
        .CC_03(CC_03_aux),
        .CC_04(CC_04_aux),
        .CC_05(CC_05_aux),
        .CC_12(CC_12_aux),
        .CC_13(CC_13_aux),
        .CC_14(CC_14_aux),
        .CC_15(CC_15_aux),
        .CC_23(CC_23_aux),
        .CC_24(CC_24_aux),
        .CC_25(CC_25_aux),
        .CC_34(CC_34_aux),
        .CC_35(CC_35_aux),
        .CC_45(CC_45_aux)
    );
    
    ////////////////////////////////////////
    //Delay line and modules instantiation//
    ////////////////////////////////////////
    
    delayLine #(NTaps)
    Delay_line_0(
        .clk(clk),//TDC channel clock
        .hit(hit[0]),//channel signal input
        .enable(enableTT),
        .thermo(thermo_0),//thermometer code channel n
        .valid(valid_vect[0])
    );

   encoder #(NTaps)
    encoder_0(
      .clk(clk),//TDC channel clock
      .thermo(thermo_0),//thermometer code channel n
      .ones(fine0),//fine ruler channel n
      .ValidIn(valid_vect[0]),
      .ValidOut(dets_aux[0])//valid encoder
   );
   
   delayLine #(NTaps)
    Delay_line_1(
        .clk(clk),//TDC channel clock
        .hit(hit[1]),//channel signal input
        .enable(enableTT),
        .thermo(thermo_1),//thermometer code channel n
        .valid(valid_vect[1])
    );

   encoder #(NTaps)
    encoder_1(
      .clk(clk),//TDC channel clock
      .thermo(thermo_1),//thermometer code channel n
      .ones(fine1),//fine ruler channel n
      .ValidIn(valid_vect[1]),
      .ValidOut(dets_aux[1])//valid encoder
   );
   
   delayLine #(NTaps)
    Delay_line_2(
        .clk(clk),//TDC channel clock
        .hit(hit[2]),//channel signal input
        .enable(enableTT),
        .thermo(thermo_2),//thermometer code channel n
        .valid(valid_vect[2])
    );

   encoder #(NTaps)
    encoder_2(
      .clk(clk),//TDC channel clock
      .thermo(thermo_2),//thermometer code channel n
      .ones(fine2),//fine ruler channel n
      .ValidIn(valid_vect[2]),
      .ValidOut(dets_aux[2])//valid encoder
   );
   
   delayLine #(NTaps)
    Delay_line_3(
        .clk(clk),//TDC channel clock
        .hit(hit[3]),//channel signal input
        .enable(enableTT),
        .thermo(thermo_3),//thermometer code channel n
        .valid(valid_vect[3])
    );

   encoder #(NTaps)
    encoder_3(
      .clk(clk),//TDC channel clock
      .thermo(thermo_3),//thermometer code channel n
      .ones(fine3),//fine ruler channel n
      .ValidIn(valid_vect[3]),
      .ValidOut(dets_aux[3])//valid encoder
   );
   
   delayLine #(NTaps)
    Delay_line_4(
        .clk(clk),//TDC channel clock
        .hit(hit[4]),//channel signal input
        .enable(enableTT),
        .thermo(thermo_4),//thermometer code channel n
        .valid(valid_vect[4])
    );

   encoder #(NTaps)
    encoder_4(
      .clk(clk),//TDC channel clock
      .thermo(thermo_4),//thermometer code channel n
      .ones(fine4),//fine ruler channel n
      .ValidIn(valid_vect[4]),
      .ValidOut(dets_aux[4])//valid encoder
   );
   
   delayLine #(NTaps)
    Delay_line_5(
        .clk(clk),//TDC channel clock
        .hit(hit[5]),//channel signal input
        .enable(enableTT),
        .thermo(thermo_5),//thermometer code channel n
        .valid(valid_vect[5])
    );

   encoder #(NTaps)
    encoder_5(
      .clk(clk),//TDC channel clock
      .thermo(thermo_5),//thermometer code channel n
      .ones(fine5),//fine ruler channel n
      .ValidIn(valid_vect[5]),
      .ValidOut(dets_aux[5])//valid encoder
   );
    
endmodule
