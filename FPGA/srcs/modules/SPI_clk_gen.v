`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2024 02:03:03 PM
// Design Name: 
// Module Name: SPI_clk_gen
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


module SPI_clk_gen(
    input wire clk,
    output wire clk_SPI,
    input wire [12:0] half_period
    );
   
    reg [12:0] counter = 13'd0;
    reg clk_SPI_reg = 1'b0;
    assign clk_SPI = clk_SPI_reg;
    
    always@(posedge clk)begin
        if(counter<half_period)begin
            counter         <= counter + 13'd1;
        end
        else begin
            clk_SPI_reg     <= ~clk_SPI_reg;
            counter         <= 13'd0;
        end
    end 
endmodule
