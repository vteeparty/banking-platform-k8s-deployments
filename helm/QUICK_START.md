# Quick Start Commands

## When you have Kubernetes running:

### 1. Verify cluster
```bash
kubectl cluster-info
```

### 2. Deploy all services (choose one method)

**Method A - Using Helm:**
```bash
helm install payment-service ./helm/payment-service
helm install transaction-service ./helm/transaction-service
helm install notification-service ./helm/notification-service
```

**Method B - Using kubectl:**
```bash
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/
```

### 3. Check status
```bash
kubectl get pods
kubectl get services
```

### 4. Access services locally (if needed)
```bash
kubectl port-forward service/payment-service 8081:8081
kubectl port-forward service/transaction-service 8082:8082
kubectl port-forward service/notification-service 8083:8083
```

---

## ✅ What's Ready:

- ✅ Helm charts created for all 3 services
- ✅ Templates configured with proper variables
- ✅ Services exposed on ports 8081, 8082, 8083
- ✅ Replica count set to 1
- ✅ Using ClusterIP service type

## ⏳ What You Need:

- ⏳ Working Kubernetes cluster (Docker Desktop or Minikube)
- ⏳ Docker images built for your services

---

**For full documentation, see:** [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
