#!/bin/bash

# Remove old files, to make sure that new ones are created
rm -f ./*.log
rm -f ./*.raw

# Now start all sims in parallel
ngspice -b -o tb_tempsens_p00.log -r tb_tempsens_p00.raw tb_tempsens_p00.spice &
ngspice -b -o tb_tempsens_p30.log -r tb_tempsens_p30.raw tb_tempsens_p30.spice &
ngspice -b -o tb_tempsens_p60.log -r tb_tempsens_p60.raw tb_tempsens_p60.spice &
ngspice -b -o tb_tempsens_p90.log -r tb_tempsens_p90.raw tb_tempsens_p90.spice &

# wait for all to finish
wait
echo "[DONE] All simulations finished!"

