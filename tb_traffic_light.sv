`timescale 1ns/1ps

module tb_traffic_light;

logic clk;
logic reset;
logic TAORB;
logic [5:0] led;

traffic_light dut (
    .clk(clk),
    .reset(reset),
    .TAORB(TAORB),
    .led(led)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    reset = 1;
    TAORB = 1;
    #20;
    reset = 0;

    #40;
    TAORB = 0;

    #80;
    TAORB = 1;

    #80;
    $stop;
end

endmodule