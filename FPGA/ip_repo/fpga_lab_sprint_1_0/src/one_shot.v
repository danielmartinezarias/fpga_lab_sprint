`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2026 06:09:56 PM
// Design Name: 
// Module Name: one_shot
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


module one_shot(
    input clk,
    input in,
    output reg out = 1'b0
    );

    reg [1:0] monitor = 2'b00;

    always @(posedge clk) begin
        monitor <= {monitor[0], in}; // Shift the input into the monitor
        if (monitor == 2'b01) begin
            out <= 1'b1; // Set output high for one clock cycle
        end else begin
            out <= 1'b0; // Otherwise, keep it low
        end
    end

endmodule
