$ErrorActionPreference = "SilentlyContinue"

function Wait-For-Url {
    param(
        [string]$Url,
        [int]$TimeoutSeconds = 120
    )

    $end = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $end) {
        try {
            $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500) {
                return $true
            }
        }
        catch {
            Start-Sleep -Seconds 2
        }
    }

    return $false
}

# 1) Clear stale FE/BE processes
Write-Host "Clearing stale Java and Node processes..."
taskkill /F /IM java.exe /T 2>$null
taskkill /F /IM node.exe /T 2>$null
taskkill /F /IM chrome.exe /T 2>$null
taskkill /F /IM msedge.exe /T 2>$null
taskkill /F /IM playwright.exe /T 2>$null

# 2) Start backend
Write-Host "Starting backend..."
$backendPath = "C:\mini-project-temp-main\mini-project-temp-main\WEB\RiceInsuranceDamageReportingSystem\RiceInsuranceDamageReportingSystem\riceclaim"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendPath'; .\mvnw.cmd spring-boot:run"

# 3) Start frontend
Write-Host "Starting frontend..."
$frontendPath = "C:\mini-project-temp-main\mini-project-temp-main\WEB\RiceInsuranceDamageReportingSystem\RiceInsuranceDamageReportingSystem\frontend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; npm run dev"

# 4) Wait until both app servers are up
Write-Host "Waiting for backend and frontend to become ready..."
if (-not (Wait-For-Url -Url "http://localhost:8080" -TimeoutSeconds 120)) {
    Write-Host "Backend did not become ready in time."
    exit 1
}

if (-not (Wait-For-Url -Url "http://localhost:5173/login" -TimeoutSeconds 120)) {
    Write-Host "Frontend did not become ready in time."
    exit 1
}

# 5) Run Robot tests
Write-Host "Running Robot tests..."
cd "C:\RiceClaimTest"
robot --outputdir results Tests\TC01_LoginFarmer.robot
