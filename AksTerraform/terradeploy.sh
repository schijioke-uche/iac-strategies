
#!/usr/bin/env bash

#Author:  Jeffrey Solomon Chijioke-Uche (MSIT, MSIS) - United States
#Softwareid:  MZ-68922876-0004
#Usage: Terraform Auto Deployment to Azure
#Model: AzureRM 1.36.0 = 2.0+
#Knowledgebase Number:  [098126-2021]
#Strategy for updating Docker image when required.
          
#     /\    M I C R O S O F T (C)
#    /  \    _____   _ _  ___ _
#   / /\ \  |_  / | | | \'__/ _\
#  / ____ \  / /| |_| | | |  __/
# /_/    \_\/___|\__,_|_|  \___|  T E R R A F O R M   S O F T W A R E (R)


#System Pre-requisites:
#-Terraform plugin.
#-Azure CLI plugin.
#-Bash (Bourne shell) plugin.
#-Az aks plugin.
#===================================================================================


function input(){
#input remote state storage path
REMOTE_STATE_ENDPOINT="https://{STORAGEACCOUNTNAME}.blob.core.windows.net/{CONTAINERNAME}/{ACCOUNTKEY}"
}


function init(){
#Initiate
terraform init -input=false
cProcesswait
}


function validate(){
#Validate
terraform validate
cProcesswait
}


function plan(){
#For Best Practice - Store production state file in the cloud - storage account
terraform plan -state=$REMOTE_STATE_ENDPOINT -input=false
cProcesswait
}


function apply(){
#Apply
terraform apply -auto-approve -var-file="aks.dev.tfvars" $REMOTE_STATE_ENDPOINT
cProcesswait
}



#Process Wait:
function cProcesswait(){
sleep 10m & PID=$! 
echo -e "Please wait..."
printf "["
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 10s
done
printf "] ${GREEN}done!${NOCOLOR}" 
echo -e ""
}

#Process indicators:
function Indicators(){
  NOCOLOR='\033[0m'
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  ORANGE='\033[0;33m'
  BLUE='\033[0;34m'
  PURPLE='\033[0;35m'
  CYAN='\033[0;36m'
  LIGHTGRAY='\033[0;37m'
  DARKGRAY='\033[1;30m'
  LIGHTRED='\033[1;31m'
  LIGHTGREEN='\033[1;32m'
  YELLOW='\033[1;33m'
  LIGHTBLUE='\033[1;34m'
  LIGHTPURPLE='\033[1;35m'
  LIGHTCYAN='\033[1;36m'
  WHITE='\033[1;37m'
}
#END: Optum-Z9773-2019
function azure(){
  echo -e "${GREEN}Azure Cloud Deployment Completed!${NOCOLOR}"
  echo -e "${GREEN}
    /---\   M I C R O S O F T                             
   /  _  \ __________ _________   ____  
  /  /_\  \\___   /  |  \_  __ \_/ __ \ 
 /    |    \/    /|  |  /|  | \/\  ___/ 
 \____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
 I N F R A S T R U C T U R E  AS  C O D E  D E P L O Y M E N T ${NOCOLOR}"
}
#Exec::::::::::::::::::::::#
input
init
plan
apply
azure
#Exec::::::::::::::::::::::#