// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_traffic_light_controller;

    logic clk;
    logic reset;
    logic ped_req;
    logic red, yellow, green, ped_walk;
    logic [2:0] ped_count;

    // DUT
    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .ped_req(ped_req),
        .red(red),
        .yellow(yellow),
        .green(green),
        .ped_walk(ped_walk),
        .ped_count(ped_count)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_traffic_light_controller);
        $display("Traffic Light Controller Simulation Started");
        $monitor("T=%0t | R=%b Y=%b G=%b PED=%b COUNT=%0d",
                  $time, red, yellow, green, ped_walk, ped_count);

        clk = 0;
        reset = 1;
        ped_req = 0;

        #20 reset = 0;

        // Normal operation
        #30;

        // Pedestrian presses button during GREEN
        ped_req = 1;
        #10 ped_req = 0;

        // Observe full countdown
        #200;

        $display("Simulation Finished");
        $finish;
    end

endmodule
