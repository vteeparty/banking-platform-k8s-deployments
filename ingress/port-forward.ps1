# Port Forwarding - Test Services Without Ingress
# No admin privileges required - works with any Kubernetes cluster

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Banking Platform - Port Forward Setup" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Check if kubectl is available
Write-Host "`nChecking kubectl connection..." -ForegroundColor Yellow
$clusterInfo = kubectl cluster-info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "No Kubernetes cluster found." -ForegroundColor Red
    Write-Host "`nOptions:" -ForegroundColor Yellow
    Write-Host "1. Use Play with Kubernetes (https://labs.play-with-k8s.com/)" -ForegroundColor White
    Write-Host "2. Use Google Cloud Shell (https://console.cloud.google.com/)" -ForegroundColor White
    Write-Host "3. See ALTERNATIVE_DEPLOYMENT.md for more options" -ForegroundColor White
    exit 1
}

Write-Host "Connected to cluster!" -ForegroundColor Green

# Apply deployments
Write-Host "`nDeploying services..." -ForegroundColor Yellow
kubectl apply -f manifests/payment-service/
kubectl apply -f manifests/transaction-service/
kubectl apply -f manifests/notification-service/

# Wait for pods to be ready
Write-Host "`nWaiting for pods to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=payment-service --timeout=60s
kubectl wait --for=condition=ready pod -l app=transaction-service --timeout=60s
kubectl wait --for=condition=ready pod -l app=notification-service --timeout=60s

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "Services deployed! Starting port forwarding..." -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan

Write-Host "`nAccess services at:" -ForegroundColor Yellow
Write-Host "  Payment Service:      http://localhost:8081" -ForegroundColor Green
Write-Host "  Transaction Service:  http://localhost:8082" -ForegroundColor Green
Write-Host "  Notification Service: http://localhost:8083" -ForegroundColor Green

Write-Host "`nPress Ctrl+C to stop all port forwards" -ForegroundColor Yellow
Write-Host "================================================`n" -ForegroundColor Cyan

# Start port forwarding (this will run in foreground)
$jobs = @()
$jobs += Start-Job -ScriptBlock { kubectl port-forward svc/payment-service 8081:8081 }
$jobs += Start-Job -ScriptBlock { kubectl port-forward svc/transaction-service 8082:8082 }
$jobs += Start-Job -ScriptBlock { kubectl port-forward svc/notification-service 8083:8083 }

try {
    Write-Host "Port forwarding active. Test with:" -ForegroundColor Cyan
    Write-Host "  curl http://localhost:8081" -ForegroundColor White
    Write-Host "  curl http://localhost:8082" -ForegroundColor White
    Write-Host "  curl http://localhost:8083`n" -ForegroundColor White
    
    # Keep running until Ctrl+C
    while ($true) {
        Start-Sleep -Seconds 1
        
        # Check if any job failed
        foreach ($job in $jobs) {
            if ($job.State -eq 'Failed') {
                Write-Host "Port forwarding failed. Restarting..." -ForegroundColor Red
                exit 1
            }
        }
    }
}
finally {
    Write-Host "`nStopping port forwards..." -ForegroundColor Yellow
    $jobs | Stop-Job
    $jobs | Remove-Job
    Write-Host "Stopped." -ForegroundColor Green
}
