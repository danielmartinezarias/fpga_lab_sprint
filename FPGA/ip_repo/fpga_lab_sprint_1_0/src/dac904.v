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
    input wire [7:0] n_states,
    input wire [7:0] memindex_write,
    input wire write2mem,
    input wire [31:0] high_width,
    input wire [31:0] low_width,
    output reg [13:0] dac_in = 14'b01_1111_1111_1111,
    output wire clk_out
    );

reg [7:0] fsm = 8'd0;
reg clk_en = 1'b0;
reg [31:0] counter = 32'd0;
wire [13:0] data_mem;
wire [7:0] index_mem;
reg [7:0] memindex_read = 8'd0;
wire wea;
assign clk_out = clk_en ? clk : 1'b0;
assign wea = write2mem;
assign index_mem = wea ? memindex_write : memindex_read;
// Memory instance
dac904_mem your_instance_name (
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [0 : 0] wea
  .addra(index_mem),  // input wire [7 : 0] addra
  .dina(data),    // input wire [13 : 0] dina
  .douta(data_mem)  // output wire [13 : 0] douta
);

// FSM for DAC control

always @ (posedge clk) begin
    case(fsm)
        
        0:begin
            case(control)
                0:begin //continuous
                    fsm <= 1;
                    clk_en <= 1'b1;
                    dac_in <= data;
                end
                1:begin //ramp
                    fsm <= 2;
                    clk_en <= 1'b1;
                    dac_in <= 14'b01_1111_1111_1111;
                end
                2:begin //pulse
                    fsm <= 3;
                    clk_en <= 1'b1;
                    dac_in <= data;
                    counter <= 32'd0;
                end
                3:begin //read from mem and output as pulse
                    fsm <= 5;
                    clk_en <= 1'b1;
                    memindex_read <= 8'd0;
                    dac_in <= data_mem;
                    counter <= 32'd0;
                end
                default:begin
                    fsm <= 0;
                    clk_en <= 1'b0;
                    dac_in <= 14'b01_1111_1111_1111;
                    counter <= 32'd0;
                    memindex_read <= 8'd0;
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

        3:begin
            if(control == 2)begin // until control is not changed
                if(counter < high_width)begin
                    dac_in <= data;
                    counter <= counter + 32'd1;
                end
                else begin
                    dac_in <= 14'b01_1111_1111_1111;
                    counter <= 32'd0;
                    fsm <= 4;
                end
            end
            else begin
                fsm <= 0;
            end
        end

        4:begin
            if(control == 2)begin // until control is not changed
                if(counter < low_width)begin
                    dac_in <= 14'b01_1111_1111_1111;
                    counter <= counter + 32'd1;
                end
                else begin
                    dac_in <= data;
                    counter <= 32'd0;
                    fsm <= 3;
                end
            end
            else begin
                fsm <= 0;
            end
        end

        5:begin
            if(control == 3)begin // until control is not changed
                if(counter < high_width)begin
                    dac_in <= data_mem;
                    counter <= counter + 32'd1;
                end
                else begin
                    dac_in <= 14'b01_1111_1111_1111;
                    counter <= 32'd0;
                    fsm <= 6;
                    memindex_read <= memindex_read + 8'd1;
                    if(memindex_read == n_states - 1)begin
                        memindex_read <= 8'd0; // reset to the beginning of the mem sequence
                    end
                end
            end
            else begin
                fsm <= 0;
            end
        end

        6:begin
            if(control == 3)begin // until control is not changed
                if(counter < low_width)begin
                    dac_in <= 14'b01_1111_1111_1111;
                    counter <= counter + 32'd1;
                end
                else begin
                    dac_in <= data_mem;
                    counter <= 32'd0;
                    fsm <= 5;
                end
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
