#!/usr/bin/env bash

#Set the script for EOL
sed -i 's/\r//' appdeploy.sh

#Author:  Jeffrey Solomon Chijioke-Uche (MSIT, MSIS) - United States.
#LinkedIn:  
#Softwareid:  MZ-68922876-0004
#Usage: Terraform Auto Deployment to Azure
#Model: AzureRM 1.36.0 = 2.0+
#Knowledgebase Number:  [098126-2021]
#Usage: Strategy for deploying kubernetes pods via script required.
#License: MIT License
          
#     /\    (C) J E F F R E Y   C H I J I O K E - U C H E
#    /  \    _____   _ _  ___ _
#   / /\ \  |_  / | | | \'__/ _\
#  / ____ \  / /| |_| | | |  __/
# /_/    \_\/___|\__,_|_|  \___|  T E R R A F O R M   S O F T W A R E (R)


#System Pre-requisites:
#-Terraform plugin.
#-Azure CLI plugin.
#-Bash (Bourne shell) plugin.
#-Az aks plugin.
#=============================================================================

function sa(){
#Service Account: [DO NOT USE SERVICE-PRINCIPAL CREDENTIALS{}] [USE USER-PRINCIPAL CREDENTIALS{}]
SA_USR="{}"
SA_PWD="{}"
SA_TN="{}"
}

function authenticate(){
#Authenticate
az login -u $SA_USR --p $SA_PWD --tenant $SA_TN
cProcesswait
}

#Param:
function Input(){
AKSCLUSTERRGROUP="{SUPPLY-YOUR-INFO}"
AKSCLUSTERNAME="{SUPPLY-YOUR-INFO}"
AKSNAMESPACE="{SUPPLY-YOUR-INFO}"
APPNAME="{SUPPLY-YOUR-INFO}"
}

#Finite Algorithm
function Algorithm(){
az aks get-credentials -g $AKSCLUSTERRGROUP -n $AKSCLUSTERNAME --admin 
kubectl config get-contexts
kubectl create namespace $AKSNAMESPACE
nProcesswait
kubectl apply -f $APPNAME
cProcesswait
kubectl get pods -n $AKSNAMESPACE
azure
}

#Process Wait:
function nProcesswait(){
sleep 5s & PID=$! 
echo -e "Waiting for created namespace to be ready..."
printf "["
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 2s
done
printf "] ${GREEN}done!${NOCOLOR}" 
echo -e ""
}

#Process Wait:
function cProcesswait(){
sleep 7s & PID=$! 
echo -e "Waiting for created app to be ready..."
printf "["
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 2s
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
sa
authenticate
Input
Indicators
Algorithm
#Exec::::::::::::::::::::::#