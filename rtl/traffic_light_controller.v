`timescale 1ns/1ps

module traffic_light_controller (
    input  clk,
    input  reset,
    input  ped_req,
    output reg red,
    output reg yellow,
    output reg green,
    output reg ped_walk
);

    typedef enum logic [1:0] {
        RED_CAR = 2'b00,
        GREEN   = 2'b01,
        YELLOW  = 2'b10,
        RED_PED = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg ped_latched;

    always @(posedge clk or posedge reset) begin
        if (reset)
            ped_latched <= 0;
        else if (ped_req)
            ped_latched <= 1;
        else if (current_state == RED_PED)
            ped_latched <= 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= RED_CAR;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            RED_CAR:  next_state = ped_latched ? RED_PED : GREEN;
            GREEN:    next_state = YELLOW;
            YELLOW:   next_state = RED_CAR;
            RED_PED:  next_state = GREEN;
            default:  next_state = RED_CAR;
        endcase
    end

    always @(*) begin
        red = 0; yellow = 0; green = 0; ped_walk = 0;
        case (current_state)
            RED_CAR: begin red = 1; end
            GREEN:   begin green = 1; end
            YELLOW:  begin yellow = 1; end
            RED_PED: begin red = 1; ped_walk = 1; end
        endcase
    end

endmodule

