#!/bin/bash

for f in dac*.txt
do
	awk ' BEGIN { i=0 } { print i "," $3; i=i+1 }' $f > $f.csv
done

