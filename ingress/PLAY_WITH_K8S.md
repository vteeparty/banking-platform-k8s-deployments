# Quick Start - Play with Kubernetes (No Installation Required!)

## What is Play with Kubernetes?
A free, browser-based Kubernetes environment. No installation, no admin rights needed!

## Setup (5 minutes)

### Step 1: Access Play with Kubernetes
1. Go to https://labs.play-with-k8s.com/
2. Click "Login" (requires free Docker Hub account)
3. Click "Start"
4. Click "+ Add New Instance"

### Step 2: Initialize Kubernetes
Copy and paste these commands into the terminal:

```bash
# Initialize cluster
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

# Setup network
kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

# Verify cluster is ready
kubectl get nodes
```

### Step 3: Create Your Service Files

```bash
# Create directory structure
mkdir -p banking/{payment,transaction,notification,ingress}

# Create payment-service deployment
cat > banking/payment/deployment.yaml << 'EOF'
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
        image: your-dockerhub-username/payment-service:latest
        ports:
        - containerPort: 8081
EOF

# Create payment-service service
cat > banking/payment/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: payment-service
spec:
  type: ClusterIP
  selector:
    app: payment-service
  ports:
  - port: 8081
    targetPort: 8081
EOF

# Create transaction-service deployment
cat > banking/transaction/deployment.yaml << 'EOF'
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
        image: your-dockerhub-username/transaction-service:latest
        ports:
        - containerPort: 8082
EOF

# Create transaction-service service
cat > banking/transaction/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: transaction-service
spec:
  type: ClusterIP
  selector:
    app: transaction-service
  ports:
  - port: 8082
    targetPort: 8082
EOF

# Create notification-service deployment
cat > banking/notification/deployment.yaml << 'EOF'
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
        image: your-dockerhub-username/notification-service:latest
        ports:
        - containerPort: 8083
EOF

# Create notification-service service
cat > banking/notification/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: notification-service
spec:
  type: ClusterIP
  selector:
    app: notification-service
  ports:
  - port: 8083
    targetPort: 8083
EOF

# Create ingress
cat > banking/ingress/ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: banking-platform-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: banking.local
      http:
        paths:
          - path: /payment
            pathType: Prefix
            backend:
              service:
                name: payment-service
                port:
                  number: 8081
          - path: /transaction
            pathType: Prefix
            backend:
              service:
                name: transaction-service
                port:
                  number: 8082
          - path: /notification
            pathType: Prefix
            backend:
              service:
                name: notification-service
                port:
                  number: 8083
EOF
```

### Step 4: Deploy Everything

```bash
# Apply all configurations
kubectl apply -f banking/payment/
kubectl apply -f banking/transaction/
kubectl apply -f banking/notification/

# Install NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/baremetal/deploy.yaml

# Wait for ingress controller
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Apply ingress
kubectl apply -f banking/ingress/
```

### Step 5: Verify Deployment

```bash
# Check all resources
kubectl get pods
kubectl get services
kubectl get ingress

# Test services (if they're running)
kubectl port-forward svc/payment-service 8081:8081 &
kubectl port-forward svc/transaction-service 8082:8082 &
kubectl port-forward svc/notification-service 8083:8083 &

# In Play with K8s, you'll see clickable port links!
```

## Testing

Play with Kubernetes will show you clickable links for exposed ports!

Or use curl:
```bash
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083
```

## Notes

- Your session lasts 4 hours
- Completely free
- No installation needed
- Perfect for learning and testing!

## Need Help?

See [ALTERNATIVE_DEPLOYMENT.md](ALTERNATIVE_DEPLOYMENT.md) for other options without admin requirements.
