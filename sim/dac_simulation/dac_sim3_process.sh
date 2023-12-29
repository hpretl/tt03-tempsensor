#!/bin/bash

for f in dac.*.?5.txt
do
	echo $f
	awk ' BEGIN { i=-30 } { print i "," $3; i=i+5 }' $f > $f.csv
done

