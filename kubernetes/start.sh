#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Delete old cluster
k3d cluster delete cdci || true

# Create cluster
k3d cluster create cdci --api-port 127.0.0.1:6550 --agents 1 --port 80:80@loadbalancer

# Load your images into k3d
echo "Loading images into k3d cluster..."
k3d image import darkodonev/kiii-backend:latest -c cdci || echo "Note: Backend image loaded"
k3d image import darkodonev/kiii-frontend:latest -c cdci || echo "Note: Frontend image loaded"
k3d image import mongo:latest -c cdci || echo "Note: MongoDB image loaded"

k3d kubeconfig merge cdci --kubeconfig-merge-default --kubeconfig-switch-context

# Apply all YAML files
kubectl apply -f namespaces/namespace.yaml
kubectl apply -f configmaps/configmap.yaml
kubectl apply -f services/backend-service.yaml
kubectl apply -f services/frontend-service.yaml
kubectl apply -f services/db-service.yaml
kubectl apply -f statefulset/mongodb-statefulset.yaml
kubectl apply -f deployments/backend-deployment.yaml
kubectl apply -f deployments/frontend-deployment.yaml
kubectl apply -f ingress/ingress.yaml

# Wait longer for everything to start
echo "Waiting for pods to start (this can take 1-2 minutes)..."
sleep 60

# Check status
echo "=== Current Status ==="
kubectl get pods -n cdci

echo -e "\nOpen: http://localhost/"
echo "If the page doesn't load, wait another 30 seconds and refresh."
echo "Or check with: kubectl get pods -n cdci"
