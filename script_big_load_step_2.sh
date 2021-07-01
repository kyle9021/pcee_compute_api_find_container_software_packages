#!/bin/bash


cat temp.json | jq '[.[] |{image_name: .instances[].image, package_info: .packages[].pkgs[]}]' \
| jq 'group_by(.image_name)[] | {image_name: .[0].image_name, package_info: [.[].package_info | {package_name: .name,version: .version,license: .license }]}' \
| jq '[{(.image_name): .package_info[]}]' \
| grep -i -P -B 2 -A 2 "${pcee_package}" > "$(date  +%m_%d_%y)_container_images_with_${pcee_package}.txt"


echo "report saved in this directory as $(date  +%m_%d_%y)_container_images_with_${pcee_package}.txt"

exit

