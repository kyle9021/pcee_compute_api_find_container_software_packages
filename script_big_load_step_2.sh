#!/bin/bash

cat ./temp.json | jq '[.[] | {image_name: .instances[].image, package_info: .packages[].pkgs[]} ]' \
| jq 'group_by(.image_name)[] | {image_name: .[0].image_name, package_info: [.[].package_info | {name: .name, version: .version, license: .license}]} | {image_name: .image_name, package_info: .package_info[]}' \
| jq '[. | {image_name: .image_name, name: .package_info.name, version: .package_info.version, license: .package_info.license}]' \
| jq '[.[]]' |jq -r 'map({image_name,name,version,license}) | (first | keys_unsorted) as $keys | map([to_entries[] | .value]) as $rows |$keys,$rows[]| @csv' > ./report_$(date  +%m_%d_%y).csv


bash ./script_big_load_step_3.sh

exit

