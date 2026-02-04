`timescale 1ns/1ps

module tb_traffic_light_controller;

    reg clk;
    reg reset;
    reg ped_req;
    wire red, yellow, green, ped_walk;

    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .ped_req(ped_req),
        .red(red),
        .yellow(yellow),
        .green(green),
        .ped_walk(ped_walk)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        ped_req = 0;

        #20 reset = 0;
        #30 ped_req = 1;
        #10 ped_req = 0;

        #200 $finish;
    end

endmodule

