#!/bin/bash

# Found in the Prisma Console Under: Compute > Vulnerabilities on the image tab; click the image and then go to the Package Info tab
echo "Enter the name of the software package you're looking for, partial matches okay, and perl regex works too, NOT case-sensitive"
echo "Found in the compute console under: compute > vulnerabilities on the image tab"
read -r pcee_package;

awk -v pcee_package="${pcee_package}" -F, '$2 ~/pcee_package/ {print}' ./temp_report_$(date  +%m_%d_%y).csv > ./report_$(date  +%m_%d_%y)_containers_with_${pcee_package}.csv


rm ./report_$(date  +%m_%d_%y).csv

exit
