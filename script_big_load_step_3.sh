#!/bin/bash


cat ./report_$(date  +%m_%d_%y).csv | awk 'NR == 1 || NR % 2 == 0' > ./temp_report_$(date  +%m_%d_%y).csv

# time to clean
if [[ -f ./temp.json ]]; then
  rm ./temp.json
fi

bash ./script_big_load_step_4.sh

exit
