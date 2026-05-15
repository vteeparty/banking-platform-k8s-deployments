# Banking Platform Kubernetes Configuration

## Overview

This directory contains the core Kubernetes configuration for the banking microservices platform, including namespace, ConfigMaps, and Secrets.

## Files

- **namespace.yaml** - Defines the `banking-platform` namespace
- **configmap.yaml** - Application configuration (non-sensitive data)
- **secret.yaml** - Sensitive credentials (base64 encoded)

## Quick Start

### 1. Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

### 2. Apply ConfigMap and Secrets

```bash
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
```

### 3. Verify Resources

```bash
# Check namespace
kubectl get namespace banking-platform

# Check ConfigMap
kubectl get configmap -n banking-platform

# Check Secret
kubectl get secret -n banking-platform
```

## Deployment Order

Deploy resources in this order:

1. **Namespace** (`namespace.yaml`)
2. **ConfigMap** (`configmap.yaml`)
3. **Secret** (`secret.yaml`)
4. **Services** (from `manifests/*/service.yaml`)
5. **Deployments** (from `manifests/*/deployment.yaml`)

### Full Deployment Command

```bash
# Apply all resources at once
kubectl apply -f namespaces/
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/
```

## Configuration Details

### ConfigMap (banking-app-config)

Contains non-sensitive application configuration:
- Database host, port, and database name
- Service ports and log levels
- Inter-service communication URLs
- Application environment settings

### Secret (banking-app-secret)

Contains sensitive credentials (base64 encoded):
- `DB_USERNAME` - Database username
- `DB_PASSWORD` - Database password
- `API_KEY` - API key for external services
- `JWT_SECRET` - JWT signing secret

**⚠️ Important:** Update these placeholder values before deploying to production!

### Updating Secrets

To create a new secret value:

```bash
# Encode a value
echo -n "your-secret-value" | base64

# Decode a value (for verification)
echo "base64-encoded-value" | base64 -d
```

On Windows PowerShell:

```powershell
# Encode
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("your-secret-value"))

# Decode
[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("base64-encoded-value"))
```

## Viewing Configuration

### View ConfigMap Data

```bash
kubectl get configmap banking-app-config -n banking-platform -o yaml
```

### View Secret Data (decoded)

```bash
# View all secrets decoded
kubectl get secret banking-app-secret -n banking-platform -o jsonpath='{.data}' | jq 'map_values(@base64d)'

# View specific secret
kubectl get secret banking-app-secret -n banking-platform -o jsonpath='{.data.DB_USERNAME}' | base64 -d
```

## Updating Configuration

### Update ConfigMap

1. Edit `configmap.yaml`
2. Apply changes:
   ```bash
   kubectl apply -f configmap.yaml
   ```
3. Restart pods to pick up changes:
   ```bash
   kubectl rollout restart deployment -n banking-platform
   ```

### Update Secret

1. Edit `secret.yaml` with new base64 encoded values
2. Apply changes:
   ```bash
   kubectl apply -f secret.yaml
   ```
3. Restart pods:
   ```bash
   kubectl rollout restart deployment -n banking-platform
   ```

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods -n banking-platform
```

### View Pod Logs

```bash
# Payment service logs
kubectl logs -n banking-platform -l app=payment-service

# Transaction service logs
kubectl logs -n banking-platform -l app=transaction-service

# Notification service logs
kubectl logs -n banking-platform -l app=notification-service
```

### Describe Resources

```bash
# Describe deployment
kubectl describe deployment payment-service -n banking-platform

# Describe pod
kubectl describe pod <pod-name> -n banking-platform
```

### Check Environment Variables in Pod

```bash
# List all environment variables
kubectl exec -n banking-platform <pod-name> -- env

# Check specific variable
kubectl exec -n banking-platform <pod-name> -- printenv DB_HOST
```

## Cleanup

To remove all resources:

```bash
# Delete all resources in namespace
kubectl delete namespace banking-platform
```

Or delete individual components:

```bash
kubectl delete -f manifests/notification-service/
kubectl delete -f manifests/transaction-service/
kubectl delete -f manifests/payment-service/
kubectl delete -f namespaces/
```

## Security Best Practices

1. **Never commit real secrets to version control**
2. **Rotate secrets regularly**
3. **Use strong passwords and keys in production**
4. **Consider using sealed secrets or external secret management (e.g., HashiCorp Vault)**
5. **Limit access to the banking-platform namespace using RBAC**
6. **Enable pod security policies**

## Next Steps

- Deploy the ingress controller for external access
- Set up monitoring and logging
- Configure resource limits and requests
- Implement horizontal pod autoscaling
- Set up network policies for service isolation
