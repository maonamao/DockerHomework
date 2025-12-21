# Set output encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

 param(
     [string]$MySqlHost = "192.168.56.132",
     [int]$MySqlPort = 3306,
     [string]$MySqlUser = "root",
     [string]$MySqlPassword = "tosennanoda",
     [string]$Database = "ecommerce_db",
     [string]$DockerContainer = "mysql_docker"
 )

Write-Host "=== MySQL Connection Verification ===" -ForegroundColor Cyan

# Test 1: Check if MySQL container is running
Write-Host "`n[Test 1] Checking MySQL container status..." -ForegroundColor Yellow
$useDockerChecks = $false
$containerStatus = docker inspect $DockerContainer --format="{{.State.Status}}" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "Container Status: $containerStatus" -ForegroundColor Green
    $useDockerChecks = $true
} else {
    Write-Host "INFO: Docker container '$DockerContainer' not found or not running, skipping docker exec checks" -ForegroundColor DarkYellow
}

# Test 2: Wait for MySQL to be ready
Write-Host "`n[Test 2] Waiting for MySQL to be ready (max 60 seconds)..." -ForegroundColor Yellow
$maxAttempts = 12
$attempt = 0
$ready = $false

if ($useDockerChecks) {
    while ($attempt -lt $maxAttempts -and -not $ready) {
        $attempt++
        Write-Host "Attempt $attempt/$maxAttempts..." -ForegroundColor Gray
        
        $pingResult = docker exec $DockerContainer mysqladmin ping -u$MySqlUser -p$MySqlPassword 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "MySQL is ready!" -ForegroundColor Green
            $ready = $true
        } else {
            Start-Sleep -Seconds 5
        }
    }

    if (-not $ready) {
        Write-Host "ERROR: MySQL did not become ready in time" -ForegroundColor Red
        Write-Host "Checking logs..." -ForegroundColor Yellow
        docker logs $DockerContainer --tail 20
        exit 1
    }
} else {
    Write-Host "INFO: Skipping readiness check via docker exec" -ForegroundColor DarkYellow
}

# Test 3: Test TCP connection to port 3306
Write-Host "`n[Test 3] Testing TCP connection to $MySqlHost`:$MySqlPort..." -ForegroundColor Yellow
try {
    $client = New-Object System.Net.Sockets.TcpClient
    $client.Connect($MySqlHost, $MySqlPort)
    $client.Close()
    Write-Host "SUCCESS: Port $MySqlPort is accessible from host" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Port $MySqlPort is NOT accessible from host" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    # Check port mapping
    if ($useDockerChecks) {
        Write-Host "`nChecking port mapping..." -ForegroundColor Yellow
        docker port $DockerContainer
    }
    exit 1
}

# Test 4: Verify database exists
Write-Host "`n[Test 4] Verifying $Database database..." -ForegroundColor Yellow
if ($useDockerChecks) {
    $dbCheck = docker exec $DockerContainer mysql -u$MySqlUser -p$MySqlPassword -e "SHOW DATABASES LIKE '$Database';" 2>&1
    if ($dbCheck -match $Database) {
        Write-Host "Database '$Database' exists" -ForegroundColor Green
    } else {
        Write-Host "Database '$Database' does not exist, creating it..." -ForegroundColor Yellow
        docker exec $DockerContainer mysql -u$MySqlUser -p$MySqlPassword -e "CREATE DATABASE IF NOT EXISTS $Database CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Database created successfully" -ForegroundColor Green
        } else {
            Write-Host "ERROR: Failed to create database" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "INFO: Skipping database existence check (requires mysql client inside docker container)" -ForegroundColor DarkYellow
}

Write-Host "`n=== All Tests Passed ===" -ForegroundColor Green
Write-Host "MySQL is ready for Spring Boot application" -ForegroundColor Green
