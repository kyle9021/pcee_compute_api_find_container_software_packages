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

pcee_compute_api_url="https://region.twistlock.com/region"

# Create access keys in the Prisma Cloud Enterprise Edition Console
# Example of a better way: pcee_console_api_url=$(vault kv get -format=json <secret/path> | jq -r '.<resources>')
pcee_accesskey="<access_key>"
pcee_secretkey="<secret_key>"



# Because you need to be able to represent
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

# debugging to ensure jq and cowsay are installed

if ! type "jq" > /dev/null; then
  error_and_exit "jq not installed or not in execution path, jq is required for script execution."
fi

# debugging to ensure the variables are assigned correctly not required

if [[ ! $pcee_accesskey =~ ^.{35,40}$ ]]; then
  echo "check the pcee_accesskey variable because it doesn't appear to be the correct length";
  exit;
fi

if [[ ! $pcee_secretkey =~ ^.{27,31}$ ]]; then
  echo "check the pcee_accesskey variable because it doesn't appear to be the correct length";
  exit;
fi




pcee_compute_token=$(curl -s \
                          --url "${pcee_compute_api_url}/api/v1/authenticate" \
                          --header 'Content-Type: application/json; charset=UTF-8' \
                          --data "${pcee_auth_body}" | jq -r '.token')


pcee_compute_container_count=$(curl -s -X GET \
     -H "Authorization: Bearer ${pcee_compute_token}" \
     -H 'Content-Type: application/json' \
     --url "${pcee_compute_api_url}/api/v1/containers/count")

if [[ $(printf %s "${pcee_auth_token}") == null ]]; then
  echo "auth token not given; check your access key and secret key variables; also, check the expiration date in the prisma cloud console";
  exit;
else
  echo "token recieved";
fi

pcee_compute_api_limit=50


for pcee_offset in $(seq 0 ${pcee_compute_api_limit} ${pcee_compute_container_count}); do \
        curl -X GET \
             -H "Authorization: Bearer ${pcee_compute_token}" \
             -H 'Content-Type: application/json' \
             --url "${pcee_compute_api_url}/api/v1/images?limit=${pcee_compute_api_limit}&offset=${pcee_offset}" >> ./temp.json ;
        done


bash ./script_big_load_step_2.sh
