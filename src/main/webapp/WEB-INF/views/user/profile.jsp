<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>👤 个人中心 - HMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/background.css">
    <style>
        body {
            padding: 0;
        }
        
        /* 导航栏 */
        .navbar {
            background: var(--bg-primary);
            border-bottom: 1px solid var(--border-color);
            box-shadow: var(--shadow-light);
            position: sticky;
            top: 0;
            z-index: 1000;
            padding: var(--spacing-md) 0;
        }
        
        .navbar-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--spacing-md);
        }
        
        .navbar-brand {
            font-size: var(--font-size-xl);
            font-weight: 700;
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .navbar-nav {
            display: flex;
            gap: var(--spacing-md);
            align-items: center;
        }
        
        .nav-link {
            color: var(--text-secondary);
            text-decoration: none;
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-small);
            transition: all var(--transition-fast);
            font-size: var(--font-size-sm);
        }
        
        .nav-link:hover {
            color: var(--primary-color);
            background: rgba(107, 115, 255, 0.1);
        }
        
        /* 主要内容区域 */
        .main-content {
            max-width: 1200px;
            margin: var(--spacing-xl) auto;
            padding: 0 var(--spacing-md);
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: var(--spacing-2xl);
        }
        
        /* 侧边栏 */
        .sidebar {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            padding: var(--spacing-2xl);
            height: fit-content;
            position: sticky;
            top: calc(80px + var(--spacing-md));
        }
        
        .user-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: var(--font-size-3xl);
            color: white;
            margin: 0 auto var(--spacing-lg);
        }
        
        .user-info {
            text-align: center;
            margin-bottom: var(--spacing-xl);
        }
        
        .user-name {
            font-size: var(--font-size-lg);
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: var(--spacing-xs);
        }
        
        .user-email {
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .menu-item {
            margin-bottom: var(--spacing-sm);
        }
        
        .menu-link {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            padding: var(--spacing-md);
            color: var(--text-secondary);
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: all var(--transition-fast);
        }
        
        .menu-link:hover,
        .menu-link.active {
            background: rgba(107, 115, 255, 0.1);
            color: var(--primary-color);
        }
        
        /* 内容区域 */
        .content-area {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            padding: var(--spacing-2xl);
        }
        
        .content-header {
            margin-bottom: var(--spacing-xl);
            padding-bottom: var(--spacing-lg);
            border-bottom: 1px solid var(--border-color);
        }
        
        .content-title {
            font-size: var(--font-size-2xl);
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: var(--spacing-sm);
        }
        
        .content-subtitle {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }
        
        /* 表单样式 */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            font-size: var(--font-size-sm);
            color: var(--text-primary);
            margin-bottom: var(--spacing-sm);
            font-weight: 500;
        }
        
        .form-input {
            padding: var(--spacing-md);
            border: 2px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: var(--font-size-base);
            transition: all var(--transition-fast);
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(107, 115, 255, 0.1);
        }
        
        .form-input:disabled {
            background: var(--bg-tertiary);
            color: var(--text-light);
            cursor: not-allowed;
        }
        
        .form-actions {
            display: flex;
            gap: var(--spacing-md);
            justify-content: flex-end;
        }
        
        .btn {
            padding: var(--spacing-md) var(--spacing-xl);
            border: none;
            border-radius: var(--border-radius);
            font-size: var(--font-size-base);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-normal);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: var(--spacing-sm);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            color: white;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }
        
        .btn-secondary {
            background: var(--bg-secondary);
            color: var(--text-secondary);
            border: 2px solid var(--border-color);
        }
        
        .btn-secondary:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, var(--error-color), #ff8a80);
            color: white;
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #d32f2f, var(--error-color));
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }
        
        /* 统计卡片 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
        }
        
        .stat-card {
            background: linear-gradient(135deg, var(--bg-primary), var(--bg-secondary));
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-large);
            padding: var(--spacing-xl);
            text-align: center;
            transition: all var(--transition-normal);
        }
        
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
        }
        
        .stat-icon {
            font-size: var(--font-size-3xl);
            margin-bottom: var(--spacing-md);
        }
        
        .stat-number {
            font-size: var(--font-size-2xl);
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: var(--spacing-xs);
        }
        
        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
        }
        
        /* 消息样式 */
        .message {
            padding: var(--spacing-md);
            border-radius: var(--border-radius);
            margin-bottom: var(--spacing-md);
            font-size: var(--font-size-sm);
        }
        
        .message.success {
            background: linear-gradient(135deg, #e6ffe6, #ccffcc);
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }
        
        .message.error {
            background: linear-gradient(135deg, #ffe6e6, #ffcccc);
            color: var(--error-color);
            border-left: 4px solid var(--error-color);
        }
        
        /* 响应式 */
        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
                gap: var(--spacing-lg);
            }
            
            .sidebar {
                position: static;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .form-actions {
                flex-direction: column;
            }
        }
        
        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="navbar-content">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">🏠 HMS</a>
            <div class="navbar-nav">
                <a href="${pageContext.request.contextPath}/" class="nav-link">🏠 首页</a>
                <a href="${pageContext.request.contextPath}/room/list" class="nav-link">🏡 房源</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <!-- 已登录用户 -->
                        <a href="${pageContext.request.contextPath}/order/my" class="nav-link">📋 我的订单</a>
                        <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">👤 ${sessionScope.currentUser.realName}</a>
                        <a href="#" class="nav-link" onclick="logout()">🚪 退出</a>
                    </c:when>
                    <c:otherwise>
                        <!-- 未登录用户 -->
                        <a href="${pageContext.request.contextPath}/user/login" class="nav-link">👤 登录</a>
                        <a href="${pageContext.request.contextPath}/user/register" class="nav-link">📝 注册</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>
    
    <div class="main-content">
        <!-- 侧边栏 -->
        <div class="sidebar">
            <div class="user-avatar" id="userAvatar">👤</div>
            <div class="user-info">
                <div class="user-name" id="userName">加载中...</div>
                <div class="user-email" id="userEmail">加载中...</div>
            </div>
            
            <ul class="sidebar-menu">
                <li class="menu-item">
                    <a href="#" class="menu-link active" onclick="showSection('profile')">
                        👤 个人信息
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" onclick="showSection('password')">
                        🔒 修改密码
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="menu-link" onclick="showSection('orders')">
                        📋 订单统计
                    </a>
                </li>
            </ul>
        </div>
        
        <!-- 内容区域 -->
        <div class="content-area">
            <div id="messageContainer"></div>
            
            <!-- 个人信息 -->
            <div id="profileSection" class="content-section">
                <div class="content-header">
                    <h2 class="content-title">👤 个人信息</h2>
                    <p class="content-subtitle">管理您的个人资料信息</p>
                </div>
                
                <form id="profileForm">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">用户名</label>
                            <input type="text" class="form-input" id="username" disabled>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">真实姓名</label>
                            <input type="text" class="form-input" id="realName" name="realName">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">邮箱地址</label>
                            <input type="email" class="form-input" id="email" name="email">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">手机号码</label>
                            <input type="tel" class="form-input" id="phone" name="phone">
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="loadUserInfo()">
                            🔄 重置
                        </button>
                        <button type="submit" class="btn btn-primary">
                            ✨ 保存修改
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- 修改密码 -->
            <div id="passwordSection" class="content-section" style="display: none;">
                <div class="content-header">
                    <h2 class="content-title">🔒 修改密码</h2>
                    <p class="content-subtitle">为了账户安全，请定期更换密码</p>
                </div>
                
                <form id="passwordForm">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">当前密码</label>
                            <input type="password" class="form-input" id="oldPassword" name="oldPassword" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">新密码</label>
                            <input type="password" class="form-input" id="newPassword" name="newPassword" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">确认新密码</label>
                            <input type="password" class="form-input" id="confirmPassword" name="confirmPassword" required>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="clearPasswordForm()">
                            🔄 清空
                        </button>
                        <button type="submit" class="btn btn-primary">
                            ✨ 修改密码
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- 订单统计 -->
            <div id="ordersSection" class="content-section" style="display: none;">
                <div class="content-header">
                    <h2 class="content-title">📋 订单统计</h2>
                    <p class="content-subtitle">查看您的订单统计信息</p>
                </div>
                
                <div class="stats-grid" id="orderStats">
                    <!-- 动态加载 -->
                </div>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/order/my" class="btn btn-primary">
                        📋 查看所有订单
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        let currentUser = null;
        
        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadUserInfo();
            initializeForms();
        });
        
        // 加载用户信息
        async function loadUserInfo() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/user/current');
                const data = await response.json();
                
                if (data.code === 200) {
                    currentUser = data.data;
                    displayUserInfo(currentUser);
                } else if (data.code === 401) {
                    window.location.href = '${pageContext.request.contextPath}/user/login';
                } else {
                    showMessage('获取用户信息失败：' + data.message, 'error');
                }
            } catch (error) {
                console.error('加载用户信息失败:', error);
                showMessage('网络错误，请稍后重试', 'error');
            }
        }
        
        // 显示用户信息
        function displayUserInfo(user) {
            document.getElementById('userName').textContent = user.realName || user.username;
            document.getElementById('userEmail').textContent = user.email || '未设置邮箱';
            document.getElementById('userAvatar').textContent = (user.realName || user.username).charAt(0).toUpperCase();
            
            // 填充表单
            document.getElementById('username').value = user.username || '';
            document.getElementById('realName').value = user.realName || '';
            document.getElementById('email').value = user.email || '';
            document.getElementById('phone').value = user.phone || '';
        }
        
        // 初始化表单
        function initializeForms() {
            // 个人信息表单
            document.getElementById('profileForm').addEventListener('submit', function(e) {
                e.preventDefault();
                updateProfile();
            });
            
            // 密码修改表单
            document.getElementById('passwordForm').addEventListener('submit', function(e) {
                e.preventDefault();
                changePassword();
            });
        }
        
        // 更新个人信息
        async function updateProfile() {
            const formData = {
                realName: document.getElementById('realName').value,
                email: document.getElementById('email').value,
                phone: document.getElementById('phone').value
            };
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/user/profile', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(formData)
                });
                
                const data = await response.json();
                
                if (data.code === 200) {
                    showMessage('个人信息更新成功', 'success');
                    currentUser = data.data;
                    displayUserInfo(currentUser);
                } else {
                    showMessage(data.message || '更新失败', 'error');
                }
            } catch (error) {
                console.error('更新个人信息失败:', error);
                showMessage('网络错误，请稍后重试', 'error');
            }
        }
        
        // 修改密码
        async function changePassword() {
            const oldPassword = document.getElementById('oldPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                showMessage('两次输入的新密码不一致', 'error');
                return;
            }
            
            if (newPassword.length < 6) {
                showMessage('新密码至少6位', 'error');
                return;
            }
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/user/changePassword', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'oldPassword=' + encodeURIComponent(oldPassword) + '&newPassword=' + encodeURIComponent(newPassword)
                });
                
                const data = await response.json();
                
                if (data.code === 200) {
                    showMessage('密码修改成功', 'success');
                    clearPasswordForm();
                } else {
                    showMessage(data.message || '密码修改失败', 'error');
                }
            } catch (error) {
                console.error('修改密码失败:', error);
                showMessage('网络错误，请稍后重试', 'error');
            }
        }
        
        // 加载订单统计
        async function loadOrderStats() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/order/my/statistics');
                const data = await response.json();
                
                if (data.code === 200) {
                    displayOrderStats(data.data);
                } else {
                    showMessage('获取订单统计失败：' + data.message, 'error');
                }
            } catch (error) {
                console.error('加载订单统计失败:', error);
                showMessage('网络错误，请稍后重试', 'error');
            }
        }
        
        // 显示订单统计
        function displayOrderStats(stats) {
            const container = document.getElementById('orderStats');
            container.innerHTML =
                '<div class="stat-card">' +
                    '<div class="stat-icon">📋</div>' +
                    '<div class="stat-number">' + (stats.totalOrders || 0) + '</div>' +
                    '<div class="stat-label">总订单数</div>' +
                '</div>' +
                '<div class="stat-card">' +
                    '<div class="stat-icon">⏳</div>' +
                    '<div class="stat-number">' + (stats.pendingOrders || 0) + '</div>' +
                    '<div class="stat-label">待确认</div>' +
                '</div>' +
                '<div class="stat-card">' +
                    '<div class="stat-icon">✅</div>' +
                    '<div class="stat-number">' + (stats.confirmedOrders || 0) + '</div>' +
                    '<div class="stat-label">已确认</div>' +
                '</div>' +
                '<div class="stat-card">' +
                    '<div class="stat-icon">🏠</div>' +
                    '<div class="stat-number">' + (stats.checkedInOrders || 0) + '</div>' +
                    '<div class="stat-label">已入住</div>' +
                '</div>' +
                '<div class="stat-card">' +
                    '<div class="stat-icon">🎉</div>' +
                    '<div class="stat-number">' + (stats.completedOrders || 0) + '</div>' +
                    '<div class="stat-label">已完成</div>' +
                '</div>' +
                '<div class="stat-card">' +
                    '<div class="stat-icon">❌</div>' +
                    '<div class="stat-number">' + (stats.cancelledOrders || 0) + '</div>' +
                    '<div class="stat-label">已取消</div>' +
                '</div>';
        }
        
        // 显示指定部分
        function showSection(sectionName) {
            // 隐藏所有部分
            document.querySelectorAll('.content-section').forEach(section => {
                section.style.display = 'none';
            });
            
            // 移除所有菜单项的active类
            document.querySelectorAll('.menu-link').forEach(link => {
                link.classList.remove('active');
            });
            
            // 显示指定部分
            document.getElementById(sectionName + 'Section').style.display = 'block';
            
            // 添加active类到对应菜单项
            event.target.classList.add('active');
            
            // 如果是订单统计，加载数据
            if (sectionName === 'orders') {
                loadOrderStats();
            }
        }
        
        // 清空密码表单
        function clearPasswordForm() {
            document.getElementById('passwordForm').reset();
        }
        
        // 退出登录
        async function logout() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/user/logout', {
                    method: 'POST'
                });
                
                const data = await response.json();
                
                if (data.code === 200) {
                    window.location.href = '${pageContext.request.contextPath}/';
                } else {
                    showMessage('退出失败', 'error');
                }
            } catch (error) {
                console.error('退出失败:', error);
                window.location.href = '${pageContext.request.contextPath}/';
            }
        }
        
        // 显示消息
        function showMessage(message, type) {
            const container = document.getElementById('messageContainer');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${type}`;
            messageDiv.textContent = message;
            
            container.innerHTML = '';
            container.appendChild(messageDiv);
            
            setTimeout(() => {
                if (messageDiv.parentNode) {
                    messageDiv.remove();
                }
            }, 5000);
        }
    </script>
</body>
</html>
