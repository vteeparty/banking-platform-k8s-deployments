# Alternative Deployment Options (No Admin Required)

## Option 1: Google Cloud Shell (FREE - No Installation Required)

Google Cloud Shell provides a free Kubernetes cluster without any local installation.

### Steps:
1. Go to https://console.cloud.google.com/
2. Click "Activate Cloud Shell" (top right)
3. Run these commands:

```bash
# Create a GKE cluster (free tier)
gcloud container clusters create banking-cluster --num-nodes=1 --machine-type=e2-micro

# Get credentials
gcloud container clusters get-credentials banking-cluster

# Upload your files (use Cloud Shell editor or git)
git clone <your-repo>
cd banking-platform-k8s-deployments

# Apply deployments
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/

# Apply ingress
kubectl apply -f ingress/ingress.yaml

# Get external IP
kubectl get ingress --watch
```

## Option 2: Play with Kubernetes (100% Browser-Based, FREE)

No installation needed - runs entirely in browser.

### Steps:
1. Go to https://labs.play-with-k8s.com/
2. Click "Start" (requires Docker Hub account - free)
3. Click "+ Add New Instance"
4. Initialize cluster:

```bash
# Initialize master
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

# Copy your files (paste content)
mkdir -p banking-platform-k8s-deployments/{ingress,manifests/{payment-service,transaction-service,notification-service}}

# Create files (copy paste from your local files)
cat > ingress/ingress.yaml << 'EOF'
[paste your ingress.yaml content here]
EOF

# Apply configurations
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/
kubectl apply -f ingress/ingress.yaml
```

## Option 3: Port Forwarding (No Ingress Required)

If you have kubectl access to ANY Kubernetes cluster, you can test services without ingress:

```bash
# Apply your deployments and services
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/

# Port forward to access services locally
kubectl port-forward svc/payment-service 8081:8081
kubectl port-forward svc/transaction-service 8082:8082
kubectl port-forward svc/notification-service 8083:8083

# Access services
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083
```

## Option 4: Use a Remote Kubernetes Cluster

If you have access to any Kubernetes cluster (work, school, cloud provider):

```bash
# Make sure kubectl is configured
kubectl cluster-info

# Apply all configurations
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/
kubectl apply -f ingress/ingress.yaml

# Check status
kubectl get pods
kubectl get services
kubectl get ingress
```

## Option 5: Azure Kubernetes Service Free Tier

Azure offers free Kubernetes without admin requirements.

```bash
# Install Azure CLI (no admin required)
# Download from: https://aka.ms/installazurecliwindows

# Login
az login

# Create resource group
az group create --name banking-rg --location eastus

# Create AKS cluster (free tier)
az aks create --resource-group banking-rg --name banking-cluster --node-count 1 --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group banking-rg --name banking-cluster

# Apply configurations
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/
kubectl apply -f ingress/ingress.yaml
```

## Option 6: GitHub Codespaces (If you have GitHub account)

GitHub Codespaces provides a development environment with k3s.

1. Push your repo to GitHub
2. Create a Codespace
3. Install k3s:

```bash
curl -sfL https://get.k3s.io | sh -
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Apply configurations
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/
kubectl apply -f ingress/ingress.yaml
```

## Recommendation

**Best options without admin:**
1. **Play with Kubernetes** - Fastest, completely free, no setup
2. **Google Cloud Shell** - Professional environment, free tier available
3. **Port Forwarding** - If you already have kubectl access somewhere

All your configuration files are ready and will work on any of these platforms!
