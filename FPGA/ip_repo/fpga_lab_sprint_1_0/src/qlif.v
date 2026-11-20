`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2026 04:24:39 PM
// Design Name: 
// Module Name: qlif
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


module qlif(
    input clk,
    output wire [19:0] data_out,
    input wire [3:0] det,
    output reg [13:0] dac_i,
    output wire dac_clk_out,
    output reg dac_en = 1'b0,
    input wire [13:0] v0,
    input wire start,
    input wire [31:0] intTime, 
    input wire [13:0] v_step,
    input wire [31:0] delay,
    input wire [31:0] coincidence_window,
    output reg [7:0] flags = 8'd0,
    input wire [17:0] index_mem_r,
    output reg [17:0] index_mem_max = 18'd1000,
    input wire hom_start,
    output reg start_tt_hom = 1'b0,
    output reg reset_tt_hom,
    input wire [31:0] CC_12,
    input wire done_tt,
    input wire [13:0] dac_v_spike,
    output reg spike = 1'b0,
    input wire [31:0] refract_time,
    input wire enable_hom
    );


assign dac_clk_out = dac_en ? clk : 1'b0;
wire [3:0] det_pulse;
one_shot det_os[3:0](
    .clk(clk),
    .in(det), // Monitor the input signal det
    .out(det_pulse) // Output a pulse when det goes high
);

one_shot done_tt_os(
    .clk(clk),
    .in(done_tt), // Monitor the input signal done_tt
    .out(done_tt_pulse) // Output a pulse when done_tt goes high
);
reg [7:0] addra_decay = 8'd0;
reg [13:0] dina_decay = 14'd0;
wire [13:0] douta_decay;

blk_mem_decay blk_mem_decay1 (
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra_decay),  // input wire [7 : 0] addra
  .dina(dina),    // input wire [13 : 0] dina
  .douta(douta_decay)  // output wire [13 : 0] douta
);

wire [17:0] index_mem;
reg [7:0] FSM = 0;
reg [7:0] FSM_aux = 0; // State variable for FSM
reg [31:0] timestamp = 32'd0; // Counter for timing control
reg [31:0] counter = 32'd0; // Counter for delay control
reg [17:0] memindex_write = 18'd0; // Index for memory access
reg [19:0] data_mem; // an array to save the timestamp, dac_i and det for each event, to be read by the CPU later for analysis.
reg wea = 1'b0; // Write enable for memory

assign index_mem = wea ? memindex_write : index_mem_r;
data_memory data_memory (
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [0 : 0] wea
  .addra(index_mem),  // input wire [17 : 0] addra
  .dina(data_mem),    // input wire [19 : 0] dina
  .douta(data_out)  // output wire [19 : 0] douta
);

always @(posedge clk) begin
    case (FSM)
        0: begin
            if (start) begin
                FSM <= 1;
                timestamp <= 32'd0; // Reset timestamp at the start
                dac_i <= v0; // 
                memindex_write <= 18'd0; // Reset memory index
                flags <= 8'd0; // Reset flags
                dac_en <= 1'b1; // Enable DAC output
            end
            else begin
                // integration time must be around 1ms, sampling 50ns
                if (hom_start) begin
                    FSM <= 6; // Move to homing state
                    timestamp <= 32'd0; // Reset timestamp at the start
                    dac_i <= v0; // 
                    memindex_write <= 18'd0; // Reset memory index
                    flags <= 8'd0; // Reset flags
                    dac_en <= 1'b1; // Enable DAC output
                    reset_tt_hom <= 1'b1; // Reset the Time Tagger for homing
                    addra_decay <= 8'd0; // Reset the address for decay memory
                end
            end
        end
        1: begin // FIRST PHOTON EVENT
            if(timestamp < intTime) begin
                timestamp <= timestamp + 1; // Increment timestamp
                if (det_pulse[1] || det_pulse[2]) begin
                    dac_i <= dac_i + v_step; //
                    data_mem <= {timestamp, dac_i, det, 1'b0}; // Save the event data in memory
                    wea <= 1'b1; // Enable writing to memory
                    memindex_write <= memindex_write + 1; // Increment memory index for the next event
                    counter <= 32'd0; // Reset delay counter
                    FSM <= 5; // Move to a state to wait for the delay
                    if (det_pulse[1]) 
                        FSM_aux <= 2; // Set auxiliary state for det_pulse[1]
                    else if (det_pulse[2]) 
                            FSM_aux <= 3; // Set auxiliary state for det_pulse[2]
                end
                else begin
                    wea <= 1'b0; // Disable writing to memory if no event detected
                end
            end else begin
                timestamp <= 32'd0; // Reset timestamp after reaching intTime
                FSM <= 4; // Move to a final state or reset as needed
            end
        end
        2: begin //
            if (timestamp < intTime) begin
                timestamp <= timestamp + 1; // Increment timestamp
                counter <= counter + 1; // Increment delay counter
                if (counter <= coincidence_window) begin
                    if (det_pulse[1] || det_pulse[2]) begin
                        if (det_pulse[1]) dac_i <= dac_i - v_step; // discard the voltage if we detect a photon in a non desired detector
                        data_mem <= {timestamp, dac_i, det,1'b1}; // Save the event data in memory
                        wea <= 1'b1; // Enable writing to memory
                        memindex_write <= memindex_write + 1; // Increment memory index for the next event
                        FSM <= 1; // Return to state 1 for further processing
                    end
                end else begin
                    // if there is no coincidence within the window, reset the counter, voltage, and go back to state 1
                    counter <= 32'd0; // Reset delay counter after the coincidence window
                    dac_i <= dac_i - v_step; // Reset voltage to previous level
                    FSM <= 1; // Return to state 1 for further processing
                end
            end else begin
                timestamp <= 32'd0; // Reset timestamp after reaching intTime
                FSM <= 4; // Move to a final state or reset as needed
            end
        end
        3: begin //
            if (timestamp < intTime) begin
                timestamp <= timestamp + 1; // Increment timestamp
                counter <= counter + 1; // Increment delay counter
                if (counter <= coincidence_window) begin
                    if (det_pulse[1] || det_pulse[2]) begin
                        if (det_pulse[2]) dac_i <= dac_i - v_step; // discard the voltage if we detect a photon in a non desired detector
                        data_mem <= {timestamp, dac_i, det,1'b1}; // Save the event data in memory
                        wea <= 1'b1; // Enable writing to memory
                        memindex_write <= memindex_write + 1; // Increment memory index for the next event
                        FSM <= 1; // Return to state 1 for further processing
                    end
                end else begin
                    // if there is no coincidence within the window, reset the counter, voltage, and go back to state 1
                    counter <= 32'd0; // Reset delay counter after the coincidence window
                    dac_i <= dac_i - v_step; // Reset voltage to previous level
                    FSM <= 1; // Return to state 1 for further processing
                end
            end else begin
                timestamp <= 32'd0; // Reset timestamp after reaching intTime
                FSM <= 4; // Move to a final state or reset as needed
            end
        end

        5: begin
            wea <= 1'b0; // Disable writing to memory after saving the event
            if (timestamp < intTime) begin
                timestamp <= timestamp + 1; // Increment timestamp

                if (counter < delay) begin
                    counter <= counter + 1; // Increment delay counter
                end else begin
                    counter <= 32'd0; // Reset delay counter
                    if (FSM_aux == 2) begin
                        FSM <= 2; // Move to state 2 after the delay for det_pulse[1]
                    end else if (FSM_aux == 3) begin
                        FSM <= 3; // Move to state 3 after the delay for det_pulse[2]
                    end
                end

            end else begin
                timestamp <= 32'd0; // Reset timestamp after reaching intTime
                FSM <= 4; // Move to a final state or reset as needed
            end
        end

        4: begin
            // reset everything and go back to state 0
            timestamp <= 32'd0; // Reset timestamp
            memindex_write <= 18'd0; // Reset memory index
            index_mem_max <= memindex_write; // Update the maximum index used in memory
            counter <= 32'd0; // Reset delay counter
            dac_i <= v0; // Reset voltage to initial value
            flags <= 8'd1; // send a flag to the CPU that the experiment is finished
            dac_en <= 1'b0; // Disable DAC output
            FSM <= 0;
        end

        6:begin
            if(enable_hom)begin
                if(dac_i == dac_v_spike) begin
                    spike <= 1'b1; // Set spike flag if voltage reaches spike value
                    counter <= 32'd0; // Reset counter for refractory period
                    FSM <= 8; // refractry period, we wait for the next photon event
                end
                else begin
                    spike <= 1'b0; // Clear spike flag otherwise
                end
                reset_tt_hom <= 1'b0; // Clear the reset signal for Time Tagger
                start_tt_hom <= 1'b1; // Start the Time Tagger for homing
                FSM <= 7; // Move to the next state for hom and wait for a coincidence event
            end
            else begin
                start_tt_hom <= 1'b0; // Clear the start signal for Time Tagger
                reset_tt_hom <= 1'b1; // Reset the Time Tagger for homing
                FSM <= 0; // Stay in the homing state until enable_hom is asserted
            end
        end

        7:begin
            if(enable_hom)begin
                if(done_tt_pulse)begin // after the integration time is finished, we check if there was a coincidence event
                    if(CC_12 > 1) begin
                        dac_i <= dac_i + v_step; // Increment voltage
                    end
                    else begin
                        dac_i <= dac_i - douta_decay; // Decrement voltage based on decay memory output
                        addra_decay <= addra_decay + 8'd1; // Increment decay memory address
                    end
                    FSM <= 8'd6;
                end
                else begin
                    start_tt_hom <= 1'b0; // Clear the start signal for Time Tagger
                end
            end
            else begin
                start_tt_hom <= 1'b0; // Clear the start signal for Time Tagger
                reset_tt_hom <= 1'b1; // Reset the Time Tagger for homing
                FSM <= 0; // Stay in the homing state until enable_hom is asserted
            end
        end

        8:begin
            if(counter < refract_time) begin
                counter <= counter + 1; // Increment counter for refractory period
            end
            else begin
                counter <= 32'd0; // Reset counter after refractory period
                FSM <= 6; // Return to state 6 for next photon event
            end
            if(counter == 32'd1000) begin// 10 us
                spike <= 1'b0; // Clear spike flag after a certain time
            end
        end


            
    endcase
end

endmodule
