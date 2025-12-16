`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:36:09 09/14/2016 
// Design Name: 
// Module Name:    UART_Rx 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module UART_Rx(
	input clk,
	input tick,
	input PinRx,
	output reg [7:0]bufferRx = 0,
	output reg readyRx=0,
	input wire stopBit
);

	OneShot o1 (
		.clk(clk), 
		.signal(tick), 
		.trigger(otick)
		);

	reg [2:0] ctrlRx = 0;
	reg [7:0] bufferRxInt = 0;
	reg [3:0] countTick = 0; // Sampling counter, 16 ticks per bit
	reg [2:0] countBit = 0;
	reg [4:0] muestreo = 0;

	always @(posedge clk) begin
		if(otick) begin
			case (ctrlRx)
			0:begin
				if(~PinRx) // Start receiving data, UART protocol requires a low start bit
					ctrlRx		<= 1;
			end
			
			1: begin
				countTick		<= countTick + 4'd1;
				if(&countTick) // 
					ctrlRx		<= 2;
			end
			
			2: begin
				countTick		<= countTick + 4'd1;
				if(&countTick)begin
					countBit		<= countBit + 3'd1;
					muestreo			<= 5'd0;
					if(&countBit) // 8 bits received
					begin
						if(stopBit) // Check for stop bit
							ctrlRx		<= 3; 
						else 
							begin
								ctrlRx		<= 4; 
							end
					end
					if(muestreo > 7)
						bufferRxInt[countBit] <= 1'b1;
					else
						bufferRxInt[countBit] <= 1'b0;
				end
				else
					muestreo			<= muestreo + {4'd0,PinRx};
					
			end
			
			3: begin
				countTick		<= countTick + 4'd1;
				if(countTick > 13)
					ctrlRx			<= 4;
			end
			
			4: begin
				countTick		<= countTick + 4'd1;
				bufferRx		<= bufferRxInt;
				readyRx			<= 1;
				ctrlRx			<= 5;
			end
			
			5: begin
				countTick		<= 4'd0;
				readyRx			<= 0;
				ctrlRx			<= 0;
			end
			
			default:
			ctrlRx			<= 0;
			
			endcase
		end
	end
endmodule
