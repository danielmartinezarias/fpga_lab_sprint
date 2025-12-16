`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2024 11:05:12 PM
// Design Name: 
// Module Name: ADS1278
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


module ADS1278(
    // output reg reading = 1'b0,
    input wire clk,            // 100 MHz clk
    //output wire clk_SPI,       // SPI clk
    input wire [12:0] half_period,   // parameter spi clk gen
    input wire enable,         // Enable the ADC communication
    input wire start,          // Start signal to initiate transmission
    output reg done,           // Done flag to indicate the end of the data collection
    input wire reset,          // Reset signal to reset the module
    output reg SYNC,           // Synchronization signal for the ADC
    input wire MISO,           // Data from the ADC
    output wire SCLK,           // Serial clock for ADC
    input wire DRDY,           // Data ready signal from the ADC
    output reg nPWRDN,          // Power down signal for the ADC
    output reg [23:0] ADC_0,   // 24-bit data from ADC channel 0
    output reg [23:0] ADC_1,   // 24-bit data from ADC channel 1
    output reg [23:0] ADC_2,   // 24-bit data from ADC channel 2
    output reg [23:0] ADC_3,   // 24-bit data from ADC channel 3
    output reg [23:0] ADC_4,   // 24-bit data from ADC channel 4
    output reg [23:0] ADC_5,   // 24-bit data from ADC channel 5
    output reg [23:0] ADC_6,   // 24-bit data from ADC channel 6
    output reg [23:0] ADC_7,    // 24-bit data from ADC channel 7
    input wire [15:0] SYNC_low_reg, // SYNC low time
    output reg [31:0] t_sync_to_drdy // time from SYNC to DRDY
    //output reg [2:0] state
    );

    //reg [3:0] ver = 4'd67 // version number
    wire clk_SPI;       // SPI clk
    reg clk_SPI_reg;               // SPI clock for controlling the interface
    reg [7:0] bit_counter;      // Counter for bits being read (24 bits per channel)
    reg [191:0] shift_reg;      // Shift register for storing serial data temporarily
    reg [2:0] state;            // FSM state
    reg scl_enable;             // clock enable
    reg [31:0] timeout;         // timeout if DRDY is not deasserted
    reg [31:0] counter;
    reg state_clk;
    reg clk_SPI_pos;
    reg clk_SPI_neg;
    reg [12:0] counter2;
    reg [6:0] counter3;
    assign clk_SPI = clk_SPI_reg;
    reg enable_clk_spi;
    reg SCLK_reg;
    reg [15:0] counter4;
    

    // SCLK clock output controlled by enable signal
    assign SCLK = SCLK_reg;

    // FSM States
    localparam IDLE      = 3'd0;
    localparam SYNC_LOW  = 3'd1;
    localparam SYNC_HIGH = 3'd2;
    localparam READ_DATA = 3'd3;
    localparam DONE      = 3'd4;
    localparam DRDY_ST   = 3'd5;
    localparam SCLK_EN   = 3'd6;
    localparam P_WAIT    = 3'd7;

    initial begin
        SYNC            <= 1'b1;
        done            <= 1'b1;
        bit_counter     <= 8'd0;
        scl_enable      <= 1'b0;
        shift_reg       <= 192'd0;
        ADC_0           <= 24'd0;
        ADC_1           <= 24'd0;
        ADC_2           <= 24'd0;
        ADC_3           <= 24'd0;
        ADC_4           <= 24'd0;
        ADC_5           <= 24'd0;
        ADC_6           <= 24'd0;
        ADC_7           <= 24'd0;
        state           <= IDLE;
        counter         <= 32'd0;
        counter2        <= 13'd0;
        counter3        <= 7'd0;
        counter4        <= 16'd0;
        timeout         <= 32'd100000000;
        state_clk       <= 1'b0;
        clk_SPI_pos     <= 1'b0;
        clk_SPI_neg     <= 1'b0;
        clk_SPI_reg     <= 1'b0;
        enable_clk_spi  <= 1'b1;
        t_sync_to_drdy  <= 32'd0;
        SCLK_reg        <= 1'b0;
        nPWRDN          <= 1'b0;
    end

    /////////////////////////////////
    // FORMAT 001 => SPI,TDM,Fixed //
    /////////////////////////////////
    
    always @(posedge clk) begin
        
        // clk_SPI generation
        case(state_clk)
            0:begin
                clk_SPI_neg     <= 1'b0;
                if(counter2<half_period)begin
                    counter2         <= counter2 + 13'd1;
                end
                else begin
                    if(enable_clk_spi)begin//IDLE time when waiting for DRDY
                        clk_SPI_reg     <= 1'b1;
                        clk_SPI_pos     <= 1'b1;
                        counter2        <= 13'd0;
                        state_clk       <= 1;
                        if(scl_enable)begin
                            SCLK_reg    <= ~clk_SPI_reg;
                        end
                        else begin
                            SCLK_reg    <= 1'b0;
                        end
                    end
                end

            end
            1:begin
                clk_SPI_pos     <= 1'b0;
                if(counter2<half_period)begin
                    counter2         <= counter2 + 13'd1;
                end
                else begin
                    clk_SPI_reg     <= 1'b0;
                    clk_SPI_neg     <= 1'b1;
                    counter2        <= 13'd0;
                    state_clk       <= 0;
                    if(scl_enable)begin
                        SCLK_reg    <= ~clk_SPI_reg;
                    end
                    else begin
                        SCLK_reg    <= 1'b0;
                    end
                end
            end
        endcase


        if (reset) begin
            SYNC            <= 1'b1;
            done            <= 1'b1;
            bit_counter     <= 8'd0;
            scl_enable      <= 1'b0;
            enable_clk_spi  <= 1'b1;
            nPWRDN          <= 1'b0;
            counter         <= 32'd0;
            counter2        <= 13'd0;
            counter3        <= 7'd0;
            counter4        <= 16'd0;
            state           <= IDLE;
            state_clk       <= 1'b0;
        end else begin
            case (state)

                IDLE: begin
                    SYNC            <= 1'b1;
                    
                    bit_counter     <= 8'd0;
                    scl_enable      <= 1'b0;
                    enable_clk_spi  <= 1'b1;
                    counter         <= 32'd0;
                    counter3        <= 7'd0;
                    counter4        <= 16'd0;
                    if (start && enable) begin
                        state           <= P_WAIT; // Waiting Time for ADC to power up;
                        nPWRDN          <= 1'b1;  // Power up the ADC
                        done            <= 1'b0;
                    end
                    else begin
                        nPWRDN          <= 1'b0;  // Power down the ADC
                        //done            <= 1'b1;
                    end
                end

                P_WAIT: begin
                    if (clk_SPI_pos) begin
                        if (counter < 32'd130) begin
                            counter <= counter + 32'd1;
                        end else begin
                            counter <= 32'd0;
                            state   <= SYNC_LOW;  
                        end
                    end
                end

                SYNC_LOW:begin//set SYNC low for SYNC_low_reg sclk cycles
                    if(clk_SPI_pos)begin
                        SYNC            <= 1'b0;
                        if(counter4<SYNC_low_reg)begin
                            counter4    <= counter4 + 16'd1;
                        end
                        else begin
                            state       <= SYNC_HIGH; 
                            counter4    <= 16'd0;
                        end
                    end
                end

                SYNC_HIGH: begin
                    if(clk_SPI_pos)begin//set SYNC high
                        SYNC                <= 1'b1;  
                        enable_clk_spi      <= 1'b0;
                        state               <= DRDY_ST;  
                    end
                end

                DRDY_ST: begin // running at 100MHz
                    if (!DRDY) begin  // Wait for DRDY to go low, indicating data is ready
                        counter         <= 32'd0;
                        t_sync_to_drdy  <= counter;
                        state           <= SCLK_EN;
                    end
                    else begin
                        if(counter<timeout)begin//timeout count if device is idle
                            counter     <= counter + 32'd1;
                        end
                        else begin
                            ADC_0       <= counter[23:0];
                            ADC_1       <= 24'd999;
                            ADC_2       <= 24'd999;
                            ADC_3       <= 24'd999;
                            ADC_4       <= 24'd999;
                            ADC_5       <= 24'd999;
                            ADC_6       <= 24'd999;
                            ADC_7       <= 24'd999;
                            counter     <= 32'd0;
                            enable_clk_spi      <= 1'b1;
                            nPWRDN              <= 1'b0;  // Power down the ADC
                            done        <= 1'b1;
                            state       <= IDLE;
                        end
                    end
                end

                SCLK_EN: begin
                    if(counter3<7'd94)begin//timeout to enable SCLK
                        counter3        <= counter3 + 7'd1;
                    end
                    else begin
                        counter3        <= 7'd0;
                        bit_counter     <= 8'd0;
                        enable_clk_spi  <= 1'b1;
                        scl_enable      <= 1'b1;
                        //shift_reg <= {191'd0, MISO};  // Shift in data from MISO
                        state <= READ_DATA;
                    end
                end

                READ_DATA: begin
                    if(clk_SPI_pos)begin
                        if (bit_counter < 8'd191) begin
                            bit_counter     <= bit_counter + 8'd1;
                            // reading             <= 1'b1;
                        end else begin
                            // reading         <= 1'b0;
                            bit_counter     <= 8'd0;  // Reset bit counter
                            scl_enable      <= 1'b0;
                            state           <= DONE;
                        end
                        shift_reg           <= {shift_reg[190:0], MISO};  // Shift in data from MISO
                    end
                end

                DONE: begin
                    if(clk_SPI_neg)begin
                        done <= 1'b1;   // Indicate the end of data collection
                        nPWRDN <= 1'b0; // Power down the ADC
                        // Store the data into the appropriate ADC channel register
                        ADC_0 <= shift_reg[191:168];
                        ADC_1 <= shift_reg[167:144];
                        ADC_2 <= shift_reg[143:120];
                        ADC_3 <= shift_reg[119:96];
                        ADC_4 <= shift_reg[95:72];
                        ADC_5 <= shift_reg[71:48];
                        ADC_6 <= shift_reg[47:24];
                        ADC_7 <= shift_reg[23:0];
                        state       <= IDLE;  // Go back to IDLE when start signal is low
                        counter     <= 32'd0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule