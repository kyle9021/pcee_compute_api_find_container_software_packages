#!/bin/bash
# Written By Kyle Butler Prisma SE
# Tested on 5.4.2021 on prisma_cloud_enterprise_edition using Ubuntu 20.04
# Requires jq to be installed sudo apt-get install jq

# Access key should be created in the Prisma Cloud Console under: Settings > Accesskeys
# Place the access key and secret key between "<ACCESS_KEY>" marks, below
pcee_accesskey="<PRISMA_ENTERPRISE_EDITION_ACCESS_KEY>"
pcee_secretkey="<PRISMA_ENTERPRISE_EDITION_SECRET_KEY>"

# Found on https://prisma.pan.dev/api/cloud/api-urls, replace value below if it doesn't fit your environment. 
pcee_console_api_url="api.prismacloud.io"

# Name of the software package you're looking for, partial matches okay, and perl regex works too, case sensitive.
# Found in the Prisma Console Under: Compute > Vulnerabilities on the image tab; click the image and then go to the Package Info tab. 
container_image_package_name="oracle"

# This is found  in the Prisma Cloud Console under: Compute > Manage/System on the downloads tab under Path to Console
pcee_console_url="https://<REGION>.cloud.twistlock.com/<REGION>"

# This is found in the Prisma Cloud Console under: Compute >  Monitor > Vulnerabilies on the Images Tab. look for the total number of entries found near the
# the right of the filter bar "?"
pcee_compute_image_entries=150

# Nothing below this line needs to be changed. I'll provide documentation so this can be customized for future usecases
# This variable is to ensure the max api limit is set. No need to adjust.
pcee_api_limit=50


# This variable formats everything correctly so that the next variable can be assigned.
pcee_auth_body="{\"username\":\""${pcee_accesskey}"\", \"password\":\""${pcee_secretkey}"\"}"

# This saves the auth token needed to access the CSPM side of the Prisma Cloud API to a variable $pcee_auth_token
pcee_auth_token=$(curl --request POST \
--url https://"${pcee_console_api_url}"/login \
--header 'Accept: application/json; charset=UTF-8' \
--header 'Content-Type: application/json; charset=UTF-8' \
--data "${pcee_auth_body}" | jq -r '.token')

# This variable formats everything correctly so that the next variable can be assigned.
pcee_compute_auth_body="{\"username\":\""${pcee_accesskey}"\", \"password\":\""${pcee_secretkey}"\"}"

# This saves the auth token needed to access the CWPP side of the Prisma Cloud API to a variable $pcee_compute_token
pcee_compute_token=$(curl \
-H "Content-Type: application/json" \
-d "${pcee_compute_auth_body}" \
"${pcee_console_url}"/api/v1/authenticate | jq -r '.token')

# Running a for loop using seq so that all images are reported on and the api limit is not exceeded;
# This then uses jq to filter down to repository/path:tag, the package name, the license, and the version report get's appended to a file called report.txt;
for pcee_offset in $(seq 0 "${pcee_api_limit}" "${pcee_compute_image_entries}");
do \
curl \
-X GET \
-H "Authorization: Bearer "${pcee_compute_token}"" \
-H 'Content-Type: application/json' \
""${pcee_console_url}"/api/v1/images?limit="${pcc_api_limit}"&offset="${pcee_offset}"" \
| jq '.[] | {image: .instances[].image, packages: .packages[].pkgs[].name, license: .packages[].pkgs[].license, version: .packages[].pkgs[].version}' \
| grep -P -A 2 -B 1 "${container_image_package_name}" >> report.txt;
done
