`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Vienna
// Engineer: Daniel Martinez
// 
// Create Date:    17:50:53 08/29/2016 
// Design Name: 
// Module Name:    OneShot 
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
module OneShot(
	input wire clk,
	input wire signal,
	output reg trigger = 0
    );
	 
	 reg [1:0] monitor = 0;

	always @(posedge clk) begin

		monitor [1:0] <= {monitor[0],signal};
		if (monitor [1:0] == 2'b01)
			trigger 	  <= 1'b1;
		else
			trigger 	  <= 1'b0;
		
	end
	 
	 


endmodule
