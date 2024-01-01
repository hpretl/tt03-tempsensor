#!/bin/bash
# 2023-12-30 Harald Pretl, IIC@JKU

# Post processing of ngspice simulation of temperature sensor

# First clean up if there is stuff lying around
rm -f *.number
rm -f res.tt.csv
rm -f res.ss.csv
rm -f res.ff.csv

# Convert results into numbers
for f in res*.txt
do
	echo "Processing $f"
	awk 'BEGIN {res=0;i=1} {res=res+($3>0.9)*i;i=i*2 } END {print res}' $f > $f.number
done

# Sort a bit tricky due to filenames with negative numbers
ls res.tt.*.number | sort -k 1.8g | xargs cat > res.tt.csv
ls res.ss.*.number | sort -k 1.8g | xargs cat > res.ss.csv
ls res.ff.*.number | sort -k 1.8g | xargs cat > res.ff.csv

