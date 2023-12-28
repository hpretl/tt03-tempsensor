`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input clk,
    input rst,
    input en_quick_transition,
    input [4:0] tempsens_cfg,
    output tempsens_pwm,
    output [6:0] segments
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {tempsens_cfg, en_quick_transition, rst, clk};
    wire [7:0] outputs;
    assign segments = outputs[6:0];
    assign tempsens_pwm = outputs[7];

    // instantiate the DUT
    hpretl_tt03_temperature_sensor tempsens (
        `ifdef GL_TEST
            .vccd1( 1'b1),
            .vssd1( 1'b0),
        `endif
        .io_in  (inputs),
        .io_out (outputs)
        );

endmodule // tb
