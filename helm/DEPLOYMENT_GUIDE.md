# Helm Deployment Guide

This guide explains how to deploy the three microservices using Helm once you have a Kubernetes cluster running.

## Prerequisites

1. **Kubernetes cluster running** (one of these):
   - Minikube: `minikube start --driver=docker` (requires Docker Desktop)
   - Docker Desktop with Kubernetes enabled
   - Cloud cluster (AKS, EKS, GKE)

2. **Verify cluster is accessible:**
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

3. **Helm installed** (you already have this)

---

## Deploy All Services

### Option 1: Deploy with Helm (Recommended)

Navigate to the project root and run:

```bash
# Deploy payment-service
helm install payment-service ./helm/payment-service

# Deploy transaction-service
helm install transaction-service ./helm/transaction-service

# Deploy notification-service
helm install notification-service ./helm/notification-service
```

### Option 2: Deploy using kubectl with existing manifests

If you prefer using the manifests directly:

```bash
# Deploy payment-service
kubectl apply -f manifests/payment-service/

# Deploy transaction-service
kubectl apply -f manifests/transaction-service/

# Deploy notification-service
kubectl apply -f manifests/notification-service/
```

---

## Verify Deployments

Check if pods are running:
```bash
kubectl get pods
```

Expected output:
```
NAME                                     READY   STATUS    RESTARTS   AGE
payment-service-xxxxxxxxxx-xxxxx         1/1     Running   0          30s
transaction-service-xxxxxxxxxx-xxxxx     1/1     Running   0          30s
notification-service-xxxxxxxxxx-xxxxx    1/1     Running   0          30s
```

Check services:
```bash
kubectl get services
```

Expected output:
```
NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
payment-service         ClusterIP   10.96.xxx.xxx   <none>        8081/TCP   1m
transaction-service     ClusterIP   10.96.xxx.xxx   <none>        8082/TCP   1m
notification-service    ClusterIP   10.96.xxx.xxx   <none>        8083/TCP   1m
```

---

## Customize Deployments

### Change Image Tags

Edit `values.yaml` in each service folder:
```yaml
image:
  repository: payment-service
  tag: v1.0.0  # Change this
```

Then upgrade:
```bash
helm upgrade payment-service ./helm/payment-service
```

### Scale Replicas

```bash
# Scale to 3 replicas
helm upgrade payment-service ./helm/payment-service --set replicaCount=3
```

Or edit `values.yaml`:
```yaml
replicaCount: 3
```

### Add Resource Limits

Uncomment and edit in `values.yaml`:
```yaml
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi
```

---

## Uninstall Services

### Using Helm:
```bash
helm uninstall payment-service
helm uninstall transaction-service
helm uninstall notification-service
```

### Using kubectl:
```bash
kubectl delete -f manifests/payment-service/
kubectl delete -f manifests/transaction-service/
kubectl delete -f manifests/notification-service/
```

---

## Troubleshooting

### Pods not starting?
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image pull errors?
Make sure your Docker images exist:
- `payment-service:latest`
- `transaction-service:latest`
- `notification-service:latest`

Or update `values.yaml` with correct image names.

### Service not accessible?
```bash
# Port-forward to test locally
kubectl port-forward service/payment-service 8081:8081
kubectl port-forward service/transaction-service 8082:8082
kubectl port-forward service/notification-service 8083:8083
```

Then access at: http://localhost:8081, http://localhost:8082, http://localhost:8083

---

## Next Steps

Once services are running:
1. Set up Ingress for external access
2. Configure environment variables
3. Add ConfigMaps/Secrets for configuration
4. Set up monitoring and logging
5. Configure autoscaling

---

## Quick Reference

| Service | Port | Image |
|---------|------|-------|
| payment-service | 8081 | payment-service:latest |
| transaction-service | 8082 | transaction-service:latest |
| notification-service | 8083 | notification-service:latest |

**All Helm charts are located in:** `./helm/`

**All manifest files are located in:** `./manifests/`
