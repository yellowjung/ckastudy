### 1. How many ClusterRoles do you see defined in the cluster?
- kubectl get clusterroles --no-headers | wc -l

### 2. How many ClusterRoleBindings exist on the cluster?
- kubectl get clusterrolebindings --no-headers | wc -l

### 3.What namespace is the cluster-admin clusterrole part of?
- Cluster Roles are cluster wide and not part of namespace

### 4. What user/groups are the cluster-admin role bound to?
- The ClusterRoleBinding for the role is with the same name.
- system:masters

### 5. What level of permission does the cluster-admin role grant?
- Inspect the cluster-admin role's privileges.
- Perform any action on any resource in the cluster

### 6. A new user michelle joined the team. She will be focusing on the nodes in the cluster. Create the required ClusterRoles and ClusterRoleBindings so she gets access to the nodes.
- michelle.yaml
- kubectl create -f michelle_role.yaml
- kubectl create -f michelle_rolebinding.yaml

### 7. michelle's responsibilities are growing and now she will be responsible for storage as well. Create the required ClusterRoles and ClusterRoleBindings to allow her access to Storage. Get the API groups and resource names from command kubectl api-resources. Use the given spec:
- ClusterRole: storage-admin
- Resource: persistentvolumes
- Resource: storageclasses
- ClusterRoleBinding: michelle-storage-admin
- ClusterRoleBinding Subject: michelle
- ClusterRoleBinding Role: storage-admin
- 