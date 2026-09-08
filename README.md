<div align="center">

# HMS · 民宿管理系统

从房源展示到订单管理的 Java Web 业务实践。

![Spring](https://img.shields.io/badge/Spring-MVC-5eead4?style=flat-square)
![MyBatis](https://img.shields.io/badge/MyBatis-3-818cf8?style=flat-square)
![Category](https://img.shields.io/badge/category-Business_Project-fb7185?style=flat-square)

[项目能力](#项目能力) · [快速开始](#快速开始) · [技术架构](#技术架构) · [开发说明](#开发说明)

</div>

HMS 是使用 Spring、Spring MVC、MyBatis 和 JSP 构建的民宿管理项目，涵盖房源、用户、预订与管理后台。项目按 WAR 形式打包，保留为 Java Web 领域实践与学习参考。

## 项目能力

| 房源 | 用户 | 订单与管理 |
| --- | --- | --- |
| 房源信息、图片与状态管理 | 注册、登录与个人资料 | 在线预订与订单查询 |
| 搜索、筛选与展示 | 管理员与用户管理 | 订单状态、支付状态字段与统计展示 |

“支付状态管理”不等于已接入真实支付渠道。部署前应独立验证认证、权限和关键业务流程，本次文档更新没有执行运行验收。

## 快速开始

### 环境与配置

使用兼容项目 Java 8 编译目标的 JDK、Maven 和 MySQL。当前 [pom.xml](./pom.xml) 固定了 Spring 5.2、MyBatis 3.5 等历史依赖，并包含 `tomcat7-maven-plugin`；这些是仓库现状，不是对当前生产技术选型的推荐。

```sh
git clone https://github.com/alanbulan/homestay-management-system.git
cd homestay-management-system
```

先检查 `src/main/resources/sql/homestay_db.sql`，确认使用独立的开发数据库。初始化前备份已有数据，不要把示例脚本直接导入生产库。

```sql
CREATE DATABASE homestay_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

在支持输入重定向的终端中导入：

```sh
mysql -u root -p homestay_db < src/main/resources/sql/homestay_db.sql
```

按本机实际情况填写 `src/main/resources/database.properties`。真实密码只保存在本机受保护的配置中，不提交到 Git。

### 编译与本地运行

```sh
mvn clean package
mvn tomcat7:run
```

当前 Maven 插件配置端口 `8080`，上下文路径 `/hms`。启动成功后访问：

- 本地主页：`http://localhost:8080/hms/`
- 管理员入口：`http://localhost:8080/hms/admin/login`

上述内嵌容器命令用于复现原有开发环境；对外部署应先检查依赖与容器兼容性、安全配置和账号权限。

### 演示账号

旧版说明列出的 `admin`、`testuser` 是演示账号，是否存在以本机导入数据为准。示例弱口令不得用于公网部署；对外开放前应删除演示账号或重设密码，并验证后台访问控制。

## 技术架构

```mermaid
flowchart LR
    Browser[浏览器 / JSP] --> MVC[Spring MVC Controller]
    MVC --> Service[Service 业务层]
    Service --> Mapper[MyBatis Mapper]
    Mapper --> DB[(MySQL)]
    classDef ui fill:#eef2ff,stroke:#818cf8,color:#1e293b
    classDef app fill:#ecfdf5,stroke:#34d399,color:#134e4a
    class Browser,MVC ui
    class Service,Mapper,DB app
```

| 入口 | 职责 |
| --- | --- |
| `src/main/java/com/hms/` | Controller、Service、Mapper、实体与 DTO/VO |
| `src/main/resources/` | Mapper XML、数据库脚本与应用配置 |
| `src/main/webapp/` | JSP 页面与静态资源 |
| [pom.xml](./pom.xml) | 依赖、WAR 打包与本地容器配置 |

主要数据对象包括用户、房源、房源图片和订单。历史说明中的接口分组为 `/user/*`、`/room/*`、`/order/*` 及 `/api/stats`，实际映射以当前控制器为准。

## 开发说明

修改业务时同步检查校验、权限、数据库映射和页面调用。`mvn package` 是构建入口，构建成功不能代替预订流程、权限或数据库事务验收；本次没有执行测试。

截图应使用实际运行画面，并去除个人信息与凭据。当前不使用文字占位段落冒充截图，也不声称所有功能已经完成生产验收。

## 许可证

保留原有声明：MIT License。本次仅整理文档，不新增或变更授权条款；使用时一并核实源码和依赖中的许可要求。

## 反馈

通过 [Issues](https://github.com/alanbulan/homestay-management-system/issues) 提交复现环境、操作步骤与脱敏日志。
