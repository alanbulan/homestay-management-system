<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📋 订单详情 - HMS 管理后台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/background.css">
    <style>
        body {
            padding: 0;
        }

        /* 返回按钮 */
        .back-button {
            position: fixed;
            top: var(--spacing-lg);
            left: var(--spacing-lg);
            z-index: 1000;
        }

        .back-btn {
            background: var(--bg-primary);
            color: var(--text-primary);
            border: 2px solid var(--border-color);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: var(--spacing-xs);
            font-size: var(--font-size-sm);
            font-weight: 500;
            box-shadow: var(--shadow-light);
            transition: all var(--transition-normal);
        }

        .back-btn:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-1px);
            box-shadow: var(--shadow-medium);
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
            max-width: 1000px;
            margin: 0 auto;
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

        .btn-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #218838, #28a745);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-warning {
            background: linear-gradient(135deg, #ffc107, #ffca2c);
            color: #212529;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #e0a800, #ffc107);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .back-button {
            margin-bottom: var(--spacing-lg);
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
    <!-- 返回按钮 -->
    <div class="back-button">
        <a href="${pageContext.request.contextPath}/admin/orders" class="back-btn">
            ← 返回订单管理
        </a>
    </div>

    <div class="main-content">
        <div class="order-container">
                <div class="order-header">
                    <h1 class="order-title">📋 订单详情</h1>
                    <div class="order-number">订单号：${order.orderNo}</div>
                </div>

                <div class="order-content">
                    <div class="order-status-bar">
                        <div class="status-badge <c:choose>
                            <c:when test='${order.orderStatus == 0}'>status-pending</c:when>
                            <c:when test='${order.orderStatus == 1}'>status-confirmed</c:when>
                            <c:when test='${order.orderStatus == 2}'>status-checked-in</c:when>
                            <c:when test='${order.orderStatus == 3}'>status-completed</c:when>
                            <c:when test='${order.orderStatus == 4}'>status-cancelled</c:when>
                        </c:choose>">
                            <c:choose>
                                <c:when test="${order.orderStatus == 0}">待确认</c:when>
                                <c:when test="${order.orderStatus == 1}">已确认</c:when>
                                <c:when test="${order.orderStatus == 2}">已入住</c:when>
                                <c:when test="${order.orderStatus == 3}">已完成</c:when>
                                <c:when test="${order.orderStatus == 4}">已取消</c:when>
                            </c:choose>
                        </div>
                    </div>

                    <div class="order-sections">
                        <!-- 房源信息 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">🏠 房源信息</h3>
                            </div>
                            <div class="section-content">
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">房源名称</div>
                                        <div class="info-value">${order.room.roomName}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">房源类型</div>
                                        <div class="info-value">${order.room.roomType}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">房源地址</div>
                                        <div class="info-value">${order.room.address}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">每晚价格</div>
                                        <div class="info-value">¥${order.room.pricePerNight}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 预订信息 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">📅 预订信息</h3>
                            </div>
                            <div class="section-content">
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">入住日期</div>
                                        <div class="info-value">${order.checkInDate}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">退房日期</div>
                                        <div class="info-value">${order.checkOutDate}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">入住天数</div>
                                        <div class="info-value">${order.nights}晚</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">入住人数</div>
                                        <div class="info-value">${order.guests}人</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">下单时间</div>
                                        <div class="info-value">${order.createTime}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">特殊要求</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty order.specialRequests}">
                                                    ${order.specialRequests}
                                                </c:when>
                                                <c:otherwise>无</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 联系信息 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">👤 联系信息</h3>
                            </div>
                            <div class="section-content">
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">联系人</div>
                                        <div class="info-value">${order.contactName}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">联系电话</div>
                                        <div class="info-value">${order.contactPhone}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">联系邮箱</div>
                                        <div class="info-value">${order.contactEmail}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">用户名</div>
                                        <div class="info-value">${order.user.username}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">真实姓名</div>
                                        <div class="info-value">${order.user.realName}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">用户邮箱</div>
                                        <div class="info-value">${order.user.email}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 费用明细 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">💰 费用明细</h3>
                            </div>
                            <div class="section-content">
                                <div class="price-summary">
                                    <div class="price-row">
                                        <span>房费 (${order.nights}晚 × ¥${order.room.pricePerNight})</span>
                                        <span>¥${order.totalPrice}</span>
                                    </div>
                                    <div class="price-row total">
                                        <span>订单总金额</span>
                                        <span>¥${order.totalPrice}</span>
                                    </div>
                                    <div style="margin-top: var(--spacing-md); padding-top: var(--spacing-md); border-top: 1px solid var(--border-color);">
                                        <div class="info-item">
                                            <div class="info-label">支付状态</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${order.paymentStatus == 0}">未支付</c:when>
                                                    <c:when test="${order.paymentStatus == 1}">已支付</c:when>
                                                    <c:when test="${order.paymentStatus == 2}">已退款</c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <c:if test="${not empty order.paymentTime}">
                                            <div class="info-item">
                                                <div class="info-label">支付时间</div>
                                                <div class="info-value">${order.paymentTime}</div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty order.cancelTime or not empty order.cancelReason}">
                        <!-- 取消信息 -->
                        <div class="order-section">
                            <div class="section-header">
                                <h3 class="section-title">❌ 取消信息</h3>
                            </div>
                            <div class="section-content">
                                <div class="info-grid">
                                    <c:if test="${not empty order.cancelTime}">
                                        <div class="info-item">
                                            <div class="info-label">取消时间</div>
                                            <div class="info-value">${order.cancelTime}</div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty order.cancelReason}">
                                        <div class="info-item">
                                            <div class="info-label">取消原因</div>
                                            <div class="info-value">${order.cancelReason}</div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        </c:if>
                    </div>

                    <!-- 操作按钮 -->
                    <div class="order-actions">
                        <c:if test="${order.orderStatus == 0}">
                            <button class="btn btn-success" onclick="confirmOrder('${order.orderNo}')">
                                ✅ 确认订单
                            </button>
                        </c:if>
                        <c:if test="${order.orderStatus == 1}">
                            <button class="btn btn-warning" onclick="checkInOrder('${order.orderNo}')">
                                🚪 办理入住
                            </button>
                        </c:if>
                        <c:if test="${order.orderStatus == 2}">
                            <button class="btn btn-primary" onclick="completeOrder('${order.orderNo}')">
                                ✅ 完成订单
                            </button>
                        </c:if>
                        <c:if test="${order.orderStatus != 4 && order.orderStatus != 3}">
                            <button class="btn btn-danger" onclick="cancelOrder('${order.orderNo}')">
                                ❌ 取消订单
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 确认订单
        function confirmOrder(orderNo) {
            if (confirm('确定要确认该订单吗？')) {
                fetch('${pageContext.request.contextPath}/order/confirm', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'orderId=${order.id}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        alert('订单确认成功');
                        location.reload();
                    } else {
                        alert('确认订单失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('确认订单失败:', error);
                    alert('确认订单失败');
                });
            }
        }

        // 办理入住
        function checkInOrder(orderNo) {
            if (confirm('确定要办理入住吗？')) {
                fetch('${pageContext.request.contextPath}/order/checkIn', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'orderId=${order.id}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        alert('入住办理成功');
                        location.reload();
                    } else {
                        alert('入住办理失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('入住办理失败:', error);
                    alert('入住办理失败');
                });
            }
        }

        // 完成订单
        function completeOrder(orderNo) {
            if (confirm('确定要完成这个订单吗？')) {
                fetch('${pageContext.request.contextPath}/order/complete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'orderId=${order.id}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        alert('订单完成成功');
                        location.reload();
                    } else {
                        alert('订单完成失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('订单完成失败:', error);
                    alert('订单完成失败');
                });
            }
        }

        // 取消订单
        function cancelOrder(orderNo) {
            const reason = prompt('请输入取消原因:');
            if (!reason) {
                return;
            }

            const params = new URLSearchParams();
            params.append('orderId', '${order.id}');
            params.append('cancelReason', reason);

            fetch('${pageContext.request.contextPath}/order/admin/cancel', {
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
                    location.reload();
                } else {
                    alert('取消订单失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('取消订单失败:', error);
                alert('取消订单失败');
            });
        }
    </script>
</body>
</html>
