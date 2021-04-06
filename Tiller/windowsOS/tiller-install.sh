#!/usr/bin/env bash

#Author:  Jeffrey Solomon Chijioke-Uche (MSIT)(MSIS)
#Purpose: Contributing to OSS.
#Script id:  57634014
#Usage: Helm-tiller Installation for RBAC Enabled Clusters | WindowsOS
#Knowledgebase Number:  [3323-2019]

#    /---\   M I C R O S O F T                             
#   /  _  \ __________ _________   ____  
#  /  /_\  \\___   /  |  \_  __ \_/ __ \ 
# /    |    \/    /|  |  /|  | \/\  ___/ 
# \____|__  /_____ \____/ |__|    \___  >
#        \/      \/                  \/ 
# T I L L E R    I N S T A L L A T I O N   F O R   K U B E R N E T E S  I N G R E S S

#Pre-requisites: [Your environment local or remote must have these plugins before running the script.]
#-Kubernetes Control plugin.  https://kubernetes.io/docs/tasks/tools/ 
#-Azure CLI plugin.  https://docs.microsoft.com/en-us/cli/azure/install-azure-cli 
#-Bash plugin.   [Ensure that bash is running]
#-Helm plugin.  https://helm.sh/docs/intro/install/ 
#-Az aks plugin.  https://docs.microsoft.com/en-us/powershell/module/az.aks/install-azakskubectl?view=azps-5.7.0 

#==============================================================================
function Sa(){
#Service Account: [DO NOT USE SERVICE-PRINCIPAL CREDENTIALS{}] [USE USER-PRINCIPAL CREDENTIALS{}]
SA_USR="{}"
SA_PWD="{}"
SA_TN="{}"
SA_SUBID="{}"                                                                 #|
}

function Authenticate(){
#Authenticate
az login -u $SA_USR --p $SA_PWD --tenant $SA_TN
az account set --subscription=$SA_SUBID 
az
cProcesswait
}

function RunInfo(){
AKS_RGROUP="{}"
MANAGED_IDENTITY_RGROUP="{}"                                                                            #|
RUN_AS_STEP="{}" # Default is "false"
HELM_VERSION="{}" #Must be version 2.15.2 or 2.17.0. Be aware that v3.0.0 and above does not come with tiller.      
}

# Run mode: Default is "false".
function RunMode(){
  if [ "$RUN_AS_STEP" == "true" ]
  then
      echo "Step run mode is true"  #Helm install tiller app after kube wait.(When installing as a step alongside AKS)
        THIS_CLUSTER=$(az aks list -g $AKS_RGROUP --query "[0].name" --output tsv)
        KUBEWAIT=0
        PROFILE="az aks show -n $THIS_CLUSTER -g $AKS_RGROUP"
        until $PROFILE || [ "$KUBEWAIT" -eq 360 ]; 
        do $PROFILE
        KUBEWAIT=$((attempts + 1))
        sleep 30
        done 
      az aks get-credentials -g $AKS_RGROUP -n $THIS_CLUSTER --admin 
      kubectl config get-contexts
      TARGET_CLUSTER=$(az aks list -g $AKS_RGROUP --query "[0].name" --output tsv)
      checkTillerVersion
  else
      echo "Step run mode is false" #Helm install tiller app without kube wait. (On-Demnand - Recommended by Microsoft Inc. 2019).
      THIS_CLUSTER=$(az aks list -g $AKS_RGROUP --query "[0].name" --output tsv)
      az aks get-credentials -g $AKS_RGROUP -n $THIS_CLUSTER --admin 
      kubectl config get-contexts
      TARGET_CLUSTER=$THIS_CLUSTER
      checkTillerVersion
  fi 
}


#Check if helm is NOT install AND if wrong version of helm is installed.
function checkTillerVersion(){
  HelmWithTillerVersion=$(helm version -c --short | awk -F[:+] '{print $2}' | cut -d ' ' -f 2)
  if ! command -v helm >/dev/null 2>&1; #if helm not installed.
  then
    echo -e "Helm and Tiller not found!"
    packInstaller
  elif [  "$HelmWithTillerVersion" == "v2.15.2" ] || [  "$HelmWithTillerVersion" == "v2.17.0" ] #if correct version.
    then
    echo -e "Helm is already Installed"
    echo -e "$HelmWithTillerVersion is the version of helm installed"
    echo -e "Helm recommended for AGIC is Helm with Tiller and $HelmWithTillerVersion has tiller"
    echo -e "nothing to do at this time..."
    echo -e "Happy helming with $HelmWithTillerVersion"
  else
    echo -e "Helm and Tiller version required for AGIC is not Installed"
    packInstaller
  fi
}
 
#INSTALL HELM:
function dataPkg(){
 if [  -z "$HELM_VERSION" ] || [  "$HELM_VERSION" != "2.15.2"  ] || [  "$HELM_VERSION" != "2.17.0" ]
    then
      echo -e "Helm version expected 1 argument but invalid supplied - exit 1."
      echo -e "Compatible Helm version for AGIC is v2.15.2 or v2.17.0 which contains tiller"
      echo -e "Check the Algorithm documentation for compatible helm version..."
      echo -e "Process terminated..."
    else
    echo -e "Please wait..."
    HelmWithTiller
    azure
  fi
}

# RBAC enabled cluster tiller-deploy Service Account function - Required by AGIC for pods.
function HelmTillerSA(){
  kubectl create serviceaccount --namespace kube-system tiller-sa
}

# RBAC enabled clusters Rule Role-Binding function - Required by Aadpodidentity security for AGIC.
function isClusterRule(){
  kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller-sa
}

# RBAC enabled cluster Helm-tiller Kube System Initialization and Activation.
function HelmTillerKubeSystem(){
  #helm init --tiller-namespace kube-system --service-account tiller-sa      #DEACTIVATED: Auto version install.
  helm init --tiller-namespace=kube-system --service-account=tiller-sa --tiller-image=gcr.io/kubernetes-helm/tiller:$HELM_VERSION  --history-max 300
  helm repo rm stable
  helm repo add stable https://charts.helm.sh/stable
  cProcesswait
  kubectl -n kube-system rollout status deploy/tiller-deploy
}

# RBAC enabled Helm install chart repository for AGIC model. (Stable)
function HelmAddKubeIngRep(){
  helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
}
 
# Helm Update the Kube System.
function HelmRepUpdate(){
 helm repo update
}

# AAD Pod Identity Security (for RBAC Enabled clusters) required by AGIC to protect pods securely.
function HelmAadPodIdentity(){
  kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml
}

# Helm Kubernetes Services Managed Identity Verification for RBAC enabled clusters.
function HelmIdentityVerify(){
 tillerIdentityCid=$(az identity list -g $MANAGED_IDENTITY_RGROUP --query "[0].clientId" --output tsv)
 tillerIdentityName=$(az identity list -g $MANAGED_IDENTITY_RGROUP --query "[0].name" --output tsv)
 tillerIdentityPid=$(az identity list -g $MANAGED_IDENTITY_RGROUP --query "[0].principalId" --output tsv)
 tillerIdentityRid=$(az identity list -g $MANAGED_IDENTITY_RGROUP --query "[0].id" --output tsv)
 tillerIdentityTid=$(az identity list -g $MANAGED_IDENTITY_RGROUP --query "[0].tenantId" --output tsv)
}

#Verify that helm application installed tiller and it is running.
function HelmTillerVerify(){
  TillerUp=$(kubectl get pods -n kube-system -l app=helm)
}

# List running pods as part of Validation to lookup tiller service in the kube.
function HelmInstallVerify(){
  kubectl get pods -n kube-system
}

# Generate cluster info required for the development of AGIC.
# Kubernetes master info required for AGIC use development.
function HelmGetClusterInfo(){
 kubectl cluster-info
}

# Exec review:
function HelmInstallConfirm(){
  if [ "$TillerUp" == "No resources found in kube-system namespace." ]
  then
       echo -e "Helm installation is not successful - Please review function commands - Error HLM5689-Microsoft."
  else
       echo -e "Helm successfully installed within $AKS_RGROUP (Resource Group) and Tiller is up & running!"
       echo -e "Note & Save the Managed Identity data below - Use it on AGIC installation."
       echo -e "Managed Identity Resource Id: $tillerIdentityRid"
       echo -e "Managed Identity PrincipalId: $tillerIdentityPid"
       echo -e "Managed Identity Name: $tillerIdentityName"
       echo -e "Managed Identity Client Id: $tillerIdentityCid"
       echo -e "Cluster info: Please note/save the Kubernetes Master endpoint below - Use it as 'AKSSERVER_API_BASEURL' on AGIC installation."
       HelmGetClusterInfo
  fi
}

# Tiller Pack
function HelmWithTiller(){ 
  echo -e "Helm with tiller installing for RBAC enabled Kubernetes cluster: $TARGET_CLUSTER"               
  isClusterRule           
  HelmTillerKubeSystem 
  HelmAddKubeIngRep         
  HelmRepUpdate             
  HelmAadPodIdentity        
  HelmIdentityVerify        
  HelmTillerVerify          
  HelmInstallVerify         
  HelmInstallConfirm        
}

# Helm pack installer
function packInstaller(){
  dataPkg
}


#Process Wait:
function cProcesswait(){
sleep 15s & PID=$! 
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
function azure(){
  echo -e "${GREEN}Terraform Deployment Completed!${NOCOLOR}"
  echo -e "${GREEN}
    /---\   T E R R A F O R M                            
   /  _  \ __________ _________   ____  
  /  /_\  \\___   /  |  \_  __ \_/ __ \ 
 /    |    \/    /|  |  /|  | \/\  ___/ 
 \____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
 I N F R A S T R U C T U R E  AS  C O D E  T E C H N O L O G Y ${NOCOLOR}"
}
#Exec::::::::::::::::::::::#
Sa
Authenticate 
RunInfo
RunMode   
#Exec::::::::::::::::::::::#
#END: S-Z9889-201134