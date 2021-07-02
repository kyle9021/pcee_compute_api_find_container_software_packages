# Last confirmed working 7.1.2021

[![CodeFactor](https://www.codefactor.io/repository/github/kyle9021/pcee_compute_api_find_container_software_packages/badge)](https://www.codefactor.io/repository/github/kyle9021/pcee_compute_api_find_container_software_packages)

# Assumptions

* You're using PRISMA CLOUD ENTERPRISE EDTION
* You're using an Ubuntu 20.04 VM to run this from
* You understand how to harden this script for production environments

  * The biggest suggestion here is to not save the script with your secret key and access key in it. A better way to do this might be to have a seperate script which exports those credentials as environmental variables. My goal with this script is to simplify the process for those who are learning to work with the Prisma Cloud Enterprise Edition API. 
  
* If you do decide to keep the keys in this script, then it's critical you:
  
   * Add it to your `.gitignore` (if using git) file and `chmod 700 container_licenses_and_packages.bash` between steps 3 and 4 so that others can't read, write, or excute it. 

# Instructions

* Step 1: Install jq `sudo apt-get install jq`
* Step 2: `git clone https://github.com/Kyle9021/pcee_compute_api_find_container_software_packages`
* Step 3: `cd pcee_compute_api_find_container_software_packages/`
* Step 4: `nano container_licenses_and_packages.sh` and fill in the variables with the correct data from your console. 
* Step 5: `bash container_licenses_and_packages.sh`
* Step 6: `ls` to see your report


## script_big_load_1.sh instructions and explaination:

I wrote the frist script using the demo environment I had access to. Unfortunately, after working with a customer I soon realized the issues with keeping all the data in memory. 4,500 containers...etc. So as a stop-gap I wrote a second version of the script which dumps all the data to a temp.json file and then parses through that file and outputs it to a new report. It's also worth mentioning that a more experienced engineer Tom Kishel from PANW has a python script which servers a similar function located in his repo [pc-toolbox](https://github.com/tkishel/pc-toolbox). I haven't tried it yet, but if it's anything like his other work; it won't disappoint. The downside is you'll need to understand working with venv and python libraries. I'll keep this here for those not wanting to go there. 

### Instructions

* Step 1: Install jq `sudo apt-get install jq`
* Step 2: `git clone https://github.com/Kyle9021/pcee_compute_api_find_container_software_packages`
* Step 3: `cd pcee_compute_api_find_container_software_packages/`
* Step 4: `nano scipt_big_load_step_1.sh` and fill in the variables with the correct data from your console. 
* Step 5: `bash script_big_load_step_1.sh`
* Step 6: The first script calls the second one and assuming you keep this all in the same directory you won't have any issues. I'll think of a more elegant way to do this later. Thanks!

# Links to reference

* [Why this matters](https://www.softwareone.com/en/blog/all-articles/2020/11/24/oracle-java-licensing)
* [Official JQ Documentation](https://stedolan.github.io/jq/manual/)
* [Grep Documentation](https://www.gnu.org/software/grep/manual/grep.html)
* [Exporting variables for API Calls and why I choose bash](https://apiacademy.co/2019/10/devops-rest-api-execution-through-bash-shell-scripting/)
* [PAN development site](https://prisma.pan.dev/)
