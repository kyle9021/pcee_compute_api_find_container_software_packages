# Assumptions

* You're using PRISMA CLOUD ENTERPRISE EDTION
* You're using an Ubuntu 20.04 VM to run this from
* You understand how to harden this script for production environments
  * The biggest suggestion here is to not save the script with your secret key and access key in it. A better way to do this might be to have a seperate script which exports those credentials as environmental variables. But my goal with this script is to simplify the process for those who are learning to work with the Prisma Cloud Enterprise Edition API. 

# Instructions

* Install jq `sudo apt-get install jq`
* `git clone https://github.com/Kyle9021/prisma_cloud_enterprise_api_scripts/`
* `cd prisma_cloud_enterpise_api_scripts/`
*  `nano <SCRIPTNAME>` and fill in the variables with the correct data from your console. 
*  `bash <SCRIPTNAME>`
*  `ls` to see your report
