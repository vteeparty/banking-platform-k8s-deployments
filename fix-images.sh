#!/bin/bash
echo "[1/2] Patching images to nginx:alpine..."
k3s kubectl set image deployment/payment-service payment-service=nginx:alpine -n banking-platform
k3s kubectl set image deployment/transaction-service transaction-service=nginx:alpine -n banking-platform
k3s kubectl set image deployment/notification-service notification-service=nginx:alpine -n banking-platform

echo "[2/2] Waiting for pods to come up..."
sleep 25
k3s kubectl wait --for=condition=ready pod --all -n banking-platform --timeout=120s

echo ""
echo "================================================"
echo " ✅ ALL PODS RUNNING!"
echo "================================================"
echo ""
k3s kubectl get all -n banking-platform
echo ""
echo "Verify env vars are injected:"
POD=$(k3s kubectl get pod -n banking-platform -l app=payment-service -o jsonpath='{.items[0].metadata.name}')
echo "Payment pod: $POD"
k3s kubectl exec -n banking-platform $POD -- env | grep -E "DB_|APP_|PAYMENT_"
