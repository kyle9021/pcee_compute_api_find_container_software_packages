#!/bin/bash
# Written By Kyle Butler
# Tested on 6.29.2021 on prisma_cloud_enterprise_edition using Ubuntu 20.04

# Requires jq to be installed sudo apt-get install jq


# Access key should be created in the Prisma Cloud Console under: Settings > Access keys
# Decision to leave access keys in the script to simplify the workflow
# Recommendations for hardening are: store variables in a secret manager of choice or export the access_keys/secret_key as env variables in a separate script. 

# Place the access key and secret key between "<ACCESS_KEY>", <SECRET_KEY> marks respectively below.


# Only variable(s) needing to be assigned by the end-user
# Found under compute > system > Utilities > path to Console should look like: https://region.cloud.twistlock.com/region-account


pcee_compute_api_url="https://<REGION>.cloud.twistlock.com/<REGION>"
# Create access keys in the Prisma Cloud Enterprise Edition Console
# Example of a better way: pcee_console_api_url=$(vault kv get -format=json <secret/path> | jq -r '.<resources>')
pcee_accesskey="<PRISMA_ENTERPRISE_EDITION_ACCESS_KEY>"
pcee_secretkey="<PRISMA_ENTERPRISE_EDTION_SECRET_KEY>"


# No edits needed below this line

error_and_exit() {
  echo
  echo "ERROR: ${1}"
  echo
  exit 1
}
# Because ASCII is awesome


echo "                                                  "
echo "                                                  "
echo "                                                  "
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@\033[36m((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@\033[36m((((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@\033[36m(((((((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@\033[36m(((((((((%\033[0m@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@\033[36m(((((((((((\033[0m@\033[36m((\033[0m@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@\033[36m(((((((((((%\033[0m@@\033[36m(((\033[0m@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@\033[36m(((((((((((((\033[0m@@@@\033[36m((((\033[0m@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@\033[36m((((((((((((((\033[0m@@@@@\033[36m((((((\033[0m@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@\033[36m((((((((((((((((\033[0m@@@@@@\033[36m(((((((\033[0m@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@\033[36m((((((((((((\033[0m@@@@@@@@\033[36m((((((((\033[0m@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@\033[36m((((((((\033[0m@@@@@@@@@\033[36m((((((((((\033[0m@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@\033[36m(((((\033[0m@@@@@@@@@@\033[36m(((((((((((\033[0m@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@\033[36m((((((((((((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@\033[36m((((((((((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@\033[36m(((((((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@@@\033[36m(((((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@\033[36m((\033[0m@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
sleep .01
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "                                                  "
echo "                                                  "
echo "                                                  "






pcee_auth_body_single="
{
 'username':'${pcee_accesskey}', 
 'password':'${pcee_secretkey}'
}"

pcee_auth_body="${pcee_auth_body_single//\'/\"}"

# debugging to ensure jq is installed

if ! type "jq" > /dev/null; then
  error_and_exit "jq not installed or not in execution path, jq is required for script execution."
fi

# debugging to ensure the variables are assigned correctly not required
if [[ ! $pcee_compute_api_url =~ https.*twistlock.com.* ]]; then
  echo;
  echo "pcee_console_api_url variable isn't formatted or assigned correctly; it should look like: https://<region>.twistlock.com/<region>";
  echo;
  exit;
fi

if [[ ! $pcee_accesskey =~ ^.{35,40}$ ]]; then
  echo "check the pcee_accesskey variable because it doesn't appear to be the correct length";
  exit;
fi

if [[ ! $pcee_secretkey =~ ^.{27,31}$ ]]; then
  echo "check the pcee_accesskey variable because it doesn't appear to be the correct length";
  exit;
fi




pcee_compute_token=$(curl \
                          --url "${pcee_compute_api_url}/api/v1/authenticate" \
                          --header 'Content-Type: application/json; charset=UTF-8' \
                          --data "${pcee_auth_body}" | jq -r '.token')


if [ -z "${pcee_compute_token}" ]; then
	echo
	echo -e "\033[32mauth token not recieved, recommending you check your variable assignment\033[0m";
	echo
	exit;
else
	echo
	echo "auth token recieved"
	echo
fi

pcee_compute_container_count=$(curl -s -X GET \
     -H "Authorization: Bearer ${pcee_compute_token}" \
     -H 'Content-Type: application/json' \
     --url "${pcee_compute_api_url}/api/v1/containers/count")



pcee_compute_api_limit=50


pcee_container_package_info=$(for pcee_offset in $(seq 0 ${pcee_compute_api_limit} ${pcee_compute_container_count}); do \
        curl -s -X GET \
             -H "Authorization: Bearer ${pcee_compute_token}" \
             -H 'Content-Type: application/json' \
             --url "${pcee_compute_api_url}/api/v1/images?limit=${pcee_compute_api_limit}&offset=${pcee_offset}";
        done)

printf %s "${pcee_container_package_info}" | jq '[.[] | {image_name: .instances[].image, package_info: .packages[].pkgs[]} ]' \
| jq 'group_by(.image_name)[] | {image_name: .[0].image_name, package_info: [.[].package_info | {name: .name, version: .version, license: .license}]} | {image_name: .image_name, package_info: .package_info[]}' \
| jq '[. | {image_name: .image_name, name: .package_info.name, version: .package_info.version, license: .package_info.license}]' \
| jq '[.[]]' |jq -r 'map({image_name,name,version,license}) | (first | keys_unsorted) as $keys | map([to_entries[] | .value]) as $rows |$keys,$rows[]| @csv' > ./report_$(date  +%m_%d_%y).csv



bash ./script_big_load_step_3.sh

exit
