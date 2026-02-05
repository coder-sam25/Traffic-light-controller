`timescale 1ns/1ps

module traffic_light_controller (
    input  logic clk,
    input  logic reset,
    input  logic ped_req,
    output logic red,
    output logic yellow,
    output logic green,
    output logic ped_walk,
    output logic [2:0] ped_count   // pedestrian countdown
);

    // FSM states
    typedef enum logic [1:0] {
        RED_CAR = 2'b00,
        GREEN   = 2'b01,
        YELLOW  = 2'b10,
        RED_PED = 2'b11
    } state_t;

    state_t current_state, next_state;

    logic ped_latched;
    logic [2:0] ped_timer;

    // -------------------------
    // Pedestrian request latch
    // -------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            ped_latched <= 1'b0;
        else if (ped_req)
            ped_latched <= 1'b1;
        else if (current_state == RED_PED && ped_timer == 0)
            ped_latched <= 1'b0;
    end

    // -------------------------
    // State register
    // -------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= RED_CAR;
        else
            current_state <= next_state;
    end

    // -------------------------
    // Pedestrian countdown timer
    // -------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            ped_timer <= 3'd5;
        else if (current_state == RED_PED) begin
            if (ped_timer > 0)
                ped_timer <= ped_timer - 1;
        end
        else
            ped_timer <= 3'd5;   // reload when not in pedestrian state
    end

    // -------------------------
    // Next-state logic
    // -------------------------
    always_comb begin
        case (current_state)
            RED_CAR:  next_state = ped_latched ? RED_PED : GREEN;
            GREEN:    next_state = YELLOW;
            YELLOW:   next_state = RED_CAR;
            RED_PED:  next_state = (ped_timer == 0) ? GREEN : RED_PED;
            default:  next_state = RED_CAR;
        endcase
    end

    // -------------------------
    // Output logic
    // -------------------------
    always_comb begin
        red = 0; yellow = 0; green = 0;
        ped_walk = 0;
        ped_count = ped_timer;

        case (current_state)
            RED_CAR: begin
                red = 1;
            end
            GREEN: begin
                green = 1;
            end
            YELLOW: begin
                yellow = 1;
            end
            RED_PED: begin
                red = 1;
                ped_walk = 1;
            end
        endcase
    end

endmodule
