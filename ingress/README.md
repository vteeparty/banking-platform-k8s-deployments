# Ingress Configuration for Banking Platform

## Overview
This directory contains the Kubernetes Ingress configuration for routing traffic to the Banking Platform microservices.

## Files
- **ingress.yaml** - Main ingress configuration
- **deploy-ingress.ps1** - PowerShell deployment script (Windows with Minikube)
- **deploy-ingress.sh** - Bash deployment script (Linux/Mac with Minikube)
- **port-forward.ps1** - Test services without ingress (any cluster)
- **port-forward.sh** - Test services without ingress (any cluster)
- **ALTERNATIVE_DEPLOYMENT.md** - Options without admin/Docker requirements
- **PLAY_WITH_K8S.md** - Quick start with browser-based Kubernetes (FREE, no install)

## Service Routes

| Path | Service | Port |
|------|---------|------|
| `/payment` | payment-service | 8081 |
| `/transaction` | transaction-service | 8082 |
| `/notification` | notification-service | 8083 |

## Prerequisites

### Option A: Local Minikube (Requires Admin/Docker)
1. **Minikube** must be installed
2. **Docker Desktop** (recommended) or **Hyper-V** must be installed and running

### Option B: No Admin Required 🎉
- **Play with Kubernetes** - Browser-based, 100% free → See [PLAY_WITH_K8S.md](PLAY_WITH_K8S.md)
- **Google Cloud Shell** - Free tier available
- **Any Kubernetes Cluster** - Use port-forward script
- See [ALTERNATIVE_DEPLOYMENT.md](ALTERNATIVE_DEPLOYMENT.md) for all options

## Quick Start

### If you DON'T have admin rights (Recommended)

**Option 1: Play with Kubernetes (Easiest)**
```bash
# Go to https://labs.play-with-k8s.com/
# Follow guide: PLAY_WITH_K8S.md
```

**Option 2: Port Forward (Any Cluster)**
```powershell
.\ingress\port-forward.ps1
```

See [ALTERNATIVE_DEPLOYMENT.md](ALTERNATIVE_DEPLOYMENT.md) for more options!

### If you HAVE admin rights and Docker/Minikube

**Windows (PowerShell)**
```powershell
# Run from project root
.\ingress\deploy-ingress.ps1
```

### Linux/Mac (Bash)
```bash
# Run from project root
chmod +x ingress/deploy-ingress.sh
./ingress/deploy-ingress.sh
```

### Manual Deployment

1. **Start Minikube:**
   ```bash
   minikube start
   ```

2. **Enable Ingress Addon:**
   ```bash
   minikube addons enable ingress
   ```

3. **Apply Ingress Configuration:**
   ```bash
   kubectl apply -f ingress/ingress.yaml
   ```

4. **Verify Deployment:**
   ```bash
   kubectl get ingress
   ```

## Accessing Services

### Option 1: Using Host Mapping (Recommended)

1. Get Minikube IP:
   ```bash
   minikube ip
   ```

2. Add to hosts file:
   - **Windows:** `C:\Windows\System32\drivers\etc\hosts`
   - **Linux/Mac:** `/etc/hosts`
   
   Add this line (replace with your actual Minikube IP):
   ```
   192.168.49.2 banking.local
   ```

3. Access services:
   - http://banking.local/payment
   - http://banking.local/transaction
   - http://banking.local/notification

### Option 2: Direct IP Access

Replace `<MINIKUBE_IP>` with your actual Minikube IP:
- http://&lt;MINIKUBE_IP&gt;/payment
- http://&lt;MINIKUBE_IP&gt;/transaction
- http://&lt;MINIKUBE_IP&gt;/notification

## Testing

```bash
# Test payment service
curl http://banking.local/payment

# Test transaction service
curl http://banking.local/transaction

# Test notification service
curl http://banking.local/notification
```

## Troubleshooting

### Ingress Not Working
```bash
# Check ingress status
kubectl get ingress
kubectl describe ingress banking-platform-ingress

# Check ingress controller pods
kubectl get pods -n ingress-nginx

# Check service endpoints
kubectl get endpoints
```

### Services Not Accessible
1. Ensure all services are running:
   ```bash
   kubectl get pods
   kubectl get services
   ```

2. Verify ingress controller is ready:
   ```bash
   kubectl wait --namespace ingress-nginx \
     --for=condition=ready pod \
     --selector=app.kubernetes.io/component=controller \
     --timeout=120s
   ```

3. Check ingress controller logs:
   ```bash
   kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller
   ```

## Configuration Details

- **API Version:** networking.k8s.io/v1
- **Ingress Controller:** NGINX
- **Path Type:** Prefix
- **Host:** banking.local (can be changed)
- **Service Type:** ClusterIP (services accessed only through ingress)

## Notes

- Services have been configured as `ClusterIP` type since they're accessed via Ingress
- The ingress uses path-based routing (not host-based)
- No TLS/SSL configuration (suitable for development)
- Compatible with Minikube ingress addon
