### 1. kubectl get sc
### 2. kubectl get sc
### 3. kubectl describe sc
### 7. Let's fix that. Create a new PersistentVolumeClaim
  - kubectl create -f local-pvc.yaml
### 11. create nginx
  - kubectl run nginx --image=nginx:alpine --dry-run=client -o yaml > nginx.yaml
  - kubectl create -f nginx.yaml
### 12. kubectl get pvc
### 13. kubectl create -f delayed-volume-sc.yaml