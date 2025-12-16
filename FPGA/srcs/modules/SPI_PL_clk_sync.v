`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2024 05:48:26 PM
// Design Name: 
// Module Name: SPI_PL_clk_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module SPI_PL_clk_sync(
    input wire clk,
    input wire clk_SPI,
    input wire PL_signal,
    output wire signal
    );
    
    reg SM = 1'd0;
    reg signal0 = 1'd0;
    reg [9:0] counter = 10'd0;

    OneShot o1 (
    .clk(clk_SPI), 
    .signal(signal0), 
    .trigger(signal)
    );
 
    
    always@(posedge clk)begin
        case(SM)
            1'b0:begin
                if(PL_signal)begin
                    SM      <= 1'd1;
                    counter <= 10'd0;
                    signal0  <= 1'b1;
                end
            end
            
            1'd1:begin//change this to match the spi freq
                if(counter < 10'd999)begin //clk@100MHz, SPI_clk@100kHz, 499
                    counter <= counter + 10'd1;
                end
                else begin
                    counter <= 10'd0;
                    signal0  <= 1'b0;
                    SM      <= 1'd0;
                end
            end
            
            
        endcase
    end
    
endmodule