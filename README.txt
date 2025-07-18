HMS Homestay Management System - User Guide
========================================

Directory Structure
├── deploy-hms.bat         # Complete deployment tool (first time use)
├── hms.bat                # Simple quick start (recommended)
├── run-hms.bat            # Alternative quick start
├── sql/                   # Database files directory
│   ├── hms_schema.sql     # Database structure file
│   └── hms_data.sql       # Initial data file
└── README.txt             # This file

Quick Start

【First Time Deployment】
1. Double-click "deploy-hms.bat"
2. Select "[1] Full Deploy (Database + System)"
3. Enter MySQL database connection information as prompted
4. Wait for automatic deployment to complete

【Daily Use】
1. Double-click "hms.bat" (recommended) or "run-hms.bat"
2. Wait for system startup to complete
3. Access in browser: http://localhost:8080/hms

System Requirements

Required Software:
- Java 8 or higher
- Apache Maven 3.6 or higher
- MySQL 8.0 or higher

Recommended Configuration:
- Memory: 4GB or more
- Disk: 2GB available space
- Network: Internet access (for downloading dependencies)

Default Accounts

Administrator:
- Username: admin
- Password: admin123

Test User:
- Username: test
- Password: test123

Demo User:
- Username: demo
- Password: demo123

Database Information

Default Database: hms_db
Default Port: 3306
Character Set: utf8mb4

Tables Included:
- user (User table)
- room (Room table)
- room_image (Room image table)
- booking (Booking table)
- system_config (System configuration table)

System Features

User Features:
✅ User registration/login
✅ Room browsing/searching
✅ Room details viewing
✅ Online booking
✅ Order management
✅ Personal information management

Admin Features:
✅ Room management
✅ Order management
✅ User management
✅ System configuration

Troubleshooting

Common Issues:

1. Port 8080 is in use
   Solution: Run deployment tool, select "[6] Check Port Usage"

2. Database connection failed
   Solution: Check if MySQL service is running, confirm connection info

3. Maven dependency download failed
   Solution: Check network connection, run deployment tool select "[5] Clean and Rebuild"

4. Chinese character encoding issues
   Solution: Use provided .bat files, UTF-8 encoding is automatically set

5. Java environment issues
   Solution: Ensure Java 8+ is installed and JAVA_HOME is properly configured

Technical Support

If you encounter other issues, please check:
1. System environment meets requirements
2. Firewall is not blocking port access
3. Database service is running normally
4. Project files are complete

Usage Tips

1. First time use must run "deploy-hms.bat" for complete deployment
2. Daily use recommended "hms.bat" (simplest) or "run-hms.bat"
3. If script hangs, use "hms.bat" which has minimal checks
4. Press Ctrl+C to stop server
5. Recommend regular database backup

Update Notes

Version: 1.0.0
Update Date: 2025-07-16
Update Content:
- Initial version release
- Complete homestay management features
- Automated deployment tools
- Chinese encoding issue resolution

========================================
HMS Homestay Management System © 2025
========================================
