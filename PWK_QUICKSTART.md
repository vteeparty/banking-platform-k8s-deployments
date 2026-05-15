# 🎮 Play with Kubernetes - 3 Easy Steps

## 🌐 Step 1: Open Play with Kubernetes

1. Go to: **https://labs.play-with-k8s.com/**
2. Login with Docker Hub account (or create one at hub.docker.com)
3. Click **"Start"** to begin your 4-hour session
4. Click **"+ ADD NEW INSTANCE"** to create a node

---

## ⚡ Step 2: Initialize Cluster

Copy and paste this into the PWK terminal:

```bash
# Initialize the cluster
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

# Configure kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install network plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# Wait for node to be ready (takes 30-60 seconds)
kubectl get nodes
```

**Wait until** you see `STATUS: Ready` before proceeding!

---

## 🚀 Step 3: Deploy Banking Platform

### Option A: Super Fast (Recommended)

Open **`QUICK_REFERENCE.md`** file and copy the entire **ONE-COMMAND DEPLOYMENT** section, then paste into PWK terminal.

### Option B: Detailed Script

Open **`deploy-to-play-with-k8s.sh`** file, copy everything, paste into PWK terminal.

---

## ✅ Verify Deployment

```bash
# Check all resources
kubectl get all -n banking-platform

# Should see:
# - 3 Deployments (payment, transaction, notification)
# - 3 Pods (all Running)
# - 3 Services (all ClusterIP)
```

---

## 🎉 Success!

Your banking platform is now running on Kubernetes!

### What was deployed:
- ✅ Namespace: `banking-platform`
- ✅ ConfigMap: Application configuration
- ✅ Secret: Database credentials
- ✅ Payment Service (Port 8081)
- ✅ Transaction Service (Port 8082)
- ✅ Notification Service (Port 8083)

---

## 📚 Next Steps

- **View logs:** `kubectl logs -n banking-platform -l app=payment-service`
- **Get pod details:** `kubectl describe pods -n banking-platform`
- **Shell into pod:** `kubectl exec -it <pod-name> -n banking-platform -- sh`
- **Delete all:** `kubectl delete namespace banking-platform`

---

## 📖 More Information

- **Detailed Guide:** See `PLAY_WITH_K8S_GUIDE.md`
- **All Commands:** See `QUICK_REFERENCE.md`
- **Original Files:** Check `namespaces/` and `manifests/` folders

---

## ⏰ Important Notes

- Session expires after **4 hours**
- All data is **temporary**
- Using **nginx:alpine** as demo images
- Replace with your actual microservice images when ready

---

## 🆘 Troubleshooting

**Pods not running?**
```bash
kubectl describe pod <pod-name> -n banking-platform
kubectl logs <pod-name> -n banking-platform
```

**Need to restart?**
```bash
kubectl delete namespace banking-platform
# Then redeploy using Step 3
```

---

## 🎯 Quick Access

| File | Purpose |
|------|---------|
| `QUICK_REFERENCE.md` | Copy-paste commands |
| `deploy-to-play-with-k8s.sh` | Full deployment script |
| `PLAY_WITH_K8S_GUIDE.md` | Detailed instructions |
| This file | Quick start guide |

**Ready? Let's go! 🚀**
