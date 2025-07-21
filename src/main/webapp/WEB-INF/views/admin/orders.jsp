<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📋 订单管理 - HMS</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">

    <style>
        /* 强制表格对齐 - 覆盖所有其他样式 */
        .table th,
        .table td,
        table th,
        table td {
            text-align: center !important;
            vertical-align: middle !important;
        }

        .table .text-center,
        table .text-center,
        .text-center {
            text-align: center !important;
        }

        /* 确保表格内容居中 */
        #orderTableBody td {
            text-align: center !important;
        }

        #orderTableBody th {
            text-align: center !important;
        }

        /* 操作按钮列样式 */
        .action-buttons {
            white-space: nowrap;
        }

        .action-buttons .btn {
            margin: 0 2px;
        }

        /* 强制覆盖筛选器样式 */
        .filter-section {
            background: var(--bg-primary) !important;
            border: 1px solid var(--border-color) !important;
            border-radius: var(--border-radius) !important;
            padding: var(--spacing-lg) !important;
            margin-bottom: var(--spacing-lg) !important;
            box-shadow: var(--shadow-light) !important;
        }

        .filter-section .form-label {
            font-size: 16px !important;
            font-weight: 500 !important;
        }

        .filter-section .form-control {
            font-size: 16px !important;
            min-height: 40px !important;
            padding: 10px 12px !important;
        }

        .filter-section .filter-title {
            font-size: 18px !important;
            font-weight: 600 !important;
        }

        .filter-section .form-row {
            display: grid !important;
            grid-template-columns: 1fr 1fr 150px 150px 1fr !important;
            gap: 16px !important;
            margin-bottom: 16px !important;
        }

        /* 响应式布局 - 中等屏幕 */
        @media (max-width: 1200px) {
            .filter-section .form-row {
                grid-template-columns: 1fr 1fr 1fr !important;
            }

            .filter-section .form-row .form-group:nth-child(4),
            .filter-section .form-row .form-group:nth-child(5) {
                grid-column: span 1 !important;
            }
        }

        /* 响应式布局 - 小屏幕 */
        @media (max-width: 768px) {
            .filter-section .form-row {
                grid-template-columns: 1fr !important;
            }
        }

        .filter-section .form-actions {
            display: flex !important;
            gap: var(--spacing-sm) !important;
            justify-content: flex-end !important;
            margin-top: var(--spacing-md) !important;
        }
    </style>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-receipt"></i>
                            订单管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">
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
                        <h1 class="page-title">订单管理</h1>
                        <p class="page-subtitle">管理系统订单信息</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary" onclick="exportOrders()">
                            <i class="bi bi-download"></i> 导出订单
                        </button>
                    </div>
                </div>

                <!-- 搜索和筛选 -->
                <div class="filter-section">
                    <h6 class="filter-title">
                        <i class="bi bi-funnel"></i>
                        筛选条件
                    </h6>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">订单状态</label>
                            <select class="form-control" id="orderStatusFilter">
                                <option value="">全部状态</option>
                                <option value="0">待确认</option>
                                <option value="1">已确认</option>
                                <option value="2">已入住</option>
                                <option value="3">已完成</option>
                                <option value="4">已取消</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">支付状态</label>
                            <select class="form-control" id="paymentStatusFilter">
                                <option value="">全部状态</option>
                                <option value="0">未支付</option>
                                <option value="1">已支付</option>
                                <option value="2">已退款</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">开始日期</label>
                            <input type="date" class="form-control" id="startDateFilter">
                        </div>
                        <div class="form-group">
                            <label class="form-label">结束日期</label>
                            <input type="date" class="form-control" id="endDateFilter">
                        </div>
                        <div class="form-group">
                            <label class="form-label">搜索关键词</label>
                            <input type="text" class="form-control" id="searchKeyword" placeholder="订单号、用户名、房源名称">
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-primary" onclick="searchOrders()">
                            <i class="bi bi-search"></i> 搜索
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="resetFilters()">
                            <i class="bi bi-arrow-clockwise"></i> 重置
                        </button>
                    </div>
                </div>

                <!-- 订单列表 -->
                <div class="content-card">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="text-center">订单号</th>
                                    <th class="text-center">用户</th>
                                    <th class="text-center">房源</th>
                                    <th class="text-center">入住日期</th>
                                    <th class="text-center">退房日期</th>
                                    <th class="text-center">天数</th>
                                    <th class="text-center">总金额</th>
                                    <th class="text-center">订单状态</th>
                                    <th class="text-center">支付状态</th>
                                    <th class="text-center">创建时间</th>
                                    <th class="text-center">操作</th>
                                </tr>
                            </thead>
                            <tbody id="orderTableBody">
                                <tr>
                                    <td>ORD001</td>
                                    <td>张三</td>
                                    <td>温馨小屋</td>
                                    <td>2024-01-20</td>
                                    <td>2024-01-22</td>
                                    <td>2</td>
                                    <td>¥598.00</td>
                                    <td><span class="badge badge-success">已确认</span></td>
                                    <td><span class="badge badge-success">已支付</span></td>
                                    <td>2024-01-15</td>
                                    <td>
                                        <button class="btn btn-primary btn-action" onclick="viewOrder('ORD001')" title="查看">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-warning btn-action" onclick="editOrder('ORD001')" title="编辑">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>ORD002</td>
                                    <td>李四</td>
                                    <td>现代公寓</td>
                                    <td>2024-01-25</td>
                                    <td>2024-01-27</td>
                                    <td>2</td>
                                    <td>¥398.00</td>
                                    <td><span class="badge badge-warning">待确认</span></td>
                                    <td><span class="badge badge-danger">未支付</span></td>
                                    <td>2024-01-14</td>
                                    <td>
                                        <button class="btn btn-primary btn-action" onclick="viewOrder('ORD002')" title="查看">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-success btn-action" onclick="confirmOrder('ORD002')" title="确认">
                                            <i class="bi bi-check"></i>
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 分页组件 -->
                    <div class="pagination-wrapper">
                        <div class="pagination-container" id="paginationContainer">
                            <!-- 分页按钮将通过JavaScript生成 -->
                        </div>
                    </div>

                </div>
            </div>
        </main>
    </div>
    <script>
        let currentPage = 1;
        const pageSize = 5;





        // 加载订单列表
        function loadOrders(page = 1) {
            const orderStatus = document.getElementById('orderStatusFilter').value;
            const paymentStatus = document.getElementById('paymentStatusFilter').value;
            const startDate = document.getElementById('startDateFilter').value;
            const endDate = document.getElementById('endDateFilter').value;
            const keyword = document.getElementById('searchKeyword').value;

            const params = new URLSearchParams({
                pageNum: page,
                pageSize: pageSize
            });

            if (orderStatus) params.append('orderStatus', orderStatus);
            if (paymentStatus) params.append('paymentStatus', paymentStatus);
            if (startDate) params.append('startDate', startDate);
            if (endDate) params.append('endDate', endDate);
            if (keyword) params.append('keyword', keyword);

            console.log('请求参数:', params.toString());
            console.log('请求页码:', page, '每页大小:', pageSize);

            fetch('${pageContext.request.contextPath}/order/manage/list?' + params)
                .then(response => response.json())
                .then(result => {
                    console.log('订单API响应:', result);
                    if (result.code === 200) {
                        const pageData = result.data;
                        console.log('订单数据:', pageData);
                        renderOrderTable(pageData.list || []);
                        renderPagination(pageData.pageNum, pageData.pages, pageData.total);
                        currentPage = page;
                    } else {
                        console.error('API错误:', result.message);
                        alert('加载订单列表失败: ' + result.message);
                    }
                })
                .catch(error => {
                    console.error('请求失败:', error);
                    alert('加载订单列表失败: ' + error.message);
                });
        }

        // 渲染订单表格
        function renderOrderTable(orders) {
            console.log('渲染订单表格，数据:', orders);
            const tbody = document.getElementById('orderTableBody');
            tbody.innerHTML = '';

            // 保存订单数据到全局变量
            window.currentOrdersData = orders;

            if (!orders || orders.length === 0) {
                tbody.innerHTML = '<tr><td colspan="10" class="text-center">暂无订单数据</td></tr>';
                return;
            }

            orders.forEach(order => {
                console.log('处理订单:', order);
                const row = document.createElement('tr');
                // 添加订单ID到行的数据属性
                row.dataset.orderId = order.id;

                // 构建操作按钮
                let actionButtons = '<button class="btn btn-primary btn-action" onclick="viewOrder(\'' + order.orderNo + '\')" title="查看">' +
                    '<i class="bi bi-eye"></i>' +
                    '</button>';

                if (order.orderStatus === 0) {
                    actionButtons += '<button class="btn btn-success btn-action" onclick="confirmOrder(\'' + order.orderNo + '\')" title="确认">' +
                        '<i class="bi bi-check"></i>' +
                        '</button>';
                }
                if (order.orderStatus === 1) {
                    actionButtons += '<button class="btn btn-warning btn-action" onclick="checkInOrder(\'' + order.orderNo + '\')" title="入住">' +
                        '<i class="bi bi-box-arrow-in-right"></i>' +
                        '</button>';
                }
                if (order.orderStatus === 2) {
                    actionButtons += '<button class="btn btn-info btn-action" onclick="completeOrder(\'' + order.orderNo + '\')" title="完成">' +
                        '<i class="bi bi-check-circle"></i>' +
                        '</button>';
                }

                row.innerHTML =
                    '<td class="text-center">' + (order.orderNo || '-') + '</td>' +
                    '<td class="text-center">' + (order.user ? order.user.realName : '-') + '</td>' +
                    '<td class="text-center">' + (order.room ? order.room.roomName : '-') + '</td>' +
                    '<td class="text-center">' + formatDate(order.checkInDate) + '</td>' +
                    '<td class="text-center">' + formatDate(order.checkOutDate) + '</td>' +
                    '<td class="text-center">' + (order.nights || 0) + '</td>' +
                    '<td class="text-center">¥' + (order.totalPrice ? order.totalPrice.toFixed(2) : '0.00') + '</td>' +
                    '<td class="text-center"><span class="badge ' + getOrderStatusClass(order.orderStatus) + '">' + getOrderStatusText(order.orderStatus) + '</span></td>' +
                    '<td class="text-center"><span class="badge ' + getPaymentStatusClass(order.paymentStatus) + '">' + getPaymentStatusText(order.paymentStatus) + '</span></td>' +
                    '<td class="text-center">' + formatDate(order.createTime) + '</td>' +
                    '<td class="text-center action-buttons">' + actionButtons + '</td>';

                tbody.appendChild(row);
            });
        }

        // 获取订单状态样式类
        function getOrderStatusClass(status) {
            const classes = {
                0: 'badge-warning',  // 待确认
                1: 'badge-success',  // 已确认
                2: 'badge-info',     // 已入住
                3: 'badge-success',  // 已完成
                4: 'badge-danger'    // 已取消
            };
            return classes[status] || 'badge-secondary';
        }

        // 获取订单状态文本
        function getOrderStatusText(status) {
            const texts = {
                0: '待确认',
                1: '已确认',
                2: '已入住',
                3: '已完成',
                4: '已取消'
            };
            return texts[status] || '未知';
        }

        // 获取支付状态样式类
        function getPaymentStatusClass(status) {
            const classes = {
                0: 'badge-danger',   // 未支付
                1: 'badge-success',  // 已支付
                2: 'badge-info'      // 已退款
            };
            return classes[status] || 'badge-secondary';
        }

        // 获取支付状态文本
        function getPaymentStatusText(status) {
            const texts = {
                0: '未支付',
                1: '已支付',
                2: '已退款'
            };
            return texts[status] || '未知';
        }

        // 格式化日期
        function formatDate(dateString) {
            if (!dateString) return '-';
            const date = new Date(dateString);
            return date.toLocaleDateString();
        }



        // 渲染分页
        function renderPagination(currentPage, totalPages, totalCount) {
            console.log('分页参数:', { currentPage, totalPages, totalCount });
            const container = document.getElementById('paginationContainer');
            if (!container) return;

            container.innerHTML = '';

            if (totalPages <= 1) {
                container.style.display = 'none';
                return;
            }

            container.style.display = 'flex';

            // 上一页按钮
            const prevBtn = document.createElement('button');
            prevBtn.className = 'pagination-btn pagination-prev' + (currentPage === 1 ? ' disabled' : '');
            prevBtn.innerHTML = '← 上一页';
            prevBtn.onclick = function() {
                if (currentPage > 1) {
                    console.log('点击上一页:', currentPage - 1);
                    loadOrders(currentPage - 1);
                }
            };
            container.appendChild(prevBtn);

            // 页码按钮
            const startPage = Math.max(1, currentPage - 2);
            const endPage = Math.min(totalPages, currentPage + 2);

            // 第一页
            if (startPage > 1) {
                const firstBtn = createPageButton(1, currentPage);
                container.appendChild(firstBtn);

                if (startPage > 2) {
                    const ellipsis = document.createElement('span');
                    ellipsis.className = 'pagination-ellipsis';
                    ellipsis.textContent = '...';
                    container.appendChild(ellipsis);
                }
            }

            // 中间页码
            for (let i = startPage; i <= endPage; i++) {
                const pageBtn = createPageButton(i, currentPage);
                container.appendChild(pageBtn);
            }

            // 最后一页
            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    const ellipsis = document.createElement('span');
                    ellipsis.className = 'pagination-ellipsis';
                    ellipsis.textContent = '...';
                    container.appendChild(ellipsis);
                }

                const lastBtn = createPageButton(totalPages, currentPage);
                container.appendChild(lastBtn);
            }

            // 下一页按钮
            const nextBtn = document.createElement('button');
            nextBtn.className = 'pagination-btn pagination-next' + (currentPage === totalPages ? ' disabled' : '');
            nextBtn.innerHTML = '下一页 →';
            nextBtn.onclick = function() {
                if (currentPage < totalPages) {
                    console.log('点击下一页:', currentPage + 1);
                    loadOrders(currentPage + 1);
                }
            };
            container.appendChild(nextBtn);

            // 分页信息
            const info = document.createElement('div');
            info.className = 'pagination-info';
            info.innerHTML = '共 ' + totalCount + ' 条记录，第 ' + currentPage + '/' + totalPages + ' 页';
            container.appendChild(info);
        }

        // 创建页码按钮
        function createPageButton(pageNum, currentPage) {
            const btn = document.createElement('button');
            btn.className = 'pagination-btn' + (pageNum === currentPage ? ' active' : '');
            btn.textContent = pageNum;
            btn.onclick = function() {
                console.log('点击页码:', pageNum);
                loadOrders(pageNum);
            };
            return btn;
        }

        // 搜索订单
        function searchOrders() {
            loadOrders(1);
        }

        // 重置筛选器
        function resetFilters() {
            document.getElementById('orderStatusFilter').value = '';
            document.getElementById('paymentStatusFilter').value = '';
            document.getElementById('startDateFilter').value = '';
            document.getElementById('endDateFilter').value = '';
            document.getElementById('searchKeyword').value = '';
            loadOrders(1);
        }



        // 查看订单详情
        function viewOrder(orderNo) {
            window.open('${pageContext.request.contextPath}/order/admin/detail/' + orderNo, '_blank');
        }

        // 根据订单号查找订单
        function findOrderByNo(orderNo) {
            const tbody = document.getElementById('orderTableBody');
            const rows = tbody.querySelectorAll('tr');

            for (let row of rows) {
                const orderNoCell = row.cells[0].textContent.trim();
                if (orderNoCell === orderNo) {
                    // 从行的数据属性中获取订单ID，如果没有则从全局数据中查找
                    const orderId = row.dataset.orderId;
                    if (orderId) {
                        return { id: orderId, orderNo: orderNo };
                    }
                }
            }

            // 如果从DOM中找不到，尝试从全局数据中查找
            if (window.currentOrdersData) {
                return window.currentOrdersData.find(order => order.orderNo === orderNo);
            }

            return null;
        }

        // 入住订单
        function checkInOrder(orderNo) {
            if (confirm('确定要办理入住吗？')) {
                // 根据订单号获取订单ID
                const order = findOrderByNo(orderNo);
                if (!order) {
                    alert('订单不存在');
                    return;
                }

                fetch('${pageContext.request.contextPath}/order/checkIn', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'orderId=' + order.id
                })
                .then(response => response.json())
                .then(result => {
                    if (result.code === 200) {
                        alert('入住办理成功');
                        loadOrders(currentPage);
                    } else {
                        alert('入住办理失败: ' + result.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('入住办理失败');
                });
            }
        }

        // 完成订单
        function completeOrder(orderNo) {
            if (confirm('确定要完成这个订单吗？')) {
                // 根据订单号获取订单ID
                const order = findOrderByNo(orderNo);
                if (!order) {
                    alert('订单不存在');
                    return;
                }

                fetch('${pageContext.request.contextPath}/order/complete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'orderId=' + order.id
                })
                .then(response => response.json())
                .then(result => {
                    if (result.code === 200) {
                        alert('订单完成成功');
                        loadOrders(currentPage);
                    } else {
                        alert('订单完成失败: ' + result.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('订单完成失败');
                });
            }
        }















        // 显示订单详情
        function showOrderDetail(orderId) {
            fetch(`${pageContext.request.contextPath}/orders/${orderId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        renderOrderDetail(data.data);
                        new bootstrap.Modal(document.getElementById('orderDetailModal')).show();
                    } else {
                        alert('获取订单详情失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('获取订单详情失败:', error);
                    alert('获取订单详情失败');
                });
        }

        // 渲染订单详情
        function renderOrderDetail(order) {
            const content = document.getElementById('orderDetailContent');
            content.innerHTML =
                '<div class="row">' +
                    '<div class="col-md-6">' +
                        '<h6>订单信息</h6>' +
                        '<p><strong>订单号:</strong> ' + order.orderNo + '</p>' +
                        '<p><strong>创建时间:</strong> ' + formatDateTime(order.createTime) + '</p>' +
                        '<p><strong>订单状态:</strong> ' +
                            '<span class="badge ' + getOrderStatusClass(order.orderStatus) + '">' + getOrderStatusText(order.orderStatus) + '</span>' +
                        '</p>' +
                        '<p><strong>支付状态:</strong> ' +
                            '<span class="badge ' + getPaymentStatusClass(order.paymentStatus) + '">' + getPaymentStatusText(order.paymentStatus) + '</span>' +
                        '</p>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<h6>住宿信息</h6>' +
                        '<p><strong>房源名称:</strong> ' + (order.room ? order.room.roomName : '-') + '</p>' +
                        '<p><strong>入住日期:</strong> ' + order.checkInDate + '</p>' +
                        '<p><strong>退房日期:</strong> ' + order.checkOutDate + '</p>' +
                        '<p><strong>住宿天数:</strong> ' + order.nights + '晚</p>' +
                        '<p><strong>入住人数:</strong> ' + order.guests + '人</p>' +
                        '<p><strong>总金额:</strong> ¥' + order.totalPrice.toFixed(2) + '</p>' +
                    '</div>' +
                '</div>' +
                '<div class="row">' +
                    '<div class="col-md-12">' +
                        '<h6>联系信息</h6>' +
                        '<p><strong>联系人:</strong> ' + order.contactName + '</p>' +
                        '<p><strong>联系电话:</strong> ' + order.contactPhone + '</p>' +
                        '<p><strong>联系邮箱:</strong> ' + (order.contactEmail || '-') + '</p>' +
                        (order.specialRequests ? '<p><strong>特殊要求:</strong> ' + order.specialRequests + '</p>' : '') +
                    '</div>' +
                '</div>';
            
            // 生成操作按钮
            const actions = document.getElementById('orderActions');
            actions.innerHTML = '';
            
            if (order.orderStatus === 0) {
                actions.innerHTML =
                    '<button type="button" class="btn btn-success me-2" onclick="confirmOrder(' + order.id + ')">' +
                        '<i class="bi bi-check"></i> 确认订单' +
                    '</button>' +
                    '<button type="button" class="btn btn-danger" onclick="cancelOrder(' + order.id + ')">' +
                        '<i class="bi bi-x"></i> 取消订单' +
                    '</button>';
            }
        }

        // 确认订单
        function confirmOrder(orderNoOrId) {
            if (!confirm('确定要确认该订单吗？')) {
                return;
            }

            // 如果传入的是订单号，需要转换为订单ID
            let orderId = orderNoOrId;
            if (typeof orderNoOrId === 'string') {
                const order = findOrderByNo(orderNoOrId);
                if (!order) {
                    alert('订单不存在');
                    return;
                }
                orderId = order.id;
            }

            fetch(`${pageContext.request.contextPath}/order/confirm`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'orderId=' + orderId
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('订单确认成功');
                    const modal = document.getElementById('orderDetailModal');
                    if (modal && bootstrap.Modal.getInstance(modal)) {
                        bootstrap.Modal.getInstance(modal).hide();
                    }
                    loadOrders(currentPage);
                } else {
                    alert('确认订单失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('确认订单失败:', error);
                alert('确认订单失败');
            });
        }

        // 取消订单
        function cancelOrder(orderNoOrId) {
            const reason = prompt('请输入取消原因:');
            if (!reason) {
                return;
            }

            // 如果传入的是订单号，需要转换为订单ID
            let orderId = orderNoOrId;
            if (typeof orderNoOrId === 'string') {
                const order = findOrderByNo(orderNoOrId);
                if (!order) {
                    alert('订单不存在');
                    return;
                }
                orderId = order.id;
            }

            const params = new URLSearchParams();
            params.append('orderId', orderId);
            params.append('cancelReason', reason);

            fetch(`${pageContext.request.contextPath}/order/admin/cancel`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('订单取消成功');
                    const modal = document.getElementById('orderDetailModal');
                    if (modal && bootstrap.Modal.getInstance(modal)) {
                        bootstrap.Modal.getInstance(modal).hide();
                    }
                    loadOrders(currentPage);
                } else {
                    alert('取消订单失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('取消订单失败:', error);
                alert('取消订单失败');
            });
        }

        // 导出订单
        function exportOrders() {
            const orderStatus = document.getElementById('orderStatusFilter').value;
            const paymentStatus = document.getElementById('paymentStatusFilter').value;
            const startDate = document.getElementById('startDateFilter').value;
            const endDate = document.getElementById('endDateFilter').value;
            const keyword = document.getElementById('searchKeyword').value;

            const params = new URLSearchParams();
            if (orderStatus) params.append('orderStatus', orderStatus);
            if (paymentStatus) params.append('paymentStatus', paymentStatus);
            if (startDate) params.append('startDate', startDate);
            if (endDate) params.append('endDate', endDate);
            if (keyword) params.append('keyword', keyword);

            window.open('${pageContext.request.contextPath}/orders/export?' + params);
        }

        // 页面加载完成后执行
        document.addEventListener('DOMContentLoaded', function() {
            loadOrders(1);
            
            // 绑定回车搜索
            document.getElementById('searchKeyword').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchOrders();
                }
            });
        });
    </script>
</body>
</html>
