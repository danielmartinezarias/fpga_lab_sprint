`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:47:15 08/29/2016 
// Design Name: 
// Module Name:    UART_Tx 
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
module UART_Tx(
	input clk,
	input tick,
	input StartTx,
	input [7:0] BufferTx,
	output reg readyTx = 1'd0,
	output reg PinTx = 1'd0
	  
    );
	 
	 OneShot o1 (
    .clk(clk), 
    .signal(tick), 
    .trigger(otick)
    );

	 
	 reg [2:0] controlTx = 3'd0;
	 reg [3:0] CountTick = 4'd0;
	 reg [10:0] CountTick2 = 11'd0;//un contador de 10 bits falla
	 reg [7:0] BufferTxOut = 8'd0;
	 reg [2:0] index = 3'd0;
	 
	 
	 always @ (posedge clk) begin
	 
		if(otick) begin
		
			case (controlTx)
				3'd0: begin //idle
							PinTx			<= 1;
							readyTx		<= 1'd0;
							if(StartTx) begin//cuando le llega esta señal puedo al siguiente paso un ciclo de reloj clk despues
								controlTx	<= 3'd1;
								BufferTxOut	<= BufferTx;
								
							end
						end
						
				3'd1: begin //start bit
							PinTx 		<= 1'd0;
							CountTick	<= CountTick + 4'd1;//espero 16 ticks = 1 bit abajo
							if (&CountTick) begin
								controlTx	<= 3'd2;
							end
						end
						
				3'd2: begin
							PinTx 		<= BufferTxOut[index];
							CountTick	<= CountTick + 4'd1;
							if (&CountTick) begin
							index			<= index + 3'd1;//cada 16 ticks mando un dato de BufferTxOut y cambio el index
								if (&index) begin
									controlTx	<= 3'd3;//cuando el index es 8 paso al siguiente
									end
									
							end
						end
						
				3'd3: begin
							readyTx		<= 1'd1;
							PinTx			<= 1'd1;
							CountTick	<= CountTick + 4'd1;//pongo el stopbit que es 1
							//CountTick2	<= CountTick2 + 11'd1;
							if (&CountTick) begin
								controlTx	<= 3'd4;//regreso al principio
							end
						end
						
				3'd4: begin
							PinTx			<= 1'd1;
							CountTick	<= CountTick + 4'd1;//pongo el segundo stopbit que es 1
							//CountTick2	<= CountTick2 + 11'd1;
							if (&CountTick) begin
								controlTx	<= 3'd0;//regreso al principio
							end
						end
			endcase
		end
	 end


endmodule
