#!/bin/bash
# Copyright 2023 Harald Pretl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This is a simple shell-based simulation runner for ngspice using 
# GNU parallel.

echo "[INFO] Simulation runner starting."

TMP_NAME=tmp
TMP_SUFFIX=spice
LOG_SUFFIX=log
RAW_SUFFIX=raw

# Remove old files, to make sure that new ones are created
rm -f ./*.${LOG_SUFFIX}
rm -f ./*.${RAW_SUFFIX}
rm -f ./$TMP_NAME*.$TMP_SUFFIX

# Prepare parameter sweeps
cp tb_tempsens.spice $TMP_NAME.$TMP_SUFFIX

for temp in $(seq -w -30 5 120)
do
	for swvar in $(seq -w 5 20 25)
	do
    		echo "[INFO] Creating simulation for sweep variable = $swvar, temp = $temp"
    		sed "s/__VAR__/$swvar/g" $TMP_NAME.$TMP_SUFFIX | sed "s/__TEMP__/$temp/g" > "${TMP_NAME}.${temp}.${swvar}.${TMP_SUFFIX}"
	done
done

rm $TMP_NAME.$TMP_SUFFIX

# Run the simulations in parallel by fully loading the machine
find . -name "${TMP_NAME}*.$TMP_SUFFIX" | parallel ngspice -b -o {}.${LOG_SUFFIX} -r {}.${RAW_SUFFIX} {} 

# Wait for all to finish
echo "[DONE] All simulations finished!"

