`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 05:13:44 PM
// Design Name: 
// Module Name: I2C_clk_gen
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


module I2C_clk_gen(
    input wire clk,
    output wire clk_I2C
    );
   
    parameter half_period = 13'd499;
    reg [12:0] counter = 13'd0;
    reg clk_I2C_reg = 1'b0;
    assign clk_I2C = clk_I2C_reg;
    
    always@(posedge clk)begin
        if(counter<half_period)begin
            counter         <= counter + 13'd1;
        end
        else begin
            clk_I2C_reg     <= ~clk_I2C_reg;
            counter         <= 13'd0;
        end
    end 
endmodule
