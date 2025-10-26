1. kubectl create namespace ingress-space
2. kubectl create configmap nginx-configuration --namespace ingress-space
3. kubectl create serviceaccount ingress-serviceaccount --namespace ingress-space
4. kubectl expose -n ingress-space deployment ingress-controller --type=NodePort --port=80 --name=ingress --dry-run=client -o yaml > ingress.yaml