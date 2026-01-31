kubectl apply -f kubernetes/deployments/frontend-deployment.yaml;
kubectl -n cdci rollout restart deployment/frontend;
kubectl -n cdci rollout status deployment/frontend;
