<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📋 订单详情 - HMS</title>
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
            max-width: 1000px;
            margin: var(--spacing-xl) auto;
            padding: 0 var(--spacing-md);
        }
        
        .order-container {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            overflow: hidden;
        }
        
        .order-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            color: white;
            padding: var(--spacing-2xl);
            text-align: center;
        }
        
        .order-title {
            font-size: var(--font-size-2xl);
            font-weight: 700;
            margin-bottom: var(--spacing-sm);
        }
        
        .order-number {
            font-size: var(--font-size-lg);
            opacity: 0.9;
        }
        
        .order-content {
            padding: var(--spacing-2xl);
        }
        
        .order-status-bar {
            display: flex;
            justify-content: center;
            margin-bottom: var(--spacing-2xl);
        }
        
        .status-badge {
            padding: var(--spacing-md) var(--spacing-xl);
            border-radius: var(--border-radius-large);
            font-size: var(--font-size-lg);
            font-weight: 600;
            text-align: center;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .status-checked-in { background: #d4edda; color: #155724; }
        .status-completed { background: #e2e3e5; color: #383d41; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        
        .order-sections {
            display: grid;
            gap: var(--spacing-xl);
        }
        
        .order-section {
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-large);
            overflow: hidden;
        }
        
        .section-header {
            background: var(--bg-secondary);
            padding: var(--spacing-lg);
            border-bottom: 1px solid var(--border-color);
        }
        
        .section-title {
            font-size: var(--font-size-lg);
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }
        
        .section-content {
            padding: var(--spacing-lg);
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: var(--spacing-lg);
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
            margin-bottom: var(--spacing-xs);
            font-weight: 500;
        }
        
        .info-value {
            font-size: var(--font-size-base);
            color: var(--text-primary);
            font-weight: 500;
        }
        
        .price-summary {
            background: var(--bg-secondary);
            border-radius: var(--border-radius);
            padding: var(--spacing-lg);
        }
        
        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: var(--spacing-sm);
            font-size: var(--font-size-sm);
        }
        
        .price-row.total {
            font-weight: 600;
            font-size: var(--font-size-lg);
            padding-top: var(--spacing-sm);
            border-top: 1px solid var(--border-color);
            margin-top: var(--spacing-sm);
            color: var(--primary-color);
        }
        
        .order-actions {
            display: flex;
            gap: var(--spacing-md);
            justify-content: center;
            margin-top: var(--spacing-xl);
            flex-wrap: wrap;
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
        
        .loading {
            text-align: center;
            padding: var(--spacing-2xl);
            color: var(--text-secondary);
        }
        
        .loading-spinner {
            display: inline-block;
            width: 40px;
            height: 40px;
            border: 3px solid var(--border-color);
            border-top: 3px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: var(--spacing-md);
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* 响应式 */
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .order-actions {
                flex-direction: column;
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
        <div class="order-container">
            <div class="order-header">
                <h1 class="order-title">📋 订单详情</h1>
                <div class="order-number" id="orderNumber">订单号：加载中...</div>
            </div>
            
            <div class="order-content">
                <div id="loadingContainer">
                    <div class="loading">
                        <div class="loading-spinner"></div>
                        <div>正在加载订单信息...</div>
                    </div>
                </div>
                
                <div id="orderContent" style="display: none;">
                    <div class="order-status-bar">
                        <div class="status-badge" id="orderStatus">加载中...</div>
                    </div>
                    
                    <div class="order-sections">
                        <!-- 房源信息 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">🏠 房源信息</h3>
                            </div>
                            <div class="section-content">
                                <div class="info-grid" id="roomInfo">
                                    <!-- 动态加载 -->
                                </div>
                            </div>
                        </div>
                        
                        <!-- 预订信息 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">📅 预订信息</h3>
                            </div>
                            <div class="section-content">
                                <div class="info-grid" id="bookingInfo">
                                    <!-- 动态加载 -->
                                </div>
                            </div>
                        </div>
                        
                        <!-- 联系信息 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">👤 联系信息</h3>
                            </div>
                            <div class="section-content">
                                <div class="info-grid" id="contactInfo">
                                    <!-- 动态加载 -->
                                </div>
                            </div>
                        </div>
                        
                        <!-- 费用明细 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">💰 费用明细</h3>
                            </div>
                            <div class="section-content">
                                <div class="price-summary" id="priceInfo">
                                    <!-- 动态加载 -->
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="order-actions" id="orderActions">
                        <!-- 动态加载 -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        let currentOrder = null;

        // 日期格式化函数
        function formatDate(dateStr) {
            if (!dateStr) return '';
            const date = new Date(dateStr);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }

        // 日期时间格式化函数
        function formatDateTime(dateTimeStr) {
            if (!dateTimeStr) return '';
            const date = new Date(dateTimeStr);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
        }

        // 获取订单ID
        const pathParts = window.location.pathname.split('/');
        const orderId = pathParts[pathParts.length - 1];
        
        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadOrderDetail();
        });
        
        // 加载订单详情
        async function loadOrderDetail() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/order/api/detail/' + orderId);
                const data = await response.json();
                
                if (data.code === 200) {
                    currentOrder = data.data;
                    displayOrderDetail(currentOrder);
                } else if (data.code === 401) {
                    window.location.href = '${pageContext.request.contextPath}/user/login';
                } else {
                    showError('订单信息加载失败：' + data.message);
                }
            } catch (error) {
                console.error('加载订单详情失败:', error);
                showError('网络错误，请稍后重试');
            }
        }
        
        // 显示订单详情
        function displayOrderDetail(order) {
            document.getElementById('orderNumber').textContent = '订单号：' + (order.orderNo || '未知');
            
            // 显示订单状态
            const statusElement = document.getElementById('orderStatus');
            const statusClass = getStatusClass(order.orderStatus);
            const statusText = getStatusText(order.orderStatus);
            statusElement.className = 'status-badge ' + statusClass;
            statusElement.textContent = statusText;
            
            // 显示房源信息
            const room = order.room || {};
            document.getElementById('roomInfo').innerHTML =
                '<div class="info-item">' +
                    '<div class="info-label">房源名称</div>' +
                    '<div class="info-value">' + (room.roomName || '未知') + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">房源类型</div>' +
                    '<div class="info-value">' + (room.roomType || '未知') + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">房源地址</div>' +
                    '<div class="info-value">' + (room.address || '未知') + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">每晚价格</div>' +
                    '<div class="info-value">¥' + (room.pricePerNight || 0) + '</div>' +
                '</div>';
            
            // 显示预订信息
            document.getElementById('bookingInfo').innerHTML =
                '<div class="info-item">' +
                    '<div class="info-label">入住日期</div>' +
                    '<div class="info-value">' + formatDate(order.checkInDate) + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">退房日期</div>' +
                    '<div class="info-value">' + formatDate(order.checkOutDate) + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">入住天数</div>' +
                    '<div class="info-value">' + (order.nights || 0) + '晚</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">入住人数</div>' +
                    '<div class="info-value">' + (order.guests || 0) + '人</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">下单时间</div>' +
                    '<div class="info-value">' + formatDateTime(order.createTime) + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">特殊要求</div>' +
                    '<div class="info-value">' + (order.specialRequests || '无') + '</div>' +
                '</div>';
            
            // 显示联系信息
            document.getElementById('contactInfo').innerHTML =
                '<div class="info-item">' +
                    '<div class="info-label">联系人姓名</div>' +
                    '<div class="info-value">' + (order.contactName || '未知') + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">联系电话</div>' +
                    '<div class="info-value">' + (order.contactPhone || '未知') + '</div>' +
                '</div>' +
                '<div class="info-item">' +
                    '<div class="info-label">邮箱地址</div>' +
                    '<div class="info-value">' + (order.contactEmail || '未设置') + '</div>' +
                '</div>';
            
            // 显示费用明细
            const paymentStatusText = getPaymentStatusText(order.paymentStatus);
            document.getElementById('priceInfo').innerHTML =
                '<div class="price-row">' +
                    '<span>房费 × ' + (order.nights || 0) + '晚</span>' +
                    '<span>¥' + ((order.pricePerNight || 0) * (order.nights || 0)) + '</span>' +
                '</div>' +
                '<div class="price-row total">' +
                    '<span>总计</span>' +
                    '<span>¥' + (order.totalPrice || 0) + '</span>' +
                '</div>' +
                '<div class="price-row">' +
                    '<span>支付状态</span>' +
                    '<span style="color: ' + getPaymentStatusColor(order.paymentStatus) + '">' + paymentStatusText + '</span>' +
                '</div>';
            
            // 显示操作按钮
            generateOrderActions(order);
            
            // 隐藏加载状态，显示内容
            document.getElementById('loadingContainer').style.display = 'none';
            document.getElementById('orderContent').style.display = 'block';
        }
        
        // 生成订单操作按钮
        function generateOrderActions(order) {
            const actionsContainer = document.getElementById('orderActions');
            let actions = [];
            
            // 返回订单列表按钮
            actions.push('<a href="${pageContext.request.contextPath}/order/my" class="btn btn-secondary">📋 返回订单列表</a>');

            // 根据订单状态显示不同操作
            if (order.orderStatus === 0) { // 待确认
                if (order.paymentStatus === 0) { // 未支付
                    actions.push('<button class="btn btn-primary" onclick="payOrder(' + order.id + ')">💳 立即支付</button>');
                }
                actions.push('<button class="btn btn-danger" onclick="cancelOrder(' + order.id + ')">❌ 取消订单</button>');
            } else if (order.orderStatus === 1 && order.paymentStatus === 0) { // 已确认但未支付
                actions.push('<button class="btn btn-primary" onclick="payOrder(' + order.id + ')">💳 立即支付</button>');
            }
            
            actionsContainer.innerHTML = actions.join('');
        }
        
        // 获取状态样式类
        function getStatusClass(status) {
            const statusMap = {
                0: 'status-pending',
                1: 'status-confirmed',
                2: 'status-checked-in',
                3: 'status-completed',
                4: 'status-cancelled'
            };
            return statusMap[status] || 'status-pending';
        }
        
        // 获取状态文本
        function getStatusText(status) {
            const statusMap = {
                0: '⏳ 待确认',
                1: '✅ 已确认',
                2: '🏠 已入住',
                3: '🎉 已完成',
                4: '❌ 已取消'
            };
            return statusMap[status] || '未知状态';
        }
        
        // 获取支付状态文本
        function getPaymentStatusText(status) {
            const statusMap = {
                0: '未支付',
                1: '已支付',
                2: '已退款'
            };
            return statusMap[status] || '未知';
        }
        
        // 获取支付状态颜色
        function getPaymentStatusColor(status) {
            const colorMap = {
                0: 'var(--warning-color)',
                1: 'var(--success-color)',
                2: 'var(--error-color)'
            };
            return colorMap[status] || 'var(--text-secondary)';
        }
        
        // 格式化日期
        function formatDate(dateString) {
            if (!dateString) return '未知';
            const date = new Date(dateString);
            return date.toLocaleDateString('zh-CN');
        }
        
        // 格式化日期时间
        function formatDateTime(dateString) {
            if (!dateString) return '未知';
            const date = new Date(dateString);
            return date.toLocaleString('zh-CN');
        }
        
        // 支付订单
        async function payOrder(orderId) {
            if (!confirm('确认支付此订单吗？')) return;
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/order/pay', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'orderId=' + orderId
                });
                
                const data = await response.json();
                
                if (data.code === 200) {
                    alert('支付成功！');
                    loadOrderDetail(); // 重新加载订单详情
                } else {
                    alert(data.message || '支付失败');
                }
            } catch (error) {
                console.error('支付失败:', error);
                alert('网络错误，请稍后重试');
            }
        }
        
        // 取消订单
        async function cancelOrder(orderId) {
            const reason = prompt('请输入取消原因（可选）：');
            if (reason === null) return; // 用户取消
            
            try {
                const response = await fetch(`${pageContext.request.contextPath}/order/cancel`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'orderId=' + orderId + '&cancelReason=' + encodeURIComponent(reason || '')
                });
                
                const data = await response.json();
                
                if (data.code === 200) {
                    alert('订单取消成功！');
                    loadOrderDetail(); // 重新加载订单详情
                } else {
                    alert(data.message || '取消失败');
                }
            } catch (error) {
                console.error('取消订单失败:', error);
                alert('网络错误，请稍后重试');
            }
        }
        
        // 显示错误
        function showError(message) {
            document.getElementById('loadingContainer').innerHTML = `
                <div class="loading">
                    <div style="font-size: 3rem; margin-bottom: var(--spacing-md);">😔</div>
                    <div>${message}</div>
                    <div style="margin-top: var(--spacing-md);">
                        <button onclick="loadOrderDetail()" class="btn btn-primary">🔄 重新加载</button>
                    </div>
                </div>
            `;
        }

        // 用户退出
        async function logout() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/user/logout', {
                    method: 'POST'
                });
                const data = await response.json();
                if (data.code === 200) {
                    window.location.href = '${pageContext.request.contextPath}/';
                } else {
                    alert('退出失败：' + data.message);
                }
            } catch (error) {
                console.error('退出失败:', error);
                alert('网络错误，请稍后重试');
            }
        }
    </script>
</body>
</html>
