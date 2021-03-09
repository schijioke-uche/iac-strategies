#!/usr/bin/env bash

SP_ID="SUPPLY-YOUR-INFO"
SP_PW="SUPPLY-YOUR-INFO"
SP_TN="SUPPLY-YOUR-INFO"
SUB_ID="SUPPLY-YOUR-INFO"
RUN_AS_STEP=false
PATH_TO_TFVARS_FILE="aks.tfvars"
REMOTE_STATE_ENDPOINT="https://SUPPLY-YOUR-INFO"

az login --service-principal --username $SP_ID --password $SP_PW --tenant $SP_TN 

az account set --subscription $SUB_ID
az cloud set --name AzureCloud

#Initiate
terraform init -input=false

#Validate
terraform validate

#For Best Practice - Store production state file in the cloud - storage account
terraform plan -state=$REMOTE_STATE_ENDPOINT -input=false

#Apply
terraform apply -auto-approve -var-file="aks.tfvars" $REMOTE_STATE_ENDPOINT

#GOOD BYE WORLD!