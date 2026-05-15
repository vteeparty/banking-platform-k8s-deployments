# 🎮 Play with Kubernetes - Deployment Guide

## 🌐 Access Play with Kubernetes

1. **Go to:** https://labs.play-with-k8s.com/
2. **Login** with your Docker Hub account (create one if needed at hub.docker.com)
3. **Click** "Start" to begin a new session (4 hours)

## 🚀 Quick Deployment Steps

### Step 1: Initialize the Cluster

In the PWK terminal, run these commands to set up the cluster:

```bash
# Initialize the master node (only on node1)
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

# Configure kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a network plugin (Weave)
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

Wait for the node to be ready (check with `kubectl get nodes`).

### Step 2: Deploy Banking Platform

**Option A: Copy-Paste the Script**

1. Open the file: `deploy-to-play-with-k8s.sh`
2. Copy the entire contents
3. Paste into the PWK terminal
4. Press Enter

**Option B: Download from GitHub (if repo is public)**

```bash
# Clone your repository
git clone <your-repo-url>
cd banking-platform-k8s-deployments

# Make script executable
chmod +x deploy-to-play-with-k8s.sh

# Run the script
./deploy-to-play-with-k8s.sh
```

**Option C: Manual YAML Application**

```bash
# Create namespace
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: banking-platform
EOF

# Then copy and paste each YAML file content
```

## ✅ Verify Deployment

After deployment completes, verify everything is running:

```bash
# Check all resources
kubectl get all -n banking-platform

# Check pods are running
kubectl get pods -n banking-platform

# Check services
kubectl get svc -n banking-platform

# Describe a pod
kubectl describe pod <pod-name> -n banking-platform

# View logs
kubectl logs -n banking-platform -l app=payment-service
```

## 🔍 Testing Services

### Check Environment Variables

```bash
# Get pod name
POD_NAME=$(kubectl get pods -n banking-platform -l app=payment-service -o jsonpath='{.items[0].metadata.name}')

# View all environment variables
kubectl exec -n banking-platform $POD_NAME -- env

# Check specific variables
kubectl exec -n banking-platform $POD_NAME -- printenv | grep DB_
```

### Access Services (Port Forward)

```bash
# Forward payment service to local port
kubectl port-forward -n banking-platform svc/payment-service 8081:8081

# In another terminal or browser, access:
# http://localhost:8081
```

### Test Service Communication

```bash
# Create a test pod
kubectl run test-pod -n banking-platform --image=busybox:latest --rm -it --restart=Never -- sh

# Inside the pod, test connectivity
wget -qO- http://payment-service:8081
wget -qO- http://transaction-service:8082
wget -qO- http://notification-service:8083
```

## 📊 Monitoring Commands

```bash
# Watch pod status in real-time
kubectl get pods -n banking-platform -w

# View events
kubectl get events -n banking-platform --sort-by='.lastTimestamp'

# Top nodes (resource usage)
kubectl top nodes

# Top pods
kubectl top pods -n banking-platform
```

## 🔧 Troubleshooting

### Pods Not Starting

```bash
# Describe the pod to see events
kubectl describe pod <pod-name> -n banking-platform

# Check logs
kubectl logs -n banking-platform <pod-name>

# Check previous logs if pod restarted
kubectl logs -n banking-platform <pod-name> --previous
```

### ConfigMap/Secret Issues

```bash
# View ConfigMap
kubectl get configmap banking-app-config -n banking-platform -o yaml

# View Secret (decoded)
kubectl get secret banking-app-secret -n banking-platform -o json | jq '.data | map_values(@base64d)'
```

### Network Issues

```bash
# Check services
kubectl get svc -n banking-platform

# Check endpoints
kubectl get endpoints -n banking-platform

# Test DNS resolution
kubectl run -it --rm debug --image=busybox --restart=Never -n banking-platform -- nslookup payment-service
```

## 🧹 Cleanup

### Delete All Resources

```bash
# Delete entire namespace (removes everything)
kubectl delete namespace banking-platform
```

### Delete Individual Components

```bash
# Delete deployments
kubectl delete deployment payment-service -n banking-platform
kubectl delete deployment transaction-service -n banking-platform
kubectl delete deployment notification-service -n banking-platform

# Delete services
kubectl delete svc payment-service -n banking-platform
kubectl delete svc transaction-service -n banking-platform
kubectl delete svc notification-service -n banking-platform

# Delete configs
kubectl delete configmap banking-app-config -n banking-platform
kubectl delete secret banking-app-secret -n banking-platform

# Finally delete namespace
kubectl delete namespace banking-platform
```

## 📝 Important Notes

### Session Limitations

- **Duration:** 4 hours maximum
- **Resources:** Limited CPU/Memory
- **Persistence:** Data is lost when session ends
- **Networking:** Limited external access

### Image Availability

The deployment script uses `nginx:alpine` as placeholder images since Play with Kubernetes can pull public images easily. When you have your actual microservice images:

1. Push them to Docker Hub or a public registry
2. Update the `image:` field in each deployment
3. Redeploy

### Best Practices for PWK

1. **Save your work:** Copy important logs or outputs before session expires
2. **Use simple images:** Public images from Docker Hub work best
3. **Monitor resources:** Check `kubectl top nodes` to avoid overload
4. **Test incrementally:** Deploy one service at a time if you encounter issues

## 🎯 Quick Reference

| Command | Description |
|---------|-------------|
| `kubectl get all -n banking-platform` | View all resources |
| `kubectl get pods -n banking-platform` | List pods |
| `kubectl logs -n banking-platform <pod>` | View pod logs |
| `kubectl describe pod <pod> -n banking-platform` | Pod details |
| `kubectl exec -it <pod> -n banking-platform -- sh` | Shell into pod |
| `kubectl delete namespace banking-platform` | Delete everything |

## 🆘 Need Help?

If you encounter issues:
1. Check pod status: `kubectl get pods -n banking-platform`
2. View pod events: `kubectl describe pod <pod-name> -n banking-platform`
3. Check logs: `kubectl logs -n banking-platform <pod-name>`
4. Restart deployment: `kubectl rollout restart deployment <name> -n banking-platform`

## 🎉 Success!

Once all pods show `Running` status, your banking platform is deployed and ready for testing!
