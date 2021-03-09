az aks get-credentials -g {ADD AKS-CLUSTER-RESOURCE-GROUP} -n {ADD AKS-CLUSTER-NAME} --admin 
kubectl config get-contexts
kubectl create namespace ishelloworldonly
kubectl apply -f app.yaml