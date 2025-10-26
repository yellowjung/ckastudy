2. ps aux | grep kubelet, /etc/cni/net.d/10-weave.confilist
3. kubectl get pod -n kube-system
5. ip link
6. kubectl logs -n kube-system weave-net-xxxxx weave
7. kubectl run busybox --image=busybox --dry-run=client -o yaml -- sleep 1000 > busybox.yaml
   1. kubectl create -f busybox.yaml
   2. kubectl exec busybox -- route -n
   3. kubectl exec buisybox -- ip route