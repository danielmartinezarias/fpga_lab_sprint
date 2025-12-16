`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Vienna
// Engineer: Daniel Martinez
// 
// Create Date: 05/31/2024 04:11:53 PM
// Module Name: ALU_TimeTagger
// Project Name: ROQuET
// Target Devices: Zedboard and Q7 (Zynq XC7Z020)
// Description: Validates the coincidences and computes the overall statistics. 
//              This module is a dependecy of TimeTagger.v
// 
// Dependencies: -
// 
// Revision:
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_TimeTagger(
    input clk,
    input reset,
    input [5:0] dets,
    input ALU,
    input [23:0] CoinWindow,
    input [23:0] t0,t1,t2,t3,t4,t5,
    output reg [31:0] dontcareC,
    //singleCounts
    output reg [31:0] C_0,C_1,C_2,C_3,C_4,C_5,
    //coincidende ij
    output reg [31:0] CC_01,CC_02,CC_03,CC_04,CC_05,
    output reg [31:0] CC_12,CC_13,CC_14,CC_15,
    output reg [31:0] CC_23,CC_24,CC_25,
    output reg [31:0] CC_34,CC_35,
    output reg [31:0] CC_45
    );
    
    reg [2:0] FSM;
    reg [23:0] tA,tB;
    reg coincidence;

    
    //initalize variables
    initial begin
        FSM             <= 3'd0;
        tA              <= 24'd0;
        tB              <= 24'd0;
        coincidence     <= 1'b0;
        dontcareC       <= 32'd0;
        C_0             <= 32'd0;//singleCounts
        C_1             <= 32'd0;
        C_2             <= 32'd0;
        C_3             <= 32'd0;
        C_4             <= 32'd0;
        C_5             <= 32'd0;
        CC_01           <= 32'd0;
        CC_02           <= 32'd0;
        CC_03           <= 32'd0;
        CC_04           <= 32'd0;
        CC_05           <= 32'd0;
        CC_12           <= 32'd0;
        CC_13           <= 32'd0;
        CC_14           <= 32'd0;
        CC_15           <= 32'd0;
        CC_23           <= 32'd0;
        CC_24           <= 32'd0;
        CC_25           <= 32'd0;
        CC_34           <= 32'd0;
        CC_35           <= 32'd0;
        CC_45           <= 32'd0;
    end
    
    //FSM for coincidence validation
    always@(posedge clk)begin
    
        //TimeTagger.v module sends a reset signal once the 
        //integration time is completed
        if(reset)begin
            FSM     <= 4;
        end
        else begin
        
            //Main FSM
            case(FSM)
                0:begin//IDLE
                    //Wait for the ALU singal from TimeTagger.v module
                    if(ALU)begin
                        //Depending on dets we update registers tA,tB for calc
                        case(dets)
                            6'b000011:begin tA <= t0; tB <= t1; FSM <= 1;end
                            6'b000101:begin tA <= t0; tB <= t2; FSM <= 1;end
                            6'b001001:begin tA <= t0; tB <= t3; FSM <= 1;end
                            6'b010001:begin tA <= t0; tB <= t4; FSM <= 1;end
                            6'b100001:begin tA <= t0; tB <= t5; FSM <= 1;end
                            6'b000110:begin tA <= t1; tB <= t2; FSM <= 1;end
                            6'b001010:begin tA <= t1; tB <= t3; FSM <= 1;end
                            6'b010010:begin tA <= t1; tB <= t4; FSM <= 1;end
                            6'b100010:begin tA <= t1; tB <= t5; FSM <= 1;end
                            6'b001100:begin tA <= t2; tB <= t3; FSM <= 1;end
                            6'b010100:begin tA <= t2; tB <= t4; FSM <= 1;end
                            6'b100100:begin tA <= t2; tB <= t5; FSM <= 1;end
                            6'b011000:begin tA <= t3; tB <= t4; FSM <= 1;end
                            6'b101000:begin tA <= t3; tB <= t5; FSM <= 1;end
                            6'b110000:begin tA <= t4; tB <= t5; FSM <= 1;end
                            //n-plets
                            default:begin FSM <= 3; end
                        endcase
                    end
                end
                
                1:begin
                    //checks if tA is always bigger than tB
                    if(tA<tB)begin 
                        tA <= tB; 
                        tB <= tA; 
                    end
                    FSM             <= 2;
                end
                                    
                2:begin
                    //if the timestamps differences lie within CoinWindow
                        if((tA-tB)<=CoinWindow)begin
                            //coincidence validation
                             coincidence <= 1'b1;
                        end 
                        else begin
                            coincidence <= 1'b0;
                        end
                            FSM         <= 3;

                end
                
                3:begin
                    //compute the final registers
                    case(dets)
                        //singlets
                        6'b000001:begin C_0 <= C_0 + 32'd1; end
                        6'b000010:begin C_1 <= C_1 + 32'd1; end
                        6'b000100:begin C_2 <= C_2 + 32'd1; end
                        6'b001000:begin C_3 <= C_3 + 32'd1; end
                        6'b010000:begin C_4 <= C_4 + 32'd1; end
                        6'b100000:begin C_5 <= C_5 + 32'd1; end
                        //duplets
                        6'b000011:begin CC_01 <= CC_01 + coincidence; C_0 <= C_0 + 32'd1 ; C_1 <= C_1 + 32'd1 ; end
                        6'b000101:begin CC_02 <= CC_02 + coincidence; C_0 <= C_0 + 32'd1 ; C_2 <= C_2 + 32'd1 ; end
                        6'b001001:begin CC_03 <= CC_03 + coincidence; C_0 <= C_0 + 32'd1 ; C_3 <= C_3 + 32'd1 ; end
                        6'b010001:begin CC_04 <= CC_04 + coincidence; C_0 <= C_0 + 32'd1 ; C_4 <= C_4 + 32'd1 ; end
                        6'b100001:begin CC_05 <= CC_05 + coincidence; C_0 <= C_0 + 32'd1 ; C_5 <= C_5 + 32'd1 ; end
                        6'b000110:begin CC_12 <= CC_12 + coincidence; C_1 <= C_1 + 32'd1 ; C_2 <= C_2 + 32'd1 ; end
                        6'b001010:begin CC_13 <= CC_13 + coincidence; C_1 <= C_1 + 32'd1 ; C_3 <= C_3 + 32'd1 ; end
                        6'b010010:begin CC_14 <= CC_14 + coincidence; C_1 <= C_1 + 32'd1 ; C_4 <= C_4 + 32'd1 ; end
                        6'b100010:begin CC_15 <= CC_15 + coincidence; C_1 <= C_1 + 32'd1 ; C_5 <= C_5 + 32'd1 ; end
                        6'b001100:begin CC_23 <= CC_23 + coincidence; C_2 <= C_2 + 32'd1 ; C_3 <= C_3 + 32'd1 ; end
                        6'b010100:begin CC_24 <= CC_24 + coincidence; C_2 <= C_2 + 32'd1 ; C_4 <= C_4 + 32'd1 ; end
                        6'b100100:begin CC_25 <= CC_25 + coincidence; C_2 <= C_2 + 32'd1 ; C_5 <= C_5 + 32'd1 ; end
                        6'b011000:begin CC_34 <= CC_34 + coincidence; C_3 <= C_3 + 32'd1 ; C_4 <= C_4 + 32'd1 ; end
                        6'b101000:begin CC_35 <= CC_35 + coincidence; C_3 <= C_3 + 32'd1 ; C_5 <= C_5 + 32'd1 ; end
                        6'b110000:begin CC_45 <= CC_45 + coincidence; C_4 <= C_4 + 32'd1 ; C_5 <= C_5 + 32'd1 ; end
                        //triplets
                        6'b000111:begin C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b001011:begin C_3 <= C_3 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b010011:begin C_4 <= C_4 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b100011:begin C_5 <= C_5 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b001101:begin C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b010101:begin C_4 <= C_4 + 32'd1; C_2 <= C_2 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b100101:begin C_5 <= C_5 + 32'd1; C_2 <= C_2 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b011001:begin C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b101001:begin C_5 <= C_5 + 32'd1; C_3 <= C_3 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b110001:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b001110:begin C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b010110:begin C_4 <= C_4 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b100110:begin C_5 <= C_5 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b011010:begin C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b101010:begin C_5 <= C_5 + 32'd1; C_3 <= C_3 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b110010:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b011100:begin C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; end                        
                        6'b101100:begin C_5 <= C_5 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; end
                        6'b110100:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_2 <= C_2 + 32'd1; end
                        6'b111000:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; end
                        //quadruplets
                        6'b001111:begin C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b010111:begin C_4 <= C_4 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b011011:begin C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b011101:begin C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b011110:begin C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b100111:begin C_5 <= C_5 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b101011:begin C_5 <= C_5 + 32'd1; C_3 <= C_3 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b101101:begin C_5 <= C_5 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b101110:begin C_5 <= C_5 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b110011:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b110101:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_2 <= C_2 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b110110:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b111001:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b111010:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_1 <= C_1 + 32'd1; end
                        6'b111100:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; end
                        //quintuplets
                        6'b011111:begin C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b101111:begin C_5 <= C_5 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b110111:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b111011:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b111101:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_0 <= C_0 + 32'd1; end
                        6'b111110:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; end
                        //sextuplets
                        6'b111111:begin C_5 <= C_5 + 32'd1; C_4 <= C_4 + 32'd1; C_3 <= C_3 + 32'd1; C_2 <= C_2 + 32'd1; C_1 <= C_1 + 32'd1; C_0 <= C_0 + 32'd1;end
                        default:begin dontcareC <= dontcareC + 32'd1; end
                    endcase
                    //return to inital state
                    coincidence <= 1'b0;
                    FSM         <= 0;
                end
            
                4:begin
                //general reset
                    FSM             <= 3'd0;
                    tA              <= 24'd0;
                    tB              <= 24'd0;
                    coincidence     <= 1'b0;
                    dontcareC       <= 32'd0;
                    C_0             <= 32'd0;//singleCounts
                    C_1             <= 32'd0;
                    C_2             <= 32'd0;
                    C_3             <= 32'd0;
                    C_4             <= 32'd0;
                    C_5             <= 32'd0;
                    CC_01           <= 32'd0;
                    CC_02           <= 32'd0;
                    CC_03           <= 32'd0;
                    CC_04           <= 32'd0;
                    CC_05           <= 32'd0;
                    CC_12           <= 32'd0;
                    CC_13           <= 32'd0;
                    CC_14           <= 32'd0;
                    CC_15           <= 32'd0;
                    CC_23           <= 32'd0;
                    CC_24           <= 32'd0;
                    CC_25           <= 32'd0;
                    CC_34           <= 32'd0;
                    CC_35           <= 32'd0;
                    CC_45           <= 32'd0;
                end
            
            endcase
        end 
    end
    
    

    

endmodule
