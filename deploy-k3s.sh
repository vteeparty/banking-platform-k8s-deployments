#!/bin/bash
# Deploy to k3s in WSL

echo "================================================"
echo "Deploying to k3s Cluster"
echo "================================================"

# Wait for k3s to be fully ready
echo "Waiting for k3s API server..."
sleep 10

# Deploy services
echo -e "\nDeploying payment service..."
sudo k3s kubectl apply -f manifests/payment-service/ --validate=false

echo -e "\nDeploying transaction service..."
sudo k3s kubectl apply -f manifests/transaction-service/ --validate=false

echo -e "\nDeploying notification service..."
sudo k3s kubectl apply -f manifests/notification-service/ --validate=false

# Wait for pods
echo -e "\nWaiting for pods to be ready..."
sleep 10

# Deploy ingress
echo -e "\nDeploying ingress..."
sudo k3s kubectl apply -f ingress/ingress.yaml --validate=false

# Show status
echo -e "\n================================================"
echo "Deployment Status"
echo "================================================"
sudo k3s kubectl get all
echo ""
sudo k3s kubectl get ingress

echo -e "\n================================================"
echo "Access your services:"
echo "================================================"
echo "Use kubectl port-forward to access services:"
echo "  sudo k3s kubectl port-forward svc/payment-service 8081:8081"
echo "  sudo k3s kubectl port-forward svc/transaction-service 8082:8082"
echo "  sudo k3s kubectl port-forward svc/notification-service 8083:8083"
echo "================================================"
