`default_nettype none
`define SIMULATION
`include "hpretl_tt03_temperature_sensor.v"
`timescale 1us/1ns

//`define RAW_MODE

module tb_tempsens;

    reg CLK = 0;
    reg RESET = 1;
    reg CAL_CLK = 0;
    reg CAL_DAT = 0;
    reg CAL_ENA = 1;
`ifdef RAW_MODE
    reg [2:0] DBG = 3'b011;
`endif
`ifndef RAW_MODE
    reg [2:0] DBG = 0;
`endif
    wire [7:0] LEDDISP;


    initial begin
        $dumpfile ("tb_tempsens.vcd");
        $dumpvars (0, tb_tempsens);

        #50 CAL_CLK = 1;
        #150 CAL_CLK = 0;

        #100 RESET = 0;

        #1200000 $finish;        
    end

    // make clock 10kHz
    always #50 CLK = ~CLK;


   // wire up the inputs and outputs
    wire [7:0] inputs = {DBG, CAL_ENA, CAL_DAT, CAL_CLK, RESET, CLK};
    wire [7:0] outputs;
    assign LEDDISP = outputs[7:0];

    // instantiate the DUT
    hpretl_tt03_temperature_sensor tempsens (
        .io_in  (inputs),
        .io_out (outputs)
    );

endmodule // tb_tempsens
