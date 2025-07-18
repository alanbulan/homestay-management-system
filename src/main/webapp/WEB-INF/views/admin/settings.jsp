<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>⚙️ 系统设置 - HMS</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">
</head>
<body>
    <div class="admin-container">
        <!-- 侧边栏 -->
        <nav class="admin-sidebar">
            <div class="sidebar-header">
                <h4>
                    <i class="bi bi-house-door"></i>
                    民宿管理系统
                </h4>
                <p>管理员后台</p>
            </div>
            
            <div class="sidebar-nav">
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                            <i class="bi bi-speedometer2"></i>
                            仪表板
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people"></i>
                            用户管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/rooms">
                            <i class="bi bi-building"></i>
                            房源管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-receipt"></i>
                            订单管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/settings">
                            <i class="bi bi-gear"></i>
                            系统设置
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- 主内容区域 -->
        <main class="admin-main">
            <div class="main-content">
                <!-- 页面头部 -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">系统设置</h1>
                        <p class="page-subtitle">管理系统配置和参数</p>
                    </div>
                </div>

                <!-- 设置网格布局 -->
                <div class="settings-grid">
                    <!-- 基本设置 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="bi bi-gear"></i>
                            <h5 class="section-title">基本设置</h5>
                        </div>
                        <div class="section-content">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">网站名称</label>
                                    <input type="text" class="form-control" value="民宿管理系统" id="siteName">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">网站描述</label>
                                    <textarea class="form-control" rows="3" id="siteDescription">专业的民宿预订和管理平台</textarea>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">联系邮箱</label>
                                    <input type="email" class="form-control" value="admin@hms.com" id="contactEmail">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">联系电话</label>
                                    <input type="tel" class="form-control" value="400-123-4567" id="contactPhone">
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="button" class="btn btn-primary" onclick="saveBasicSettings()">
                                    <i class="bi bi-check"></i> 保存设置
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 业务设置 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="bi bi-briefcase"></i>
                            <h5 class="section-title">业务设置</h5>
                        </div>
                        <div class="section-content">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">默认入住时间</label>
                                    <input type="time" class="form-control" value="14:00" id="defaultCheckinTime">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">默认退房时间</label>
                                    <input type="time" class="form-control" value="12:00" id="defaultCheckoutTime">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">最少预订天数</label>
                                    <input type="number" class="form-control" value="1" min="1" id="minBookingDays">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">最多预订天数</label>
                                    <input type="number" class="form-control" value="30" min="1" id="maxBookingDays">
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="button" class="btn btn-primary" onclick="saveBusinessSettings()">
                                    <i class="bi bi-check"></i> 保存设置
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 支付设置 -->
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="bi bi-credit-card"></i>
                            <h5 class="section-title">支付设置</h5>
                        </div>
                        <div class="section-content">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">支付方式</label>
                                    <div class="checkbox-group">
                                        <label class="checkbox-item">
                                            <input type="checkbox" checked> 支付宝
                                        </label>
                                        <label class="checkbox-item">
                                            <input type="checkbox" checked> 微信支付
                                        </label>
                                        <label class="checkbox-item">
                                            <input type="checkbox"> 银行卡支付
                                        </label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">手续费率 (%)</label>
                                    <input type="number" class="form-control" value="2.5" step="0.1" min="0" max="10" id="feeRate">
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="button" class="btn btn-primary" onclick="savePaymentSettings()">
                                    <i class="bi bi-check"></i> 保存设置
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 系统维护 -->
                <div class="settings-section maintenance-section">
                    <div class="section-header">
                        <i class="bi bi-tools"></i>
                        <h5 class="section-title">系统维护</h5>
                    </div>
                    <div class="section-content">
                        <div class="maintenance-grid">
                            <div class="maintenance-item">
                                <div>
                                    <h6>清理系统缓存</h6>
                                    <p>清理系统临时文件和缓存数据，提升系统性能</p>
                                </div>
                                <button type="button" class="btn btn-warning" onclick="clearCache()">
                                    <i class="bi bi-trash"></i> 清理缓存
                                </button>
                            </div>
                            <div class="maintenance-item">
                                <div>
                                    <h6>数据库备份</h6>
                                    <p>备份系统数据库，确保数据安全</p>
                                </div>
                                <button type="button" class="btn btn-secondary" onclick="backupDatabase()">
                                    <i class="bi bi-download"></i> 备份数据库
                                </button>
                            </div>
                            <div class="maintenance-item">
                                <div>
                                    <h6>系统日志</h6>
                                    <p>查看系统运行日志，监控系统状态</p>
                                </div>
                                <button type="button" class="btn btn-primary" onclick="viewLogs()">
                                    <i class="bi bi-file-text"></i> 查看日志
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
            </div>
        </main>
    </div>

    <script>
        // 保存基本设置
        function saveBasicSettings() {
            alert('基本设置已保存');
        }

        // 保存业务设置
        function saveBusinessSettings() {
            alert('业务设置已保存');
        }

        // 保存支付设置
        function savePaymentSettings() {
            alert('支付设置已保存');
        }

        // 清理缓存
        function clearCache() {
            if (confirm('确定要清理系统缓存吗？')) {
                alert('缓存清理完成');
            }
        }

        // 备份数据库
        function backupDatabase() {
            if (confirm('确定要备份数据库吗？')) {
                alert('数据库备份已开始');
            }
        }

        // 查看日志
        function viewLogs() {
            alert('查看系统日志功能');
        }
    </script>
</body>
</html>
