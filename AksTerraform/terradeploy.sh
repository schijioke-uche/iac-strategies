
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

SP_ID="SUPPLY-YOUR-INFO"
SP_PW="SUPPLY-YOUR-INFO"
SP_TN="SUPPLY-YOUR-INFO"
SUB_ID="SUPPLY-YOUR-INFO"
RUN_AS_STEP=false
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