
#!/usr/bin/env bash

#Author:  Jeffrey Solomon Chijioke-Uche (MSIT, MSIS) - United States
#Softwareid:  MZ-68922876-0004
#Usage: Terraform Auto Deployment to Azure
#Model: AzureRM 1.36.0 = 2.0+
#Knowledgebase Number:  [098126-2021]
#Strategy for updating Docker image when required for [Docker Hub] Repositories
          
#     /\     (C) J E F F R E Y   C H I J I O K E - U C H E
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
function isInfo(){
DOCKER_USER=""
DOCKER_PW='{}'  #[development only] 
DOCKER_SECUREPWDVAULTPATH='{}' #[Production] [path must be a secure destination]
DOCKER_TAG="{}"
DOCKER_DEST="." #[DO NOT MODIFY]
DOCKER_FOLDER="{}"
DOCKER_DOMAIN="{}"
}

#==============================
#Automated login stream option1: [activated] [Development]
#==============================
function isLogin(){
#[DEVELOPMENT]
echo $DOCKER_PW | docker login -u $DOCKER_USER --password-stdin $DOCKER_DOMAIN
#[PRODUCTION]
#cat $DOCKER_SECUREPWDVAULTPATH | docker login -u $DOCKER_USER  --password-stdin $DOCKER_DOMAIN
}

#============================
#Build, Tag & Push Image
#============================
function isBuildTagPush(){
docker build -t $DOCKER_DOMAIN/$DOCKER_USER/$DOCKER_FOLDER:$DOCKER_TAG $DOCKER_DEST
cProcesswait
docker tag $DOCKER_DOMAIN/$DOCKER_USER/$DOCKER_FOLDER:$DOCKER_TAG $DOCKER_DOMAIN/$DOCKER_USER/$DOCKER_FOLDER:$DOCKER_TAG
cProcesswait
docker images
cProcesswait
docker push $DOCKER_DOMAIN/$DOCKER_USER/$DOCKER_FOLDER:$DOCKER_TAG
cProcesswait
isdocker
}

#Process Wait:
function cProcesswait(){
sleep 5s & PID=$! 
echo -e "Please wait..."
printf "["
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 2
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
#END: ID-Z9773-2019
function isdocker(){
  echo -e "${GREEN}Docker Image Push Completed!${NOCOLOR}"
  echo -e "${GREEN}
    /---\   D O C K E R  I M A G E  R E P O S I T O R Y                             
   /  _  \ __________ _________   ____  
  /  /_\  \\___   /  |  \_  __ \_/ __ \ 
 /    |    \/    /|  |  /|  | \/\  ___/ 
 \____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
 I N F R A S T R U C T U R E  AS  C O D E  T E C H N O L O G Y ${NOCOLOR}"
}

#Exec::::::::::::::::::::::#
Indicators
isInfo
isLogin
isBuildTagPush
#Exec::::::::::::::::::::::#
