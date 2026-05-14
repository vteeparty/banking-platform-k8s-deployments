#!/bin/bash
# Port Forwarding - Test Services Without Ingress
# Works with any Kubernetes cluster - no admin required

echo "================================================"
echo "Banking Platform - Port Forward Setup"
echo "================================================"

# Check if kubectl is available
echo -e "\nChecking kubectl connection..."
if ! kubectl cluster-info > /dev/null 2>&1; then
    echo "No Kubernetes cluster found."
    echo -e "\nOptions:"
    echo "1. Use Play with Kubernetes (https://labs.play-with-k8s.com/)"
    echo "2. Use Google Cloud Shell (https://console.cloud.google.com/)"
    echo "3. See ALTERNATIVE_DEPLOYMENT.md for more options"
    exit 1
fi

echo "Connected to cluster!"

# Apply deployments
echo -e "\nDeploying services..."
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/

# Wait for pods to be ready
echo -e "\nWaiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=payment-service --timeout=60s
kubectl wait --for=condition=ready pod -l app=transaction-service --timeout=60s
kubectl wait --for=condition=ready pod -l app=notification-service --timeout=60s

echo -e "\n================================================"
echo "Services deployed! Starting port forwarding..."
echo "================================================"

echo -e "\nAccess services at:"
echo "  Payment Service:      http://localhost:8081"
echo "  Transaction Service:  http://localhost:8082"
echo "  Notification Service: http://localhost:8083"

echo -e "\nPress Ctrl+C to stop all port forwards"
echo "================================================"

# Trap Ctrl+C to cleanup
trap "echo -e '\nStopping port forwards...'; killall kubectl; exit" INT TERM

# Start port forwarding in background
kubectl port-forward svc/payment-service 8081:8081 &
kubectl port-forward svc/transaction-service 8082:8082 &
kubectl port-forward svc/notification-service 8083:8083 &

echo -e "\nPort forwarding active. Test with:"
echo "  curl http://localhost:8081"
echo "  curl http://localhost:8082"
echo "  curl http://localhost:8083"

# Wait indefinitely
wait
