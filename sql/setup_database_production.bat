@echo off
chcp 65001 >nul
title Homestay Database Setup - Production Environment (Root Password: root)

echo ========================================
echo  Homestay Management System Database
echo  Production Environment Setup
echo  MySQL Root Password: root
echo ========================================
echo.

:: Check if MySQL is installed
mysql --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MySQL is not installed or not in PATH
    echo Please install MySQL 8.0+ and add it to system PATH
    pause
    exit /b 1
)

echo [INFO] MySQL detected, starting database setup...
echo.

:: Check if homestay_db.sql exists
if not exist "homestay_db.sql" (
    echo [ERROR] homestay_db.sql file not found in current directory
    echo Please make sure homestay_db.sql is in the same folder as this script
    pause
    exit /b 1
)

:: Create database first
echo [INFO] Creating database homestay_db...
echo DROP DATABASE IF EXISTS homestay_db; > temp_create_db.sql
echo CREATE DATABASE homestay_db DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci; >> temp_create_db.sql
echo USE homestay_db; >> temp_create_db.sql

mysql -u root -proot < temp_create_db.sql
if errorlevel 1 (
    echo [ERROR] Failed to create database. Please check:
    echo 1. MySQL service is running
    echo 2. Root password is correct ^(should be: root^)
    echo 3. MySQL user has sufficient privileges
    del temp_create_db.sql >nul 2>&1
    pause
    exit /b 1
)

echo [INFO] Database created successfully!
echo [INFO] Importing table structures and data...

:: Import the main SQL file
mysql -u root -proot homestay_db < homestay_db.sql
if errorlevel 1 (
    echo [ERROR] Failed to import data. Please check the SQL file format
    del temp_create_db.sql >nul 2>&1
    pause
    exit /b 1
)

:: Clean up
del temp_create_db.sql >nul 2>&1

echo.
echo [SUCCESS] Database 'homestay_db' setup completed successfully!
echo.
echo Database Information:
echo - Database Name: homestay_db
echo - Character Set: utf8mb4
echo - Collation: utf8mb4_unicode_ci
echo - MySQL Root Password: root
echo.
echo Default Admin Account:
echo - Username: admin
echo - Password: 123456
echo - Email: admin@hms.com
echo.
echo Tables Created:
echo - user ^(users table^)
echo - room ^(rooms table^)
echo - room_image ^(room images table^)
echo - orders ^(orders table^)
echo.
echo [INFO] You can now start your homestay management application!
echo.
pause
