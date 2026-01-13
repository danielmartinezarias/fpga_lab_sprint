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
    output reg [13:0] dac_in = 14'b01_1111_1111_1111,
    output wire clk_out
    );

reg [7:0] fsm = 8'd0;
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
                    dac_in <= 14'b01_1111_1111_1111;
                end
                default:begin
                    fsm <= 0;
                end
            endcase
        end

        1:begin
            if(control == 0)begin // until control is not changed
                dac_in <= data;
            end
            else begin
                fsm <= 0;
            end
        end

        2:begin
            if(control == 1)begin // until control is not changed
                dac_in <= dac_in + 14'd1;
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
