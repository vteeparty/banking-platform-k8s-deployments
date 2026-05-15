# 📋 Banking Platform K8s - Quick Reference

## 🚀 ONE-COMMAND DEPLOYMENT (Copy Everything Below)

```bash
# Complete deployment script - Copy and paste this entire block into Play with Kubernetes

# 1. Create Namespace
kubectl create namespace banking-platform

# 2. Create ConfigMap
kubectl create configmap banking-app-config -n banking-platform \
  --from-literal=DB_HOST=postgres-service \
  --from-literal=DB_PORT=5432 \
  --from-literal=DB_NAME=banking_db \
  --from-literal=PAYMENT_SERVICE_PORT=8081 \
  --from-literal=TRANSACTION_SERVICE_PORT=8082 \
  --from-literal=NOTIFICATION_SERVICE_PORT=8083 \
  --from-literal=APP_ENVIRONMENT=development

# 3. Create Secret
kubectl create secret generic banking-app-secret -n banking-platform \
  --from-literal=DB_USERNAME=dbuser \
  --from-literal=DB_PASSWORD=change-me-in-production \
  --from-literal=API_KEY=your-api-key-here \
  --from-literal=JWT_SECRET=your-jwt-secret-key

# 4. Deploy Services (using nginx as demo image)
kubectl apply -n banking-platform -f - <<EOF
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: payment-service
  template:
    metadata:
      labels:
        app: payment-service
    spec:
      containers:
      - name: payment-service
        image: nginx:alpine
        ports:
        - containerPort: 80
        envFrom:
        - configMapRef:
            name: banking-app-config
        - secretRef:
            name: banking-app-secret
---
apiVersion: v1
kind: Service
metadata:
  name: payment-service
spec:
  selector:
    app: payment-service
  ports:
  - port: 8081
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: transaction-service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: transaction-service
  template:
    metadata:
      labels:
        app: transaction-service
    spec:
      containers:
      - name: transaction-service
        image: nginx:alpine
        ports:
        - containerPort: 80
        envFrom:
        - configMapRef:
            name: banking-app-config
        - secretRef:
            name: banking-app-secret
---
apiVersion: v1
kind: Service
metadata:
  name: transaction-service
spec:
  selector:
    app: transaction-service
  ports:
  - port: 8082
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: notification-service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: notification-service
  template:
    metadata:
      labels:
        app: notification-service
    spec:
      containers:
      - name: notification-service
        image: nginx:alpine
        ports:
        - containerPort: 80
        envFrom:
        - configMapRef:
            name: banking-app-config
        - secretRef:
            name: banking-app-secret
---
apiVersion: v1
kind: Service
metadata:
  name: notification-service
spec:
  selector:
    app: notification-service
  ports:
  - port: 8083
    targetPort: 80
EOF

# 5. Verify
echo "✅ Deployment complete! Checking status..."
kubectl get all -n banking-platform
```

## 🔍 VERIFICATION COMMANDS

```bash
# Check everything
kubectl get all -n banking-platform

# Check pods only
kubectl get pods -n banking-platform

# Check if pods are ready
kubectl get pods -n banking-platform -o wide

# View logs
kubectl logs -n banking-platform -l app=payment-service
```

## 🧹 CLEANUP

```bash
# Delete everything
kubectl delete namespace banking-platform
```

---

## 📚 DETAILED COMMANDS

### View Resources
```bash
kubectl get pods -n banking-platform
kubectl get svc -n banking-platform
kubectl get deployments -n banking-platform
kubectl get configmap -n banking-platform
kubectl get secret -n banking-platform
```

### Describe Resources
```bash
kubectl describe pod <pod-name> -n banking-platform
kubectl describe svc payment-service -n banking-platform
```

### View Logs
```bash
kubectl logs -n banking-platform <pod-name>
kubectl logs -n banking-platform -l app=payment-service
kubectl logs -n banking-platform <pod-name> --follow
```

### Execute Commands in Pod
```bash
kubectl exec -n banking-platform <pod-name> -- env
kubectl exec -n banking-platform <pod-name> -- printenv | grep DB
kubectl exec -it -n banking-platform <pod-name> -- sh
```

### Restart Deployment
```bash
kubectl rollout restart deployment payment-service -n banking-platform
kubectl rollout restart deployment -n banking-platform --all
```

### Scale Deployment
```bash
kubectl scale deployment payment-service -n banking-platform --replicas=3
```

### Port Forward (Access from localhost)
```bash
kubectl port-forward -n banking-platform svc/payment-service 8081:8081
# Then access: http://localhost:8081
```

---

## 🎯 PLAY WITH KUBERNETES SETUP

### Step 1: Initialize Cluster (First Time Only)
```bash
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

### Step 2: Wait for Ready
```bash
kubectl get nodes
# Wait until STATUS shows "Ready"
```

### Step 3: Deploy (Use the ONE-COMMAND DEPLOYMENT above)

---

## 💡 TIPS

- **Session expires in 4 hours** - Save important data
- **Using nginx:alpine as demo** - Replace with your actual images
- **All configs are in the banking-platform namespace**
- **Secrets are plain text** - Update for production use
- **To reset**: Just delete namespace and redeploy
