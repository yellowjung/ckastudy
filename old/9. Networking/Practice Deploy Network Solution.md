4. ip a | grep eth0
   1. kubectl get po -n kube-system
   2. kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.50.0.0/16"
   3. kubectl get pods -n kube-system