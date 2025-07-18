# 🏠 HMS - 民宿管理系统

一个基于SSM框架（Spring + Spring MVC + MyBatis）开发的民宿管理系统，提供完整的房源管理、用户管理、订单管理功能。

## ✨ 功能特性

### 🏡 房源管理
- 房源信息管理（名称、描述、价格、位置等）
- 房源图片轮播展示
- 房源状态管理
- 房源搜索和筛选

### 👥 用户管理
- 用户注册和登录
- 用户信息管理
- 管理员权限控制
- 用户状态管理

### 📋 订单管理
- 在线预订功能
- 订单状态跟踪
- 订单历史查询
- 支付状态管理

### 🎛️ 管理后台
- 管理员登录
- 用户管理界面
- 房源管理界面
- 订单管理界面
- 数据统计展示

## 🛠️ 技术栈

- **后端框架**: Spring + Spring MVC + MyBatis
- **数据库**: MySQL 8.0
- **前端技术**: JSP + JavaScript + CSS3
- **构建工具**: Maven
- **服务器**: Tomcat 7
- **日志框架**: Logback

## 📦 项目结构

```
H_MS/
├── src/main/java/com/hms/
│   ├── config/          # 配置类
│   ├── controller/      # 控制器
│   ├── dto/            # 数据传输对象
│   ├── entity/         # 实体类
│   ├── mapper/         # MyBatis映射器
│   ├── service/        # 服务层
│   ├── util/           # 工具类
│   └── vo/             # 视图对象
├── src/main/resources/
│   ├── mapper/         # MyBatis XML映射文件
│   ├── sql/            # 数据库脚本
│   └── *.xml           # 配置文件
├── src/main/webapp/
│   ├── WEB-INF/views/  # JSP页面
│   └── static/         # 静态资源
└── pom.xml             # Maven配置
```

## 🚀 快速开始

### 环境要求
- JDK 8+
- MySQL 8.0+
- Maven 3.6+
- Tomcat 7+

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/alanbulan/H_MS.git
   cd H_MS
   ```

2. **数据库配置**
   ```bash
   # 创建数据库
   mysql -u root -p
   CREATE DATABASE homestay_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   
   # 导入数据
   mysql -u root -p homestay_db < src/main/resources/sql/homestay_db.sql
   ```

3. **修改数据库配置**
   编辑 `src/main/resources/database.properties`：
   ```properties
   jdbc.url=jdbc:mysql://localhost:3306/homestay_db
   jdbc.username=root
   jdbc.password=your_password
   ```

4. **编译和运行**
   ```bash
   # 编译项目
   mvn clean package
   
   # 启动服务器
   mvn tomcat7:run
   ```

5. **访问系统**
   - 主页: http://localhost:8080/hms/
   - 管理后台: http://localhost:8080/hms/admin/login

### 默认账号
- **管理员**: admin / 123456
- **普通用户**: testuser / 123456

## 📸 系统截图

### 主页
- 动态统计数据展示
- 功能模块导航
- 响应式设计

### 管理后台
- 用户管理（分页显示）
- 房源管理（图片展示）
- 订单管理（状态跟踪）

## 🔧 开发说明

### 数据库设计
- `user` - 用户表
- `room` - 房源表
- `room_image` - 房源图片表
- `orders` - 订单表

### API接口
- `/api/stats` - 获取统计数据
- `/user/*` - 用户相关接口
- `/room/*` - 房源相关接口
- `/order/*` - 订单相关接口

## 📝 更新日志

### v1.0.0 (2025-01-17)
- ✅ 完成基础功能开发
- ✅ 实现用户管理系统
- ✅ 实现房源管理系统
- ✅ 实现订单管理系统
- ✅ 完成管理后台界面
- ✅ 添加分页功能
- ✅ 优化用户体验

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 📞 联系方式

如有问题，请通过 GitHub Issues 联系。
