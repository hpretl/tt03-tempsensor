`default_nettype none
`define SIMULATION
`include "bin2dec.v"
`timescale 1us/1ns

module tb_bin2dec;

    reg [6:0] BIN;
    reg ONES = 1, TENS = 0;
    wire [3:0] DEC;
    integer i;


    initial begin
        $dumpfile ("tb_bin2dec.vcd");
        $dumpvars (0, tb_bin2dec);

        for (i=0; i<100; i=i+1) begin
            BIN = i;
        
        #1  TENS = 1;
            ONES = 0;

        #1  TENS = 0;
            ONES = 1;
        end
            
        $finish;
    end


    // instantiate the DUT
    bin2dec b2d (
        .i_bin(BIN),
        .i_tens(TENS),
        .i_ones(ONES),
        .o_dec(DEC)
    );

endmodule // tb_bin2dec
