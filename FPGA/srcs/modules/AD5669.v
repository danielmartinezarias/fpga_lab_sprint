`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 10:00:25 PM
// Design Name: 
// Module Name: AD5669
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


module AD5669#(parameter [13:0] half_periodI2C = 13'd499)(
    input wire clk,           // clock at 100MHz
    output wire clk_I2C,
    input wire enable,        // Enable the DAC communication
    input wire start,         // Start signal to initiate transmission
    output reg done,          // Done flag to indicate transmission completion
    input wire reset,         // Reset signal
    input wire RW,            // Read/Write control bit (0 for Write, 1 for Read)
    input wire [6:0] I2C_address, // 7-bit I2C address of the DAC
    input wire [3:0] command, // 4-bit command for DAC operation
    input wire [3:0] address, // 4-bit DAC channel address
    input wire [15:0] data,  // 16-bit Data for DAC channel
    input wire [12:0] delay_Z_DAC, // sets delay to allow ad56669 acknowledge a valid byte
    inout wire I2C_SCL,    // I2C Clock Line
    inout wire I2C_SDA       // I2C Data Line          
    );

    //assign ver = 5'd29;        
    reg [31:0] shift_reg;      // Shift register for data transmission
    reg [5:0] bit_counter;     // Counter for transmitted bits
    reg [3:0] state;           // FSM state
    reg scl_enable;            // SCL clock enable
    reg ack;                   // Acknowledge bit for sleep time
    reg [12:0] half_period;
    reg [12:0] counter;
    reg clk_I2C_reg;
    assign clk_I2C = clk_I2C_reg;
    reg clk_I2C_pos;
    reg clk_I2C_neg;
    reg I2C_SDA_reg;
    // I2C clock output controlled by enable signal
    assign I2C_SCL = (scl_enable) ? clk_I2C : 1'b1;
    assign I2C_SDA = I2C_SDA_reg;
    reg state_clk;

    // FSM states
    localparam IDLE       = 4'd0;
    localparam START      = 4'd1;
    localparam SEND_ADDR  = 4'd2;
    localparam SEND_CMD   = 4'd3;
    localparam SEND_DATA1 = 4'd4;
    localparam SEND_DATA2 = 4'd5;
    localparam STOP1      = 4'd6;
    localparam STOP2      = 4'd7;
    localparam DELAY      = 4'd8;
    localparam DELAY2     = 4'd9;


    initial begin
        state           <= IDLE;
        I2C_SDA_reg     <= 1'b1;
        done            <= 1'b0;
        scl_enable      <= 1'b0;
        bit_counter     <= 6'd0;
        counter         <= 13'd0;
        clk_I2C_reg     <= 1'b0;
        ack             <= 1'b0;
        state_clk       <= 1'd0;
        half_period     <= 13'd499;
        clk_I2C_pos     <= 1'b0;
        clk_I2C_neg     <= 1'b0;
    end

    always @(posedge clk) begin
        // clk_I2C_reg generation
        case(state_clk)
            0:begin
                clk_I2C_neg     <= 1'b0;
                if(counter<half_period)begin
                    counter         <= counter + 13'd1;
                end
                else begin
                    clk_I2C_reg     <= 1'b1;
                    clk_I2C_pos     <= 1'b1;
                    counter         <= 13'd0;
                    state_clk       <= 1;
                    if(~ack)begin
                        half_period       <= half_periodI2C;
                    end
                    else begin
                        half_period       <= half_periodI2C + delay_Z_DAC;
                    end
                end
            end
            1:begin
                clk_I2C_pos     <= 1'b0;
                if(counter<half_period)begin
                    counter         <= counter + 13'd1;
                end
                else begin
                    clk_I2C_reg     <= 1'b0;
                    clk_I2C_neg     <= 1'b1;
                    counter         <= 13'd0;
                    state_clk       <= 0;
                    half_period     <= half_periodI2C;
                end
            end
        endcase


        // I2C logic
        if (reset) begin
            state <= IDLE;
            I2C_SDA_reg <= 1'bz;
            done <= 1'b0;
            scl_enable <= 1'b0;
            bit_counter <= 6'd0;
        end else 
        begin
            case (state)
                IDLE: begin
                    if(clk_I2C_neg)begin
                        if(start && enable)begin
                            shift_reg <= {I2C_address, RW, command, address, data}; // Load I2C address, RW bit, command, address, and data
                            I2C_SDA_reg <= 1'b1;    // Start condition: SDA goes low while SCL is high
                            scl_enable <= 1'b0;
                            state <= START;
                        end
                        else begin
                            I2C_SDA_reg <= 1'b1;
                            scl_enable <= 1'b0;
                            done <= 1'b0;
                            bit_counter <= 6'd0;
                        end
                    end
                end

                START: begin
                    if(clk_I2C_pos)begin
                        I2C_SDA_reg <= 1'b0;    // Start condition: SDA goes low while SCL is high
                        state <= SEND_ADDR;
                    end
                end

                SEND_ADDR: begin
                    if(clk_I2C_neg)begin
                        scl_enable <= 1'b1; // Enable clock
                        if (bit_counter < 6'd8) begin
                            I2C_SDA_reg <= shift_reg[31];  // Send MSB first
                            shift_reg <= shift_reg << 1;
                            bit_counter <= bit_counter + 6'd1;
                        end else begin
                            state <= SEND_CMD;
                            I2C_SDA_reg <= 1'bz;  // aknowledge bit
                            ack     <= 1'b1;  // aknowledge bit
                            bit_counter <= 6'd0;//aknowledge bit
                        end
                    end
                end

                SEND_CMD: begin
                    if(clk_I2C_neg)begin
                        if (bit_counter < 6'd8) begin
                            I2C_SDA_reg <= shift_reg[31];  // Send MSB first
                            shift_reg <= shift_reg << 1;
                            bit_counter <= bit_counter + 6'd1;
                            ack     <= 1'b0;  // aknowledge bit
                        end else begin
                            state <= SEND_DATA1;
                            I2C_SDA_reg <= 1'bz;  // aknowledge bit
                            ack     <= 1'b1;  // aknowledge bit
                            bit_counter <= 6'd0;//aknowledge bit
                        end
                    end
                end

                SEND_DATA1: begin
                    if(clk_I2C_neg)begin
                        if (bit_counter < 6'd8) begin
                            I2C_SDA_reg <= shift_reg[31];  // Send MSB first
                            shift_reg <= shift_reg << 1;
                            bit_counter <= bit_counter + 6'd1;
                            ack     <= 1'b0;  // aknowledge bit
                        end else begin
                            state <= SEND_DATA2;
                            I2C_SDA_reg <= 1'bz;  // aknowledge bit
                            ack     <= 1'b1;  // aknowledge bit
                            bit_counter <= 6'd0;//aknowledge bit
                        end
                    end
                end


                SEND_DATA2: begin
                    if(clk_I2C_neg)begin
                        if (bit_counter < 6'd8) begin
                            I2C_SDA_reg <= shift_reg[31];  // Send MSB of command/address/data first
                            shift_reg <= shift_reg << 1;
                            bit_counter <= bit_counter + 6'd1;
                            ack     <= 1'b0;  // aknowledge bit
                        end else begin
                            state <= STOP1;
                            I2C_SDA_reg <= 1'bz;  // aknowledge bit
                            ack     <= 1'b1;  // aknowledge bit
                            bit_counter <= 6'd0;//aknowledge bit
                        end
                    end
                end

                STOP1: begin
                    if(clk_I2C_neg)begin
                        I2C_SDA_reg <= 1'b0;    // Prepare stop condition
                        ack     <= 1'b0;  // aknowledge bit
                        state <= STOP2;
                    end
                end

                STOP2: begin
                    if(clk_I2C_neg)begin
                        I2C_SDA_reg <= 1'b1;    // Stop condition
                        state <= DELAY;
                        scl_enable <= 1'b0;
                    end
                end

                DELAY:begin
                    if(clk_I2C_pos)begin
                        if (bit_counter < 6'd10) begin
                            bit_counter <= bit_counter + 6'd1;
                        end
                        else begin
                            state <= DELAY2;
                            bit_counter <= 6'd0;//aknowledge bit
                            done <= 1'b1;       // Transmission complete
                        end
                    end
                end

                DELAY2:begin
                    if(clk_I2C_pos)begin
                        done <= 1'b0;       // Transmission complete
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase

        end
    end
 

endmodule