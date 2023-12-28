#!/bin/bash

[ -f tb_tempsens.vcd ] && rm tb_tempsens.vcd
[ -f tb_tempsens.out ] && rm tb_tempsens.out

iverilog -o tb_tempsens.out -I ../src -D SIMULATION tb_tempsens.v
./tb_tempsens.out
gtkwave tb_tempsens.vcd
