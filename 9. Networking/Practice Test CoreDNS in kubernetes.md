1. core dns
2. kubectl get pod -n kube-system
3. kubectl get service -n kube-system
4. kubectl -n kube-system describe deployments.apps coredns | grep -A2 Args | grep Corefile
5. kubectl exec -it hr -- nslookup mysql.payroll > /root/CKA/nslookup.out