#!/bin/bash
# Banking Platform - Play with Kubernetes Deployment Script
# Copy and paste this entire script into Play with Kubernetes terminal

echo "🚀 Deploying Banking Platform to Kubernetes..."
echo ""

# ====================================
# 1. Create Namespace
# ====================================
echo "📦 Creating namespace..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: banking-platform
  labels:
    name: banking-platform
    environment: development
EOF

echo "✅ Namespace created"
echo ""

# ====================================
# 2. Create ConfigMap
# ====================================
echo "⚙️  Creating ConfigMap..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: banking-app-config
  namespace: banking-platform
data:
  # Database Configuration
  DB_HOST: "postgres-service"
  DB_PORT: "5432"
  DB_NAME: "banking_db"
  
  # Payment Service Configuration
  PAYMENT_SERVICE_PORT: "8081"
  PAYMENT_SERVICE_LOG_LEVEL: "info"
  
  # Transaction Service Configuration
  TRANSACTION_SERVICE_PORT: "8082"
  TRANSACTION_SERVICE_LOG_LEVEL: "info"
  
  # Notification Service Configuration
  NOTIFICATION_SERVICE_PORT: "8083"
  NOTIFICATION_SERVICE_LOG_LEVEL: "info"
  
  # Service URLs (for inter-service communication)
  PAYMENT_SERVICE_URL: "http://payment-service:8081"
  TRANSACTION_SERVICE_URL: "http://transaction-service:8082"
  NOTIFICATION_SERVICE_URL: "http://notification-service:8083"
  
  # Application Settings
  APP_ENVIRONMENT: "development"
  APP_TIMEZONE: "UTC"
EOF

echo "✅ ConfigMap created"
echo ""

# ====================================
# 3. Create Secret
# ====================================
echo "🔒 Creating Secret..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: banking-app-secret
  namespace: banking-platform
type: Opaque
data:
  # Database Credentials (base64 encoded)
  # Default username: "dbuser"
  DB_USERNAME: ZGJ1c2Vy
  # Default password: "change-me-in-production"
  DB_PASSWORD: Y2hhbmdlLW1lLWluLXByb2R1Y3Rpb24=
  # API Key placeholder: "your-api-key-here"
  API_KEY: eW91ci1hcGkta2V5LWhlcmU=
  # JWT Secret placeholder: "your-jwt-secret-key"
  JWT_SECRET: eW91ci1qd3Qtc2VjcmV0LWtleQ==
EOF

echo "✅ Secret created"
echo ""

# ====================================
# 4. Deploy Payment Service
# ====================================
echo "💳 Deploying Payment Service..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
  namespace: banking-platform
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
          image: nginx:alpine
          ports:
            - containerPort: 8081
          env:
            - name: DB_HOST
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_HOST
            - name: DB_PORT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_PORT
            - name: DB_NAME
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_NAME
            - name: PAYMENT_SERVICE_PORT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: PAYMENT_SERVICE_PORT
            - name: APP_ENVIRONMENT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: APP_ENVIRONMENT
            - name: DB_USERNAME
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: DB_USERNAME
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: DB_PASSWORD
            - name: API_KEY
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: API_KEY
---
apiVersion: v1
kind: Service
metadata:
  name: payment-service
  namespace: banking-platform
  labels:
    app: payment-service
spec:
  type: ClusterIP
  selector:
    app: payment-service
  ports:
    - port: 8081
      targetPort: 80
EOF

echo "✅ Payment Service deployed"
echo ""

# ====================================
# 5. Deploy Transaction Service
# ====================================
echo "💰 Deploying Transaction Service..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: transaction-service
  namespace: banking-platform
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
          image: nginx:alpine
          ports:
            - containerPort: 8082
          env:
            - name: DB_HOST
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_HOST
            - name: DB_PORT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_PORT
            - name: DB_NAME
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_NAME
            - name: TRANSACTION_SERVICE_PORT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: TRANSACTION_SERVICE_PORT
            - name: APP_ENVIRONMENT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: APP_ENVIRONMENT
            - name: DB_USERNAME
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: DB_USERNAME
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: DB_PASSWORD
            - name: API_KEY
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: API_KEY
---
apiVersion: v1
kind: Service
metadata:
  name: transaction-service
  namespace: banking-platform
  labels:
    app: transaction-service
spec:
  type: ClusterIP
  selector:
    app: transaction-service
  ports:
    - port: 8082
      targetPort: 80
EOF

echo "✅ Transaction Service deployed"
echo ""

# ====================================
# 6. Deploy Notification Service
# ====================================
echo "🔔 Deploying Notification Service..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: notification-service
  namespace: banking-platform
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
          image: nginx:alpine
          ports:
            - containerPort: 8083
          env:
            - name: DB_HOST
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_HOST
            - name: DB_PORT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_PORT
            - name: DB_NAME
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: DB_NAME
            - name: NOTIFICATION_SERVICE_PORT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: NOTIFICATION_SERVICE_PORT
            - name: APP_ENVIRONMENT
              valueFrom:
                configMapKeyRef:
                  name: banking-app-config
                  key: APP_ENVIRONMENT
            - name: DB_USERNAME
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: DB_USERNAME
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: DB_PASSWORD
            - name: API_KEY
              valueFrom:
                secretKeyRef:
                  name: banking-app-secret
                  key: API_KEY
---
apiVersion: v1
kind: Service
metadata:
  name: notification-service
  namespace: banking-platform
  labels:
    app: notification-service
spec:
  type: ClusterIP
  selector:
    app: notification-service
  ports:
    - port: 8083
      targetPort: 80
EOF

echo "✅ Notification Service deployed"
echo ""

# ====================================
# 7. Verify Deployment
# ====================================
echo "🔍 Verifying deployment..."
echo ""
echo "Namespace:"
kubectl get namespace banking-platform
echo ""
echo "ConfigMaps:"
kubectl get configmap -n banking-platform
echo ""
echo "Secrets:"
kubectl get secret -n banking-platform
echo ""
echo "Deployments:"
kubectl get deployments -n banking-platform
echo ""
echo "Pods:"
kubectl get pods -n banking-platform
echo ""
echo "Services:"
kubectl get services -n banking-platform
echo ""

# ====================================
# Wait for pods to be ready
# ====================================
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=payment-service -n banking-platform --timeout=60s
kubectl wait --for=condition=ready pod -l app=transaction-service -n banking-platform --timeout=60s
kubectl wait --for=condition=ready pod -l app=notification-service -n banking-platform --timeout=60s

echo ""
echo "✅ All resources deployed successfully!"
echo ""
echo "📊 Summary:"
kubectl get all -n banking-platform
echo ""
echo "🎉 Banking Platform is ready!"
echo ""
echo "💡 Useful commands:"
echo "   View pods:        kubectl get pods -n banking-platform"
echo "   View services:    kubectl get svc -n banking-platform"
echo "   View logs:        kubectl logs -n banking-platform -l app=payment-service"
echo "   Describe pod:     kubectl describe pod <pod-name> -n banking-platform"
echo "   Delete all:       kubectl delete namespace banking-platform"
