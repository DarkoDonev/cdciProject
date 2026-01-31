k3d cluster list;
k3d cluster delete cdci;
k3d cluster create cdci --api-port 127.0.0.1:6550 --agents 1;
k3d kubeconfig merge cdci --kubeconfig-merge-default --kubeconfig-switch-context;

# Test if it is okay
# kubectl get nodes
# kubectl cluster-info

# Create Namespace
kubectl apply -f namespaces/namespace.yaml;

# Create ConfigMap
kubectl apply -f configmaps/configmap.yaml;

# Create Services
kubectl apply -f ./services/backend-service.yaml;
kubectl apply -f ./services/frontend-service.yaml;
kubectl apply -f ./services/db-service.yaml;

# Create DB StatefulSet
kubectl apply -f ./statefulset/mongodb-statefulset.yaml;

# Create Deployments
kubectl apply -f ./deployments/backend-deployment.yaml;
kubectl apply -f ./deployments/frontend-deployment.yaml;


