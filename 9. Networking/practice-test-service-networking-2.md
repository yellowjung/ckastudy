1. ip a | grep eht0
   1. ipcalc -b 10.73.128.12/24
2. kubectl get pods -n kube-system
   1. kubectl logs weave-net-546g6 weave -n kube-system
3. cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range
4. kubectl get pods -n kube-system
5. kubectl logs kube-proxy-lhxc5 -n kube-system
6. kubectl get ds -n kube-system