@echo off
chcp 65001 >nul
echo ===================================================
echo     DANG KHOI DONG TOAN BO HE THONG ADMIN PORTAL
echo ===================================================
echo 1. Dang mo Backend (Spring Boot - Port 8080)...
start "Backend - Spring Boot (Port 8080)" cmd /k "call "%~dp0run_backend.bat""

echo 2. Dang mo Frontend (React Vite - Port 5173)...
start "Frontend - React Vite (Port 5173)" cmd /k "call "%~dp0run_frontend.bat""

echo ===================================================
echo     KHOI CHAY HOAN TAT! 
echo     Frontend: http://localhost:5173
echo     Backend : http://localhost:8080
echo ===================================================
