#!/usr/bin/env bash

#Author:  Jeffrey Solomon Chijioke-Uche (MSIT, MSIS) - United States.
#LinkedIn:  
#Softwareid:  MZ-68922876-0004
#Usage: Terraform Auto Deployment to Azure
#Model: AzureRM 1.36.0 = 2.0+
#Knowledgebase Number:  [098126-2021]
#Usage: Strategy for deploying kubernetes pods via script required.
#License: MIT License
          
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
#=============================================================================

AKSCLUSTERRGROUP="{SUPPLY-YOUR-INFO"
AKSCLUSTERNAME="SUPPLY-YOUR-INFO"

az aks get-credentials -g $AKSCLUSTERRGROUP -n $AKSCLUSTERNAME --admin 
kubectl config get-contexts
kubectl create namespace ishelloworldonly
sleep 10  # Wait for 10 seconds so that the namespace will be created. [app.yaml need the namespace]
kubectl apply -f app.yaml