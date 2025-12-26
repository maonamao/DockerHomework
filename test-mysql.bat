@echo off
chcp 65001 >nul
echo === MySQL Connection Test ===
echo.

echo [1] Checking MySQL container status...
docker ps --filter name=mysql_docker --format "{{.Names}}: {{.Status}}"
echo.

echo [2] Testing MySQL ping...
docker exec mysql_docker mysqladmin ping -uroot -ptosennanoda 2>&1
echo.

echo [3] Checking databases...
docker exec mysql_docker mysql -uroot -ptosennanoda -e "SHOW DATABASES;" 2>&1
echo.

echo [4] Creating ecommerce_db if not exists...
docker exec mysql_docker mysql -uroot -ptosennanoda -e "CREATE DATABASE IF NOT EXISTS ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>&1
echo.

echo [5] Verifying ecommerce_db exists...
docker exec mysql_docker mysql -uroot -ptosennanoda -e "SHOW DATABASES LIKE 'ecommerce_db';" 2>&1
echo.

echo === Test Complete ===
pause
