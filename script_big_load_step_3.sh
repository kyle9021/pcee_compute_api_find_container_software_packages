#!/bin/bash


cat ./report_$(date  +%m_%d_%y).csv | awk 'NR == 1 || NR % 2 == 0' > finished_report_$(date  +%m_%d_%y).csv

# time to clean

rm temp.json

exit
