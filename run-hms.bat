@echo off
title HMS System - Quick Start
color 0A

echo.
echo ================================================
echo         HMS Homestay Management System
echo ================================================
echo.

:: Simple check for project files
if not exist "pom.xml" (
    echo ERROR: Please run this script in HMS project directory
    pause
    exit /b 1
)

:: Kill any existing process on port 8080
echo Checking port 8080...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080 2^>nul') do (
    echo Stopping existing process...
    taskkill /f /pid %%a >nul 2>&1
)

echo.
echo Starting HMS system...
echo.
echo Access URL: http://localhost:8080/hms
echo Default login: admin / admin123
echo.
echo Press Ctrl+C to stop the server
echo ================================================
echo.

:: Start the system
mvn tomcat7:run

echo.
echo Server stopped. Press any key to exit...
pause >nul
