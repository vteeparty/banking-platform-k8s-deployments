# Deploy Ingress for Banking Platform Microservices
# PowerShell script for Windows

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Banking Platform - Ingress Deployment" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Check if Minikube is running
Write-Host "`nChecking Minikube status..." -ForegroundColor Yellow
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Minikube is not running. Starting Minikube..." -ForegroundColor Red
    minikube start
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to start Minikube. Please install Docker Desktop or enable Hyper-V first." -ForegroundColor Red
        exit 1
    }
}

# Enable ingress addon
Write-Host "`nEnabling NGINX Ingress Controller..." -ForegroundColor Yellow
minikube addons enable ingress

# Wait for ingress controller to be ready
Write-Host "Waiting for ingress controller to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Apply the ingress configuration
Write-Host "`nApplying ingress configuration..." -ForegroundColor Yellow
kubectl apply -f ingress/ingress.yaml

# Display ingress status
Write-Host "`nIngress deployed successfully!" -ForegroundColor Green
Write-Host "`nIngress Status:" -ForegroundColor Cyan
kubectl get ingress

# Get Minikube IP
$minikubeIP = minikube ip
Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "Access your services at:" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Minikube IP: $minikubeIP" -ForegroundColor White
Write-Host "`nAdd to C:\Windows\System32\drivers\etc\hosts (as Administrator):" -ForegroundColor Yellow
Write-Host "$minikubeIP banking.local" -ForegroundColor White
Write-Host "`nThen access services:" -ForegroundColor Yellow
Write-Host "  http://banking.local/payment" -ForegroundColor Green
Write-Host "  http://banking.local/transaction" -ForegroundColor Green
Write-Host "  http://banking.local/notification" -ForegroundColor Green
Write-Host "`nOr use IP directly:" -ForegroundColor Yellow
Write-Host "  http://$minikubeIP/payment" -ForegroundColor Green
Write-Host "  http://$minikubeIP/transaction" -ForegroundColor Green
Write-Host "  http://$minikubeIP/notification" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
