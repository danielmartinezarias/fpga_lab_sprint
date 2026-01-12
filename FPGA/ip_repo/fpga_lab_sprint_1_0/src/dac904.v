`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Vienna
// Engineer: Daniel Martinez
// 
// Create Date: 12/16/2025 10:26:15 PM
// Design Name: 
// Module Name: dac904
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


module dac904(
    input wire clk,
    input wire [7:0] control,
    input wire [13:0] data,
    output wire [13:0] dac_in,
    output wire clk_out
    );

reg [7:0] fsm = 8'd0;
reg [13:0] dac = 14'b01_1111_1111_1111;
assign dac_in = {dac[0], dac[1], dac[2], dac[3], dac[4], dac[5], dac[6], dac[7], dac[8], dac[9], dac[10], dac[11], dac[12], dac[13]}; // Bit-reversed: D0 is MSB, D13 is LSB
assign clk_out = clk;

always @ (posedge clk) begin
    case(fsm)
        
        0:begin
            case(control)
                0:begin //steady
                    fsm <= 1;
                end
                1:begin //ramp
                    fsm <= 2;
                    dac <= 14'b01_1111_1111_1111;
                end
                default:begin
                    fsm <= 0;
                end
            endcase
        end

        1:begin
            if(control == 0)begin // until control is not changed
                dac <= data;
            end
            else begin
                fsm <= 0;
            end
        end

        2:begin
            if(control == 1)begin // until control is not changed
                dac <= dac + 14'd1;
            end
            else begin
                fsm <= 0;
            end
        end

        default:begin
        end
    endcase
end

endmodule
