#!/bin/bash
# Deploy Banking Platform Services to Kubernetes Playground

echo "🚀 Deploying Banking Platform Microservices..."

# Create payment-service deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
  labels:
    app: payment-service
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
        image: payment-service:latest
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 8081
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: payment-service
  labels:
    app: payment-service
spec:
  type: ClusterIP
  ports:
  - port: 8081
    targetPort: 8081
    protocol: TCP
    name: http
  selector:
    app: payment-service
EOF

echo "✅ Payment Service deployed"

# Create transaction-service deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: transaction-service
  labels:
    app: transaction-service
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
        image: transaction-service:latest
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 8082
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: transaction-service
  labels:
    app: transaction-service
spec:
  type: ClusterIP
  ports:
  - port: 8082
    targetPort: 8082
    protocol: TCP
    name: http
  selector:
    app: transaction-service
EOF

echo "✅ Transaction Service deployed"

# Create notification-service deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: notification-service
  labels:
    app: notification-service
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
        image: notification-service:latest
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 8083
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: notification-service
  labels:
    app: notification-service
spec:
  type: ClusterIP
  ports:
  - port: 8083
    targetPort: 8083
    protocol: TCP
    name: http
  selector:
    app: notification-service
EOF

echo "✅ Notification Service deployed"

echo ""
echo "🎉 All services deployed successfully!"
echo ""
echo "📊 Check status with:"
echo "   kubectl get pods"
echo "   kubectl get services"
echo ""
echo "🔍 View details:"
echo "   kubectl describe pod <pod-name>"
echo "   kubectl logs <pod-name>"
