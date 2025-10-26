3. kubectl create ns apx-x9984574
4. kubectl get nodes -o json > /opt/outputs/nodes-z3444kd9.json
7. static pod : /etc/kubernetes/manifest, k run static-busybox --image=busybox --dry-run=client -o yaml --command -- sleep 1000 > static-busybox.yaml
9.  k logs orange init-myservice , k replace --force -f /tmp/kubectl-edit-3627001142.yaml
10. k expose deploy hr-web-app --name=hr-web-app-service --type NodePort --port 8080 , k edit svc ---
11.  k get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os_x43kj56.txt
12.  