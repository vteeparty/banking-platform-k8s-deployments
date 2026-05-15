#!/bin/bash
# Full automated deploy script - runs inside WSL with sudo

set -e

WINDOWS_USER="meghareddy"
KUBE_DIR="/mnt/c/Users/${WINDOWS_USER}/.kube"
MANIFESTS="/mnt/c/Users/${WINDOWS_USER}/OneDrive/Desktop/Pavan teeparthy/banking-platform-k8s-deployments"

echo ""
echo "================================================"
echo " Banking Platform - Automated K8s Deployment"
echo "================================================"
echo ""

# Step 1: Ensure k3s is running
echo "[1/6] Starting k3s service..."
systemctl start k3s
sleep 8
systemctl is-active k3s && echo "     ✅ k3s is running" || { echo "❌ k3s failed to start"; exit 1; }

# Step 2: Wait for node to be ready
echo "[2/6] Waiting for Kubernetes node to be ready..."
for i in $(seq 1 30); do
  STATUS=$(k3s kubectl get nodes --no-headers 2>/dev/null | awk '{print $2}' | head -1)
  if [ "$STATUS" = "Ready" ]; then
    echo "     ✅ Node is Ready"
    break
  fi
  echo "     ... waiting ($i/30)"
  sleep 3
done

# Step 3: Copy kubeconfig to Windows
echo "[3/6] Configuring kubectl for Windows..."
mkdir -p "${KUBE_DIR}"
# Fix server address from 127.0.0.1 to WSL IP so Windows kubectl can reach it
WSL_IP=$(hostname -I | awk '{print $1}')
cat /etc/rancher/k3s/k3s.yaml | sed "s/127.0.0.1/${WSL_IP}/g" > "${KUBE_DIR}/config"
chmod 600 "${KUBE_DIR}/config"
echo "     ✅ kubeconfig written to Windows (~/.kube/config)"
echo "     ✅ WSL cluster IP: ${WSL_IP}"

# Step 4: Deploy namespace, configmap, secret
echo "[4/6] Deploying namespace, ConfigMap and Secret..."
k3s kubectl apply -f "${MANIFESTS}/namespaces/namespace.yaml"
k3s kubectl apply -f "${MANIFESTS}/namespaces/configmap.yaml"
k3s kubectl apply -f "${MANIFESTS}/namespaces/secret.yaml"
echo "     ✅ Namespace, ConfigMap, Secret created"

# Step 5: Deploy all services
echo "[5/6] Deploying microservices..."
k3s kubectl apply -f "${MANIFESTS}/manifests/payment-service/service.yaml"
k3s kubectl apply -f "${MANIFESTS}/manifests/payment-service/deployment.yaml"
k3s kubectl apply -f "${MANIFESTS}/manifests/transaction-service/service.yaml"
k3s kubectl apply -f "${MANIFESTS}/manifests/transaction-service/deployment.yaml"
k3s kubectl apply -f "${MANIFESTS}/manifests/notification-service/service.yaml"
k3s kubectl apply -f "${MANIFESTS}/manifests/notification-service/deployment.yaml"
echo "     ✅ All services deployed"

# Step 6: Wait for pods and show results
echo "[6/6] Waiting for pods to start..."
sleep 10
k3s kubectl wait --for=condition=ready pod --all -n banking-platform --timeout=90s 2>/dev/null || true

echo ""
echo "================================================"
echo " ✅ DEPLOYMENT COMPLETE!"
echo "================================================"
echo ""
k3s kubectl get all -n banking-platform
echo ""
echo "Useful commands (from PowerShell):"
echo "  kubectl get pods -n banking-platform"
echo "  kubectl logs -n banking-platform -l app=payment-service"
echo "  kubectl get svc -n banking-platform"
echo ""
