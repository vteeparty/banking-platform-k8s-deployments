# Deploy to Kubernetes Playground

## Steps:

1. **Open Play with Kubernetes** (already opened in your browser)
   - Go to https://labs.play-with-k8s.com/
   - Click "Login" with Docker Hub or GitHub account
   - Click "+ ADD NEW INSTANCE" to create a node

2. **Initialize the cluster** (in the terminal that appears):
   ```bash
   kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
   kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
   ```

3. **Copy the deployment script content** from [deploy-to-playground.sh](../deploy-to-playground.sh)

4. **Paste and run in the playground terminal**:
   ```bash
   # Paste the entire script content, then press Enter
   ```

   OR create the file and run it:
   ```bash
   cat > deploy.sh << 'ENDOFFILE'
   [paste the script content here]
   ENDOFFILE
   
   chmod +x deploy.sh
   ./deploy.sh
   ```

5. **Verify deployment**:
   ```bash
   kubectl get pods
   kubectl get services
   ```

## Alternative: Deploy Manifests Directly

You can also deploy using the manifest files:

```bash
# Copy each manifest content and apply
kubectl apply -f - << 'EOF'
[paste deployment.yaml content]
EOF
```

---

## Note on Images

The deployment uses:
- `payment-service:latest`
- `transaction-service:latest`
- `notification-service:latest`

**If these images don't exist**, the pods will show `ImagePullBackOff` error. This is expected in a playground environment without actual Docker images.

To simulate working services, you can change the images to public ones like `nginx:alpine` for testing purposes.

---

## Quick Test with nginx

To test the deployment structure works:

```bash
kubectl set image deployment/payment-service payment-service=nginx:alpine
kubectl set image deployment/transaction-service transaction-service=nginx:alpine
kubectl set image deployment/notification-service notification-service=nginx:alpine
```

This will make the pods run successfully with nginx as a placeholder.
