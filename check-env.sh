#!/bin/bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
POD=$(k3s kubectl get pod -n banking-platform -l app=payment-service -o jsonpath='{.items[0].metadata.name}')
echo "Checking env vars in pod: $POD"
echo ""
k3s kubectl exec -n banking-platform $POD -- env | grep -E "DB_|APP_|SERVICE_PORT|TIMEZONE" | sort
