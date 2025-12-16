`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 10:08:29 AM
// Design Name: 
// Module Name: UART_Rx_control
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


module UART_Rx_control(
    input wire clk,
    input wire tick,
    input wire PinRx,  // laser output, FPGA input
    input wire StartRx, // Start receiving data
    output reg [7:0] bufferRxFIFO = 8'd0, // python readings
    output reg UART_FIFO_data_available = 1'b0
    );

    wire [7:0] bufferRx;
    wire readyRx;
    reg [3:0] state = 0;
    wire oreadyRx;
    reg [9:0] index = 0;
    reg [9:0] indexMax;
    reg we = 0; // Write enable for bufferRx
    reg [7:0] bufferRx_MEM_w = 0; // Internal buffer for received data
    wire [7:0] bufferRx_MEM_r; // Read from internal buffer


    OneShot o1 (
    .clk(clk), 
    .signal(readyRx), 
    .trigger(oreadyRx)
    );

    UART_Rx UART_Rx_1(
        .clk(clk),
        .tick(tick),
        .PinRx(PinRx), // laser output, FPGA input
        .bufferRx(bufferRx),
        .readyRx(readyRx),
        .stopBit(1'b0) // 
    );

    UART_RX_FIFO UART_RX_FIFO1 (
        .clka(clk),    // input wire clka
        .wea(we),      // input wire [0 : 0] wea
        .addra(index),  // input wire [9 : 0] addra
        .dina(bufferRx_MEM_w),    // input wire [7 : 0] dina
        .douta(bufferRx_MEM_r)  // output wire [7 : 0] douta
    );

    always @(posedge clk) begin
        case(state)
            0: begin
                if (oreadyRx) begin
                    index <= 0; // Reset index
                    we <= 1; // Enable write to bufferRx
                    bufferRx_MEM_w <= bufferRx; // Store received data in internal buffer
                    state <= 1; // 
                end
            end
            
            1: begin
                we <= 0; // Disable write after storing data
                if(bufferRx_MEM_w == 8'd10) begin // Check for \n
                    indexMax <= index; // Store the maximum index
                    index <= 0; // Reset index
                    UART_FIFO_data_available <= 1'b1; // Indicate data is available
                    state <= 3; // send data to python
                end 
                else begin
                    state <= 2; // keep receiving data
                end
            end

            2: begin
                if (oreadyRx) begin
                    index <= index + 1; // Increment index
                    we <= 1; // Enable write to bufferRx
                    bufferRx_MEM_w <= bufferRx; // Store new received data
                    state <= 1; // Go back to state 1 to check for newline
                end
            end

            3: begin
                if(StartRx)begin
                    bufferRxFIFO <= bufferRx_MEM_r; // Read data from internal buffer
                    index <= index + 1; // Increment index for next read
                    state <= 4; // Move to next state
                end
            end

            4: begin
                if (index > indexMax) begin
                    UART_FIFO_data_available <= 1'b0; // Reset data available flag
                    state <= 0; // Go back to initial state
                end else begin
                    state <= 3; // Continue sending data to python
                end
            end
            
            default: begin
                state <= 0; // Default case to avoid latches
            end
        endcase
    end

endmodule
