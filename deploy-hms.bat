@echo off
chcp 65001 >nul
title HMS Homestay Management System - Deployment Tool
color 0A
setlocal enabledelayedexpansion

:main
cls
echo.
echo ================================================================
echo           HMS Homestay Management System - Deploy Tool
echo ================================================================
echo.
echo  [1] Full Deploy (Database + System)
echo  [2] Deploy Database Only
echo  [3] Start System Only
echo  [4] Check Environment
echo  [5] Clean and Rebuild
echo  [6] Check Port Usage
echo  [7] Open Web Browser
echo  [8] Exit
echo.
set /p choice=Please select an option (1-8): 

if "%choice%"=="1" goto full_deploy
if "%choice%"=="2" goto deploy_db
if "%choice%"=="3" goto start_system
if "%choice%"=="4" goto check_env
if "%choice%"=="5" goto clean_build
if "%choice%"=="6" goto check_port
if "%choice%"=="7" goto open_web
if "%choice%"=="8" goto exit
goto main

:full_deploy
cls
echo.
echo ========================================
echo         Full HMS System Deploy
echo ========================================
echo.

call :check_all_env
if %errorlevel% neq 0 goto main

call :deploy_database
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Database deployment failed, cannot start system
    pause
    goto main
)

call :start_application
goto main

:deploy_db
cls
echo.
echo ========================================
echo         Deploy Database
echo ========================================
echo.

call :check_mysql
if %errorlevel% neq 0 goto main

call :deploy_database
echo.
echo Database deployment completed. Press any key to return...
pause >nul
goto main

:start_system
cls
echo.
echo ========================================
echo         Start HMS System
echo ========================================
echo.

call :check_basic_env
if %errorlevel% neq 0 goto main

call :start_application
goto main

:check_env
cls
echo.
echo ========================================
echo         Check Environment
echo ========================================
echo.

call :check_all_env
echo.
echo Environment check completed. Press any key to return...
pause >nul
goto main

:clean_build
cls
echo.
echo ========================================
echo         Clean and Rebuild
echo ========================================
echo.

echo [1/3] Cleaning project...
mvn clean
echo.

echo [2/3] Downloading dependencies...
mvn dependency:resolve
echo.

echo [3/3] Compiling project...
mvn compile
echo.

if %errorlevel% equ 0 (
    echo [SUCCESS] Build completed successfully!
) else (
    echo [ERROR] Build failed!
)

echo.
echo Build completed. Press any key to return...
pause >nul
goto main

:check_port
cls
echo.
echo ========================================
echo         Check Port Usage
echo ========================================
echo.

echo Checking port 8080 usage:
netstat -ano | findstr :8080
if %errorlevel% neq 0 (
    echo [OK] Port 8080 is available
) else (
    echo.
    echo [WARNING] Port 8080 is in use
    set /p kill_port=Kill the process? (y/n): 
    if /i "!kill_port!"=="y" (
        for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
            echo Killing process %%a...
            taskkill /f /pid %%a >nul 2>&1
        )
        echo [OK] Process killed
    )
)

echo.
echo Check completed. Press any key to return...
pause >nul
goto main

:open_web
echo.
echo Opening HMS system in browser...
start http://localhost:8080/hms
timeout /t 2 >nul
goto main

:check_all_env
call :check_java
if %errorlevel% neq 0 exit /b 1

call :check_maven
if %errorlevel% neq 0 exit /b 1

call :check_project
if %errorlevel% neq 0 exit /b 1

call :check_mysql
if %errorlevel% neq 0 exit /b 1

exit /b 0

:check_basic_env
call :check_java
if %errorlevel% neq 0 exit /b 1

call :check_maven
if %errorlevel% neq 0 exit /b 1

call :check_project
if %errorlevel% neq 0 exit /b 1

exit /b 0

:check_java
echo [CHECK] Java environment...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java not found!
    echo    Please install Java 8 or higher
    echo    Download: https://www.oracle.com/java/technologies/downloads/
    echo.
    pause
    exit /b 1
)
echo [OK] Java environment is ready
exit /b 0

:check_maven
echo [CHECK] Maven environment...
where mvn >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Maven not found!
    echo    Please install Apache Maven
    echo    Download: https://maven.apache.org/download.cgi
    echo.
    pause
    exit /b 1
)
echo [OK] Maven environment is ready
exit /b 0

:check_project
echo [CHECK] Project files...
if not exist "pom.xml" (
    echo [ERROR] pom.xml not found!
    echo    Please run this script in HMS project root directory
    echo.
    pause
    exit /b 1
)
echo [OK] Project files are ready
exit /b 0

:check_mysql
echo [CHECK] MySQL environment...
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] MySQL not found!
    echo    Please install MySQL 8.0 or higher
    echo    Download: https://dev.mysql.com/downloads/mysql/
    echo.
    pause
    exit /b 1
)
echo [OK] MySQL environment is ready
exit /b 0

:deploy_database
echo.
echo ========================================
echo         Auto Deploy Database
echo ========================================
echo.

echo Please enter MySQL database connection info:
echo.
set /p db_host=Database host (default: localhost): 
if "%db_host%"=="" set db_host=localhost

set /p db_port=Database port (default: 3306): 
if "%db_port%"=="" set db_port=3306

set /p db_user=Database username (default: root): 
if "%db_user%"=="" set db_user=root

set /p db_password=Database password: 

echo.
echo [1/4] Testing database connection...
mysql -h%db_host% -P%db_port% -u%db_user% -p%db_password% -e "SELECT 1;" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Database connection failed! Please check connection info
    exit /b 1
)
echo [OK] Database connection successful

echo.
echo [2/4] Creating database...
mysql -h%db_host% -P%db_port% -u%db_user% -p%db_password% -e "CREATE DATABASE IF NOT EXISTS hms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
echo [OK] Database created

echo.
echo [3/4] Importing database schema...
if exist "sql\hms_schema.sql" (
    mysql -h%db_host% -P%db_port% -u%db_user% -p%db_password% hms_db < sql\hms_schema.sql
    echo [OK] Database schema imported
) else (
    echo [WARNING] Schema file sql\hms_schema.sql not found
    echo    Creating basic tables...
    call :create_basic_tables
)

echo.
echo [4/4] Importing initial data...
if exist "sql\hms_data.sql" (
    mysql -h%db_host% -P%db_port% -u%db_user% -p%db_password% hms_db < sql\hms_data.sql
    echo [OK] Initial data imported
) else (
    echo [WARNING] Data file sql\hms_data.sql not found
    echo    Creating basic test data...
    call :create_basic_data
)

echo.
echo [UPDATE] Updating database configuration...
call :update_db_config

echo.
echo [SUCCESS] Database deployment completed!
echo    Database: hms_db
echo    Host: %db_host%:%db_port%
echo    User: %db_user%
exit /b 0

:start_application
echo.
echo Starting HMS system...
echo    Access URL: http://localhost:8080/hms
echo    Default account: admin / admin123
echo    Press Ctrl+C to stop server, then press any key to return
echo.
echo ========================================
echo.

mvn tomcat7:run
echo.
echo Server stopped. Press any key to return to main menu...
pause >nul
exit /b 0

:create_basic_tables
echo Creating basic table structure...
mysql -h%db_host% -P%db_port% -u%db_user% -p%db_password% hms_db -e "
CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    real_name VARCHAR(50),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS room (
    id INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(100) NOT NULL,
    room_type VARCHAR(50),
    description TEXT,
    address VARCHAR(200),
    city VARCHAR(50),
    district VARCHAR(50),
    price_per_night DECIMAL(10,2),
    max_guests INT,
    area DECIMAL(8,2),
    floor INT,
    facilities TEXT,
    check_in_time TIME,
    check_out_time TIME,
    status TINYINT DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS room_image (
    id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT,
    image_url VARCHAR(500),
    is_cover TINYINT DEFAULT 0,
    sort_order INT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    FOREIGN KEY (room_id) REFERENCES room(id)
);

CREATE TABLE IF NOT EXISTS booking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    room_id INT,
    check_in_date DATE,
    check_out_date DATE,
    guests_count INT,
    total_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending',
    contact_name VARCHAR(50),
    contact_phone VARCHAR(20),
    special_requests TEXT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (room_id) REFERENCES room(id)
);"
echo [OK] Basic table structure created
exit /b 0

:create_basic_data
echo Creating basic test data...
mysql -h%db_host% -P%db_port% -u%db_user% -p%db_password% hms_db -e "
INSERT IGNORE INTO user (username, password, email, real_name) VALUES
('admin', 'admin123', 'admin@hms.com', 'System Administrator'),
('test', 'test123', 'test@hms.com', 'Test User');

INSERT IGNORE INTO room (room_name, room_type, description, address, city, district, price_per_night, max_guests, area, floor, facilities, check_in_time, check_out_time) VALUES
('Cozy Single Room', 'Single', 'Comfortable single room for business travelers', 'Beijing Chaoyang District Jianguo Road 1', 'Beijing', 'Chaoyang', 288.00, 1, 25.5, 3, 'AC,WiFi,TV,Private Bath', '14:00:00', '12:00:00'),
('Luxury Double Room', 'Double', 'Spacious double room with full facilities', 'Shanghai Pudong Lujiazui Ring Road 1000', 'Shanghai', 'Pudong', 488.00, 2, 35.0, 5, 'AC,WiFi,TV,Private Bath,Balcony', '14:00:00', '12:00:00'),
('Family Suite', 'Suite', 'Perfect suite for family stay', 'Guangzhou Tianhe Zhujiang New Town 123', 'Guangzhou', 'Tianhe', 688.00, 4, 55.0, 8, 'AC,WiFi,TV,Private Bath,Kitchen,Living Room', '14:00:00', '12:00:00');"
echo [OK] Basic test data created
exit /b 0

:update_db_config
echo Updating database configuration...
if exist "src\main\resources\jdbc.properties" (
    echo # Database Configuration - Auto Generated > src\main\resources\jdbc.properties.new
    echo jdbc.driver=com.mysql.cj.jdbc.Driver >> src\main\resources\jdbc.properties.new
    echo jdbc.url=jdbc:mysql://%db_host%:%db_port%/hms_db?useUnicode=true^&characterEncoding=utf8^&useSSL=false^&serverTimezone=Asia/Shanghai >> src\main\resources\jdbc.properties.new
    echo jdbc.username=%db_user% >> src\main\resources\jdbc.properties.new
    echo jdbc.password=%db_password% >> src\main\resources\jdbc.properties.new
    echo. >> src\main\resources\jdbc.properties.new
    echo # Connection Pool Configuration >> src\main\resources\jdbc.properties.new
    echo jdbc.initialSize=5 >> src\main\resources\jdbc.properties.new
    echo jdbc.maxActive=20 >> src\main\resources\jdbc.properties.new
    echo jdbc.maxIdle=10 >> src\main\resources\jdbc.properties.new
    echo jdbc.minIdle=5 >> src\main\resources\jdbc.properties.new
    echo jdbc.maxWait=60000 >> src\main\resources\jdbc.properties.new

    move src\main\resources\jdbc.properties.new src\main\resources\jdbc.properties >nul
    echo [OK] Database configuration file updated
) else (
    echo [WARNING] Database configuration file not found, please configure manually
)
exit /b 0

:exit
echo.
echo Thank you for using HMS deployment tool!
timeout /t 2 >nul
exit
