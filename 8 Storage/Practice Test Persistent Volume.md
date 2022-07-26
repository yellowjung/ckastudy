### 4. Configure a volume to store these logs at /var/log/webapp
    - kubectl get po webapp -o yaml > webapp.yaml
    - kubectl run webapp.yaml
### 5. Create a Persistent Volume
    - pv.yaml
### 6. Create a Persistent Volume Claim
    - pvc.yaml
### 7. kubectl get pvc
### 8. kubectl get pv
### 10. Update the Access Mode
    - kubectl delete pvc claim-log-1
    - kubectl create -f claim-log-1.yaml
### 12. persistent
    - kubectl create -f webapp_persis.yaml
### 15. delete PVC
    - kubectl delete pvc claim-log-1
### 17. delete pod
    - kubectl delete pod webapp --force
