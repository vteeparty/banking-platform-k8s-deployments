#!/bin/bash
echo "Patching imagePullPolicy to IfNotPresent on all deployments..."

for svc in payment-service transaction-service notification-service; do
  k3s kubectl patch deployment $svc -n banking-platform --type=json \
    -p="[{\"op\":\"replace\",\"path\":\"/spec/template/spec/containers/0/image\",\"value\":\"nginx:alpine\"},{\"op\":\"replace\",\"path\":\"/spec/template/spec/containers/0/imagePullPolicy\",\"value\":\"IfNotPresent\"}]"
  echo "  ✅ $svc patched"
done

echo ""
echo "Waiting 45s for pods to pull and start..."
sleep 45

echo ""
k3s kubectl get pods -n banking-platform

echo ""
echo "Pod details:"
k3s kubectl describe pods -n banking-platform | grep -E "Name:|Image:|Pull|State:|Reason:"
