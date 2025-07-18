@echo off
title HMS System
cls

echo.
echo ================================
echo    HMS System Quick Start
echo ================================
echo.

if not exist "pom.xml" (
    echo ERROR: Run this in HMS project folder
    pause
    exit
)

echo Killing existing processes...
taskkill /f /im java.exe /fi "WINDOWTITLE eq *tomcat*" >nul 2>&1

echo.
echo Starting HMS...
echo URL: http://localhost:8080/hms
echo Login: admin / admin123
echo.

mvn tomcat7:run

pause
