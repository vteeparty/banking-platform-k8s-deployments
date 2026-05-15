# 🏦 Banking Platform - Kubernetes Deployments

Complete Kubernetes deployment configuration for a microservices-based banking platform.

## 📋 Table of Contents

- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Deployment Options](#deployment-options)
- [Project Structure](#project-structure)
- [Services](#services)
- [Configuration](#configuration)

---

## 🏗️ Architecture

This banking platform consists of three microservices deployed in Kubernetes:

```
banking-platform namespace
├── Payment Service (Port 8081)
├── Transaction Service (Port 8082)
└── Notification Service (Port 8083)
```

All services share:
- **ConfigMap**: Application configuration
- **Secret**: Database credentials and API keys
- **Namespace**: `banking-platform` (isolated environment)

---

## 🚀 Quick Start

### Option 1: Play with Kubernetes (No Installation Required) ⭐

**Perfect for learning and testing!**

1. Go to: **https://labs.play-with-k8s.com/**
2. Follow the guide: **[PWK_QUICKSTART.md](PWK_QUICKSTART.md)**
3. Copy and paste the deployment script
4. Done! 🎉

**📖 Detailed guides:**
- [PWK_QUICKSTART.md](PWK_QUICKSTART.md) - 3-step quick start
- [PLAY_WITH_K8S_GUIDE.md](PLAY_WITH_K8S_GUIDE.md) - Complete PWK guide
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Command cheat sheet

### Option 2: Local Kubernetes Cluster

**Prerequisites:**
- Docker Desktop with Kubernetes enabled, OR
- Minikube, OR
- K3s/K3d

**Deploy:**
```bash
# 1. Create namespace and configs
kubectl apply -f namespaces/

# 2. Deploy services
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/

# 3. Verify
kubectl get all -n banking-platform
```

### Option 3: Production Cluster

**Using Helm Charts:**
```bash
# Deploy with Helm
helm install payment-service ./helm/payment-service
helm install transaction-service ./helm/transaction-service
helm install notification-service ./helm/notification-service
```

See [helm/DEPLOYMENT_GUIDE.md](helm/DEPLOYMENT_GUIDE.md) for details.

---

## 📂 Project Structure

```
banking-platform-k8s-deployments/
│
├── namespaces/               # Namespace, ConfigMap, Secret
│   ├── namespace.yaml        # banking-platform namespace
│   ├── configmap.yaml        # Application configuration
│   ├── secret.yaml           # Sensitive credentials (base64)
│   └── README.md             # Configuration guide
│
├── manifests/                # Kubernetes manifests
│   ├── payment-service/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── transaction-service/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── notification-service/
│       ├── deployment.yaml
│       └── service.yaml
│
├── helm/                     # Helm charts
│   ├── payment-service/
│   ├── transaction-service/
│   └── notification-service/
│
├── ingress/                  # Ingress configurations
│   └── ingress.yaml          # External access routing
│
├── docs/                     # Documentation
│
├── deploy-to-play-with-k8s.sh    # PWK deployment script
├── PWK_QUICKSTART.md              # Quick start guide
├── PLAY_WITH_K8S_GUIDE.md         # Detailed PWK guide
└── QUICK_REFERENCE.md             # Command reference

```

---

## 🔧 Services

### Payment Service
- **Port:** 8081
- **Purpose:** Handle payment transactions
- **Endpoint:** `http://payment-service:8081`

### Transaction Service
- **Port:** 8082
- **Purpose:** Process banking transactions
- **Endpoint:** `http://transaction-service:8082`

### Notification Service
- **Port:** 8083
- **Purpose:** Send notifications to users
- **Endpoint:** `http://notification-service:8083`

---

## ⚙️ Configuration

### ConfigMap (banking-app-config)

Non-sensitive application settings:
- Database connection details
- Service ports and URLs
- Log levels
- Application environment

**View:**
```bash
kubectl get configmap banking-app-config -n banking-platform -o yaml
```

### Secret (banking-app-secret)

Sensitive credentials (base64 encoded):
- Database username and password
- API keys
- JWT secrets

**⚠️ Important:** Update these before production deployment!

**View (decoded):**
```bash
kubectl get secret banking-app-secret -n banking-platform -o jsonpath='{.data.DB_USERNAME}' | base64 -d
```

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [PWK_QUICKSTART.md](PWK_QUICKSTART.md) | Quick start for Play with Kubernetes |
| [PLAY_WITH_K8S_GUIDE.md](PLAY_WITH_K8S_GUIDE.md) | Complete PWK deployment guide |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Command cheat sheet |
| [namespaces/README.md](namespaces/README.md) | Configuration details |
| [helm/DEPLOYMENT_GUIDE.md](helm/DEPLOYMENT_GUIDE.md) | Helm deployment guide |
| [ingress/README.md](ingress/README.md) | Ingress setup guide |

---

## 🔍 Common Commands

### View Resources
```bash
# All resources
kubectl get all -n banking-platform

# Pods only
kubectl get pods -n banking-platform

# Services
kubectl get svc -n banking-platform
```

### View Logs
```bash
# Payment service logs
kubectl logs -n banking-platform -l app=payment-service

# Follow logs
kubectl logs -n banking-platform -l app=payment-service -f
```

### Troubleshooting
```bash
# Describe pod
kubectl describe pod <pod-name> -n banking-platform

# Get events
kubectl get events -n banking-platform --sort-by='.lastTimestamp'

# Shell into pod
kubectl exec -it <pod-name> -n banking-platform -- sh
```

### Cleanup
```bash
# Delete everything
kubectl delete namespace banking-platform
```

---

## 🛡️ Security Best Practices

1. **Secrets Management**
   - Never commit real secrets to Git
   - Use external secret managers (Vault, AWS Secrets Manager)
   - Rotate credentials regularly

2. **Network Security**
   - Implement NetworkPolicies
   - Use service mesh (Istio, Linkerd)
   - Enable pod security policies

3. **Access Control**
   - Configure RBAC
   - Limit namespace access
   - Use separate namespaces for dev/staging/prod

4. **Image Security**
   - Scan images for vulnerabilities
   - Use specific image tags (not `latest`)
   - Pull from trusted registries

---

## 🚀 Deployment Options Comparison

| Option | Best For | Setup Time | Requirements |
|--------|----------|------------|--------------|
| **Play with K8s** | Learning, Testing | 5 min | Browser, Docker Hub account |
| **Local Cluster** | Development | 10 min | Docker Desktop / Minikube |
| **Cloud Cluster** | Production | 30 min | Cloud account, kubectl |
| **Helm** | Production | 15 min | Helm installed |

---

## 📊 Monitoring & Logging

### Basic Monitoring
```bash
# Pod resource usage
kubectl top pods -n banking-platform

# Node resource usage
kubectl top nodes
```

### Recommended Tools
- **Prometheus + Grafana**: Metrics and dashboards
- **ELK Stack**: Centralized logging
- **Jaeger**: Distributed tracing

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test deployments
5. Submit a pull request

---

## 📝 License

This project is licensed under the MIT License.

---

## 🆘 Support

- **Issues**: Open an issue on GitHub
- **Documentation**: Check the [docs/](docs/) folder
- **Quick Help**: See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

---

## 🎯 Next Steps

1. ✅ Deploy to Play with Kubernetes ([PWK_QUICKSTART.md](PWK_QUICKSTART.md))
2. 📊 Set up monitoring and logging
3. 🔒 Configure ingress for external access
4. 🚀 Deploy to production cluster
5. 🔄 Set up CI/CD pipeline

---

**Ready to deploy? Start with [PWK_QUICKSTART.md](PWK_QUICKSTART.md)! 🚀**