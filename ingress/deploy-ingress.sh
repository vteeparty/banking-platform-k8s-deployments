#!/bin/bash

# Deploy Ingress for Banking Platform Microservices
# This script sets up the ingress controller and applies the ingress configuration

echo "================================================"
echo "Banking Platform - Ingress Deployment"
echo "================================================"

# Check if Minikube is running
if ! minikube status > /dev/null 2>&1; then
    echo "❌ Minikube is not running. Starting Minikube..."
    minikube start
fi

# Enable ingress addon
echo "📦 Enabling NGINX Ingress Controller..."
minikube addons enable ingress

# Wait for ingress controller to be ready
echo "⏳ Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Apply the ingress configuration
echo "🚀 Applying ingress configuration..."
kubectl apply -f ingress/ingress.yaml

# Display ingress status
echo ""
echo "✅ Ingress deployed successfully!"
echo ""
echo "Ingress Status:"
kubectl get ingress

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)
echo ""
echo "================================================"
echo "Access your services at:"
echo "================================================"
echo "Minikube IP: $MINIKUBE_IP"
echo ""
echo "Add to /etc/hosts (Linux/Mac) or C:\\Windows\\System32\\drivers\\etc\\hosts (Windows):"
echo "$MINIKUBE_IP banking.local"
echo ""
echo "Then access services:"
echo "  http://banking.local/payment"
echo "  http://banking.local/transaction"
echo "  http://banking.local/notification"
echo ""
echo "Or use IP directly:"
echo "  http://$MINIKUBE_IP/payment"
echo "  http://$MINIKUBE_IP/transaction"
echo "  http://$MINIKUBE_IP/notification"
echo "================================================"
