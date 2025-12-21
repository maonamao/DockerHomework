Write-Host "=== MySQL Connection Test ===" -ForegroundColor Cyan

# Test 1: Check if MySQL container is running
Write-Host "`n1. Checking MySQL container status..." -ForegroundColor Yellow
docker ps --filter name=mysql_docker --format "{{.Names}}: {{.Status}}"

# Test 2: Check port mapping
Write-Host "`n2. Checking port mapping..." -ForegroundColor Yellow
docker port mysql_docker

# Test 3: Test TCP connection to port 3306
Write-Host "`n3. Testing TCP connection to localhost:3306..." -ForegroundColor Yellow
try {
    $client = New-Object System.Net.Sockets.TcpClient
    $client.Connect('127.0.0.1', 3306)
    $client.Close()
    Write-Host "SUCCESS: Port 3306 is accessible" -ForegroundColor Green
} catch {
    Write-Host "FAILED: Port 3306 is NOT accessible" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Test MySQL connection from inside container
Write-Host "`n4. Testing MySQL from inside container..." -ForegroundColor Yellow
docker exec mysql_docker mysqladmin ping -uroot -ptosennanoda 2>&1

# Test 5: Check if database exists
Write-Host "`n5. Checking if ecommerce_db exists..." -ForegroundColor Yellow
docker exec mysql_docker mysql -uroot -ptosennanoda -e "SHOW DATABASES LIKE 'ecommerce_db';" 2>&1

# Test 6: Create database if not exists
Write-Host "`n6. Creating database if not exists..." -ForegroundColor Yellow
docker exec mysql_docker mysql -uroot -ptosennanoda -e "CREATE DATABASE IF NOT EXISTS ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>&1

Write-Host "`n=== Test Complete ===" -ForegroundColor Cyan
