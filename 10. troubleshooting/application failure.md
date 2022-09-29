1. service define
   1. service.yaml
2. service target port 
3. change service selector name
4. edit deployment db information
5. k get pods -n epsilon mysql -o yaml > mysql.yaml
   1. change deployment environment
   2. change pod environment
6. change deployment environment
   1. change webapp service nodeport
   2. k get pods mysql -n zeta -o yaml > mysql.yaml, change environments