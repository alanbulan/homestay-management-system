<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📋 我的订单 - HMS</title>
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
        }
        
        .page-header {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            padding: var(--spacing-2xl);
            margin-bottom: var(--spacing-xl);
            text-align: center;
        }
        
        .page-title {
            font-size: var(--font-size-3xl);
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: var(--spacing-sm);
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: var(--font-size-lg);
        }
        
        /* 筛选区域 */
        .filter-section {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            padding: var(--spacing-xl);
            margin-bottom: var(--spacing-xl);
        }
        
        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-md);
            align-items: end;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
        }
        
        .filter-label {
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
            margin-bottom: var(--spacing-xs);
            font-weight: 500;
        }
        
        .filter-input {
            padding: var(--spacing-sm) var(--spacing-md);
            border: 2px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: var(--font-size-sm);
            transition: all var(--transition-fast);
        }
        
        .filter-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(107, 115, 255, 0.1);
        }
        
        .filter-btn {
            padding: var(--spacing-sm) var(--spacing-lg);
            background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-size: var(--font-size-sm);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-normal);
        }
        
        .filter-btn:hover {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            transform: translateY(-1px);
            box-shadow: var(--shadow-medium);
        }
        
        /* 订单列表 */
        .orders-container {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            padding: var(--spacing-xl);
        }
        
        .orders-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-xl);
            padding-bottom: var(--spacing-lg);
            border-bottom: 1px solid var(--border-color);
        }
        
        .orders-title {
            font-size: var(--font-size-xl);
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .orders-count {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }
        
        .orders-list {
            display: flex;
            flex-direction: column;
            gap: var(--spacing-lg);
        }
        
        .order-card {
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-large);
            padding: var(--spacing-xl);
            transition: all var(--transition-normal);
            cursor: pointer;
        }
        
        .order-card:hover {
            border-color: var(--primary-color);
            box-shadow: var(--shadow-medium);
            transform: translateY(-2px);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--spacing-lg);
        }
        
        .order-info {
            flex: 1;
        }
        
        .order-number {
            font-size: var(--font-size-lg);
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: var(--spacing-xs);
        }
        
        .order-date {
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
        }
        
        .order-status {
            padding: var(--spacing-xs) var(--spacing-md);
            border-radius: var(--border-radius-small);
            font-size: var(--font-size-xs);
            font-weight: 500;
            text-align: center;
            min-width: 80px;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .status-checked-in { background: #d4edda; color: #155724; }
        .status-completed { background: #e2e3e5; color: #383d41; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        
        .order-content {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
        }
        
        .order-detail {
            display: flex;
            flex-direction: column;
        }
        
        .detail-label {
            font-size: var(--font-size-xs);
            color: var(--text-secondary);
            margin-bottom: var(--spacing-xs);
            font-weight: 500;
        }
        
        .detail-value {
            font-size: var(--font-size-sm);
            color: var(--text-primary);
            font-weight: 500;
        }
        
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: var(--spacing-lg);
            border-top: 1px solid var(--border-color);
        }
        
        .order-price {
            font-size: var(--font-size-lg);
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .order-actions {
            display: flex;
            gap: var(--spacing-sm);
        }
        
        .action-btn {
            padding: var(--spacing-xs) var(--spacing-md);
            border: 1px solid var(--border-color);
            background: var(--bg-primary);
            color: var(--text-secondary);
            border-radius: var(--border-radius-small);
            font-size: var(--font-size-xs);
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        
        .action-btn:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }
        
        .action-btn.primary {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
        .action-btn.primary:hover {
            background: var(--primary-dark);
        }
        
        .action-btn.danger {
            background: var(--error-color);
            color: white;
            border-color: var(--error-color);
        }
        
        .action-btn.danger:hover {
            background: #d32f2f;
        }
        
        /* 加载和空状态 */
        .loading, .empty-state {
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
        
        .empty-icon {
            font-size: 4rem;
            margin-bottom: var(--spacing-lg);
            opacity: 0.5;
        }
        
        /* 响应式 */
        @media (max-width: 768px) {
            .filter-form {
                grid-template-columns: 1fr;
            }
            
            .order-content {
                grid-template-columns: 1fr;
                gap: var(--spacing-md);
            }
            
            .order-header {
                flex-direction: column;
                gap: var(--spacing-md);
                align-items: stretch;
            }
            
            .order-footer {
                flex-direction: column;
                gap: var(--spacing-md);
                align-items: stretch;
            }
            
            .order-actions {
                justify-content: center;
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
        <!-- 页面标题 -->
        <div class="page-header">
            <h1 class="page-title">📋 我的订单</h1>
            <p class="page-subtitle">管理您的所有预订订单</p>
        </div>
        
        <!-- 筛选区域 -->
        <div class="filter-section">
            <form class="filter-form" id="filterForm">
                <div class="filter-group">
                    <label class="filter-label">订单状态</label>
                    <select class="filter-input" id="orderStatus" name="orderStatus">
                        <option value="">全部状态</option>
                        <option value="0">待确认</option>
                        <option value="1">已确认</option>
                        <option value="2">已入住</option>
                        <option value="3">已完成</option>
                        <option value="4">已取消</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label class="filter-label">支付状态</label>
                    <select class="filter-input" id="paymentStatus" name="paymentStatus">
                        <option value="">全部状态</option>
                        <option value="0">未支付</option>
                        <option value="1">已支付</option>
                        <option value="2">已退款</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <button type="submit" class="filter-btn">
                        🔍 筛选订单
                    </button>
                </div>
            </form>
        </div>
        
        <!-- 订单列表 -->
        <div class="orders-container">
            <div class="orders-header">
                <h2 class="orders-title">订单列表</h2>
                <div class="orders-count" id="ordersCount">正在加载...</div>
            </div>
            
            <div id="ordersContainer">
                <div class="loading">
                    <div class="loading-spinner"></div>
                    <div>正在加载订单信息...</div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        let currentOrders = [];

        // 日期格式化函数
        function formatDate(dateStr) {
            if (!dateStr) return '';
            const date = new Date(dateStr);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadOrders();
            
            // 筛选表单提交
            document.getElementById('filterForm').addEventListener('submit', function(e) {
                e.preventDefault();
                loadOrders();
            });
        });
        
        // 加载订单列表
        async function loadOrders() {
            const container = document.getElementById('ordersContainer');
            const countElement = document.getElementById('ordersCount');
            
            // 显示加载状态
            container.innerHTML = `
                <div class="loading">
                    <div class="loading-spinner"></div>
                    <div>正在加载订单信息...</div>
                </div>
            `;
            
            // 收集筛选参数
            const formData = new FormData(document.getElementById('filterForm'));
            const params = new URLSearchParams();
            
            for (let [key, value] of formData.entries()) {
                if (value.trim()) {
                    params.append(key, value);
                }
            }
            
            try {
                const response = await fetch(`${pageContext.request.contextPath}/order/my/list?${params}`);
                const data = await response.json();
                
                if (data.code === 200) {
                    currentOrders = data.data;
                    displayOrders(currentOrders);
                    countElement.textContent = `共 ${currentOrders.length} 个订单`;
                } else if (data.code === 401) {
                    window.location.href = '${pageContext.request.contextPath}/user/login';
                } else {
                    container.innerHTML = `
                        <div class="empty-state">
                            <div class="empty-icon">😔</div>
                            <div>加载失败：${data.message}</div>
                        </div>
                    `;
                }
            } catch (error) {
                console.error('加载订单失败:', error);
                container.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-icon">😔</div>
                        <div>网络错误，请稍后重试</div>
                    </div>
                `;
            }
        }
        
        // 显示订单列表
        function displayOrders(orders) {
            const container = document.getElementById('ordersContainer');
            
            if (!orders || orders.length === 0) {
                container.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-icon">📋</div>
                        <div>暂无订单</div>
                        <div style="margin-top: var(--spacing-md); font-size: var(--spacing-sm);">
                            <a href="${pageContext.request.contextPath}/room/list" style="color: var(--primary-color);">去预订房源</a>
                        </div>
                    </div>
                `;
                return;
            }
            
            const ordersList = document.createElement('div');
            ordersList.className = 'orders-list';
            
            orders.forEach(order => {
                const orderCard = createOrderCard(order);
                ordersList.appendChild(orderCard);
            });
            
            container.innerHTML = '';
            container.appendChild(ordersList);
        }
        
        // 创建订单卡片
        function createOrderCard(order) {
            const card = document.createElement('div');
            card.className = 'order-card';
            card.onclick = () => viewOrderDetail(order.id);
            
            const statusClass = getStatusClass(order.orderStatus);
            const statusText = getStatusText(order.orderStatus);
            const paymentStatusText = getPaymentStatusText(order.paymentStatus);
            
            card.innerHTML =
                '<div class="order-header">' +
                    '<div class="order-info">' +
                        '<div class="order-number">订单号：' + (order.orderNo || '未知') + '</div>' +
                        '<div class="order-date">下单时间：' + formatDate(order.createTime) + '</div>' +
                    '</div>' +
                    '<div class="order-status ' + statusClass + '">' + statusText + '</div>' +
                '</div>'
 +
                '<div class="order-content">' +
                    '<div class="order-detail">' +
                        '<div class="detail-label">🏠 房源信息</div>' +
                        '<div class="detail-value">' + (order.roomName || '房源信息') + '</div>' +
                    '</div>' +
                    '<div class="order-detail">' +
                        '<div class="detail-label">📅 入住日期</div>' +
                        '<div class="detail-value">' + formatDate(order.checkInDate) + ' - ' + formatDate(order.checkOutDate) + '</div>' +
                    '</div>' +
                    '<div class="order-detail">' +
                        '<div class="detail-label">👥 入住人数</div>' +
                        '<div class="detail-value">' + (order.guests || 0) + '人 · ' + (order.nights || 0) + '晚</div>' +
                    '</div>' +
                '</div>' +
                '<div class="order-footer">' +
                    '<div class="order-price">' +
                        '总价：¥' + (order.totalPrice || 0) +
                        '<span style="font-size: var(--font-size-sm); font-weight: 400; color: var(--text-secondary);">' +
                            '(' + paymentStatusText + ')' +
                        '</span>' +
                    '</div>' +
                    '<div class="order-actions">' +
                        generateOrderActions(order) +
                    '</div>' +
                '</div>';
            
            return card;
        }
        
        // 生成订单操作按钮
        function generateOrderActions(order) {
            let actions = [];
            
            // 查看详情按钮
            actions.push('<button class="action-btn" onclick="event.stopPropagation(); viewOrderDetail(' + order.id + ')">查看详情</button>');

            // 根据订单状态显示不同操作
            if (order.orderStatus === 0) { // 待确认
                if (order.paymentStatus === 0) { // 未支付
                    actions.push('<button class="action-btn primary" onclick="event.stopPropagation(); payOrder(' + order.id + ')">立即支付</button>');
                }
                actions.push('<button class="action-btn danger" onclick="event.stopPropagation(); cancelOrder(' + order.id + ')">取消订单</button>');
            } else if (order.orderStatus === 1 && order.paymentStatus === 0) { // 已确认但未支付
                actions.push('<button class="action-btn primary" onclick="event.stopPropagation(); payOrder(' + order.id + ')">立即支付</button>');
            }
            
            return actions.join('');
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
                0: '待确认',
                1: '已确认',
                2: '已入住',
                3: '已完成',
                4: '已取消'
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
        
        // 格式化日期
        function formatDate(dateString) {
            if (!dateString) return '未知';
            const date = new Date(dateString);
            return date.toLocaleDateString('zh-CN');
        }
        
        // 查看订单详情
        function viewOrderDetail(orderId) {
            window.location.href = '${pageContext.request.contextPath}/order/detail/' + orderId;
        }
        
        // 支付订单
        async function payOrder(orderId) {
            if (!confirm('确认支付此订单吗？')) return;
            
            try {
                const response = await fetch(`${pageContext.request.contextPath}/order/pay`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `orderId=${orderId}`
                });
                
                const data = await response.json();
                
                if (data.code === 200) {
                    alert('支付成功！');
                    loadOrders(); // 重新加载订单列表
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
                    loadOrders(); // 重新加载订单列表
                } else {
                    alert(data.message || '取消失败');
                }
            } catch (error) {
                console.error('取消订单失败:', error);
                alert('网络错误，请稍后重试');
            }
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
                    alert('退出失败');
                }
            } catch (error) {
                console.error('退出失败:', error);
                window.location.href = '${pageContext.request.contextPath}/';
            }
        }
    </script>
</body>
</html>
