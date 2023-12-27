#!/bin/bash

[ -f temp_sensor.mag ] && rm temp_sensor.mag
[ -f temp_sensor.pex.spice ] && rm temp_sensor.pex.spice

# Run OpenLane flow to build layout
flow.tcl -design ../src -tag foo -overwrite
cp ../src/runs/foo/results/final/mag/temp_sensor.mag .

# Extract netlist from layout
iic-pex.sh -m 1 -s 1 temp_sensor.mag

# Get rid of MOSFET for decoupling
TMP=tmp.spice
mv temp_sensor.pex.spice $TMP
cat $TMP | grep -v "vccd1 vssd1 vccd1 vccd1" | grep -v "vssd1 vccd1 vssd1 vssd1" > temp_sensor.pex.spice
rm $TMP
