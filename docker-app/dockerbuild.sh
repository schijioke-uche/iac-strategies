
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
#=================================================================================

#============================
#Essential SignIn Information
#============================
DOCKER_USER="SUPPLY-YOUR-INFO"
DOCKER_PW='SUPPLY-YOUR-INFO'  #[development] [pay attention to the single quote]
DOCKER_HOST="SUPPLY-YOUR-INFO"

#==============================
#Automated login stream option1: [activated] [Development]
#==============================
echo $DOCKER_PW | docker login -u $DOCKER_USER --password-stdin $DOCKER_HOST

#==============================
#Automated login stream option2: [deactivated] [Production]
#==============================
# cat ~/isSecureVault/isPwd.txt | docker login -u $DOCKER_USER  --password-stdin $DOCKER_HOST

#============================
#Build, Tag & Push Image
#============================
docker build -t jchijiok/localhelloworld:v1.0.0 .   #[pay attention to the period in the end]
docker tag jchijiok/localhelloworld:v1.0.0 jchijiok/helloworld:v1.0.0
docker images
docker push jchijiok/helloworld:v1.0.0