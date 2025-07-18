<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🏠 房源详情 - HMS</title>
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
            grid-template-columns: 2fr 1fr;
            gap: var(--spacing-2xl);
        }
        
        /* 房源信息区域 */
        .room-info {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            overflow: hidden;
        }
        
        .room-gallery {
            height: 400px;
            background: linear-gradient(135deg, var(--bg-tertiary), var(--border-color));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: var(--text-light);
            position: relative;
            overflow: hidden;
        }
        
        .room-gallery::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(107,115,255,0.1)"/><circle cx="80" cy="40" r="1.5" fill="rgba(255,107,157,0.1)"/><circle cx="40" cy="80" r="1" fill="rgba(78,205,196,0.1)"/></svg>') repeat;
            animation: float 30s infinite linear;
        }
        
        .room-details {
            padding: var(--spacing-2xl);
        }
        
        .room-title {
            font-size: var(--font-size-3xl);
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: var(--spacing-md);
            line-height: 1.2;
        }
        
        .room-location {
            color: var(--text-secondary);
            font-size: var(--font-size-lg);
            margin-bottom: var(--spacing-xl);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
        }
        
        .room-features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-2xl);
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            padding: var(--spacing-md);
            background: var(--bg-secondary);
            border-radius: var(--border-radius);
            border: 1px solid var(--border-color);
        }
        
        .feature-icon {
            font-size: var(--font-size-xl);
        }
        
        .feature-text {
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
        }
        
        .room-description {
            margin-bottom: var(--spacing-2xl);
        }
        
        .section-title {
            font-size: var(--font-size-xl);
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: var(--spacing-lg);
        }
        
        .description-text {
            color: var(--text-secondary);
            line-height: 1.6;
            font-size: var(--font-size-base);
        }
        
        /* 预订卡片 */
        .booking-card {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-medium);
            padding: var(--spacing-2xl);
            position: sticky;
            top: calc(80px + var(--spacing-md));
            height: fit-content;
        }
        
        .booking-header {
            text-align: center;
            margin-bottom: var(--spacing-xl);
            padding-bottom: var(--spacing-lg);
            border-bottom: 1px solid var(--border-color);
        }
        
        .price-display {
            font-size: var(--font-size-3xl);
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: var(--spacing-sm);
        }
        
        .price-unit {
            font-size: var(--font-size-base);
            font-weight: 400;
            color: var(--text-secondary);
        }
        
        .booking-form {
            display: flex;
            flex-direction: column;
            gap: var(--spacing-lg);
        }
        
        .date-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--spacing-md);
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
            margin-bottom: var(--spacing-xs);
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
        
        .guests-selector {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: var(--spacing-md);
            border: 2px solid var(--border-color);
            border-radius: var(--border-radius);
        }
        
        .guests-controls {
            display: flex;
            align-items: center;
            gap: var(--spacing-md);
        }
        
        .guests-btn {
            width: 32px;
            height: 32px;
            border: 1px solid var(--border-color);
            background: var(--bg-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        
        .guests-btn:hover {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }
        
        .guests-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .guests-count {
            font-weight: 600;
            min-width: 20px;
            text-align: center;
        }
        
        .booking-summary {
            padding: var(--spacing-lg);
            background: var(--bg-secondary);
            border-radius: var(--border-radius);
            margin: var(--spacing-lg) 0;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: var(--spacing-sm);
            font-size: var(--font-size-sm);
        }
        
        .summary-row.total {
            font-weight: 600;
            font-size: var(--font-size-base);
            padding-top: var(--spacing-sm);
            border-top: 1px solid var(--border-color);
            margin-top: var(--spacing-sm);
        }
        
        .booking-btn {
            width: 100%;
            padding: var(--spacing-lg);
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-size: var(--font-size-lg);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }
        
        .booking-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left var(--transition-normal);
        }
        
        .booking-btn:hover::before {
            left: 100%;
        }
        
        .booking-btn:hover {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: var(--shadow-heavy);
        }
        
        .booking-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .error-message {
            background: linear-gradient(135deg, #ffe6e6, #ffcccc);
            color: var(--error-color);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-small);
            margin-bottom: var(--spacing-md);
            font-size: var(--font-size-sm);
            border-left: 4px solid var(--error-color);
        }
        
        .success-message {
            background: linear-gradient(135deg, #e6ffe6, #ccffcc);
            color: var(--success-color);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-small);
            margin-bottom: var(--spacing-md);
            font-size: var(--font-size-sm);
            border-left: 4px solid var(--success-color);
        }
        
        /* 响应式 */
        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
                gap: var(--spacing-lg);
            }
            
            .booking-card {
                position: static;
            }
            
            .date-group {
                grid-template-columns: 1fr;
            }
            
            .room-features {
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
        <!-- 房源信息 -->
        <div class="room-info">
            <div class="room-gallery">
                🏠
            </div>
            
            <div class="room-details">
                <h1 class="room-title" id="roomTitle">加载中...</h1>
                <div class="room-location" id="roomLocation">
                    📍 <span>加载中...</span>
                </div>
                
                <div class="room-features" id="roomFeatures">
                    <!-- 动态加载 -->
                </div>
                
                <div class="room-description">
                    <h3 class="section-title">🏠 房源描述</h3>
                    <p class="description-text" id="roomDescription">加载中...</p>
                </div>
            </div>
        </div>
        
        <!-- 预订卡片 -->
        <div class="booking-card">
            <div class="booking-header">
                <div class="price-display">
                    ¥<span id="pricePerNight">0</span>
                    <span class="price-unit">/晚</span>
                </div>
            </div>
            
            <div id="messageContainer"></div>
            
            <form class="booking-form" id="bookingForm">
                <div class="date-group">
                    <div class="form-group">
                        <label class="form-label">📅 入住日期</label>
                        <input type="date" class="form-input" id="checkInDate" name="checkInDate" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">📅 退房日期</label>
                        <input type="date" class="form-input" id="checkOutDate" name="checkOutDate" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">👥 入住人数</label>
                    <div class="guests-selector">
                        <span>入住人数</span>
                        <div class="guests-controls">
                            <button type="button" class="guests-btn" id="guestsDecrease">-</button>
                            <span class="guests-count" id="guestsCount">1</span>
                            <button type="button" class="guests-btn" id="guestsIncrease">+</button>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">👤 联系人姓名</label>
                    <input type="text" class="form-input" id="contactName" name="contactName" placeholder="请输入联系人姓名" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">📱 联系电话</label>
                    <input type="tel" class="form-input" id="contactPhone" name="contactPhone" placeholder="请输入联系电话" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">📧 邮箱地址</label>
                    <input type="email" class="form-input" id="contactEmail" name="contactEmail" placeholder="请输入邮箱地址">
                </div>
                
                <div class="form-group">
                    <label class="form-label">📝 特殊要求</label>
                    <textarea class="form-input" id="specialRequests" name="specialRequests" rows="3" placeholder="请输入特殊要求（可选）"></textarea>
                </div>
                
                <div class="booking-summary" id="bookingSummary" style="display: none;">
                    <div class="summary-row">
                        <span>房费 × <span id="nightsCount">0</span>晚</span>
                        <span>¥<span id="roomFee">0</span></span>
                    </div>
                    <div class="summary-row total">
                        <span>总计</span>
                        <span>¥<span id="totalPrice">0</span></span>
                    </div>
                </div>
                
                <button type="submit" class="booking-btn" id="bookingBtn">
                    ✨ 立即预订
                </button>
            </form>
        </div>
    </div>
    
    <script>
        let currentRoom = null;
        let currentGuests = 1;
        let maxGuests = 1;
        
        // 获取房源ID
        const pathParts = window.location.pathname.split('/');
        const roomId = pathParts[pathParts.length - 1];
        
        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadRoomDetail();
            initializeDateInputs();
            initializeGuestsControls();
            initializeFormValidation();
        });
        
        // 加载房源详情
        async function loadRoomDetail() {
            try {
                const response = await fetch('<%= request.getContextPath() %>/room/detail/' + roomId + '/api');
                const data = await response.json();
                
                if (data.code === 200) {
                    currentRoom = data.data;
                    displayRoomDetail(currentRoom);
                } else {
                    showMessage('房源信息加载失败：' + data.message, 'error');
                }
            } catch (error) {
                console.error('加载房源详情失败:', error);
                showMessage('网络错误，请稍后重试', 'error');
            }
        }
        
        // 显示房源详情
        function displayRoomDetail(room) {
            document.getElementById('roomTitle').textContent = room.roomName || '未命名房源';
            document.getElementById('roomLocation').innerHTML = '📍 <span>' + (room.city || '') + (room.district ? ' · ' + room.district : '') + '</span>';
            document.getElementById('roomDescription').textContent = room.description || '暂无描述';
            document.getElementById('pricePerNight').textContent = room.pricePerNight || 0;

            // 设置最大人数并更新按钮状态
            maxGuests = room.maxGuests || 1;
            console.log('设置最大人数:', maxGuests);

            // 重新初始化人数控制
            updateGuestsButtons();

            // 显示房源图片
            displayRoomImages(room.images);
            
            // 显示房源特性
            const featuresContainer = document.getElementById('roomFeatures');
            featuresContainer.innerHTML =
                '<div class="feature-item">' +
                    '<span class="feature-icon">🏠</span>' +
                    '<div>' +
                        '<div><strong>' + (room.roomType || '未知房型') + '</strong></div>' +
                        '<div class="feature-text">房型</div>' +
                    '</div>' +
                '</div>' +
                '<div class="feature-item">' +
                    '<span class="feature-icon">👥</span>' +
                    '<div>' +
                        '<div><strong>最多' + (room.maxGuests != null ? room.maxGuests : 0) + '人</strong></div>' +
                        '<div class="feature-text">入住人数</div>' +
                    '</div>' +
                '</div>' +
                '<div class="feature-item">' +
                    '<span class="feature-icon">💰</span>' +
                    '<div>' +
                        '<div><strong>¥' + (room.pricePerNight != null ? room.pricePerNight : 0) + '</strong></div>' +
                        '<div class="feature-text">每晚价格</div>' +
                    '</div>' +
                '</div>' +
                '<div class="feature-item">' +
                    '<span class="feature-icon">📍</span>' +
                    '<div>' +
                        '<div><strong>' + (room.address || '地址未知') + '</strong></div>' +
                        '<div class="feature-text">详细地址</div>' +
                    '</div>' +
                '</div>';
        }

        // 显示房源图片
        function displayRoomImages(images) {
            const gallery = document.querySelector('.room-gallery');

            if (!images || images.length === 0) {
                gallery.innerHTML = '🏠';
                return;
            }

            // 创建图片轮播
            let currentImageIndex = 0;

            function updateGallery() {
                const image = images[currentImageIndex];
                gallery.innerHTML =
                    '<img src="' + image.imageUrl + '" alt="' + (image.imageName || '房源图片') + '" ' +
                    'style="width: 100%; height: 100%; object-fit: cover; position: relative; z-index: 1;" ' +
                    'onerror="this.style.display=\'none\'; this.parentNode.innerHTML=\'🏠\';">' +
                    (images.length > 1 ?
                        '<div style="position: absolute; bottom: 10px; right: 10px; background: rgba(0,0,0,0.7); color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px; z-index: 2;">' +
                            (currentImageIndex + 1) + ' / ' + images.length +
                        '</div>' +
                        '<button onclick="previousImage()" style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); background: rgba(0,0,0,0.5); color: white; border: none; border-radius: 50%; width: 40px; height: 40px; cursor: pointer; z-index: 2;">‹</button>' +
                        '<button onclick="nextImage()" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: rgba(0,0,0,0.5); color: white; border: none; border-radius: 50%; width: 40px; height: 40px; cursor: pointer; z-index: 2;">›</button>'
                        : ''
                    );
            }

            window.nextImage = function() {
                currentImageIndex = (currentImageIndex + 1) % images.length;
                updateGallery();
            };

            window.previousImage = function() {
                currentImageIndex = (currentImageIndex - 1 + images.length) % images.length;
                updateGallery();
            };

            updateGallery();

            // 自动轮播（如果有多张图片）
            if (images.length > 1) {
                setInterval(() => {
                    window.nextImage();
                }, 5000);
            }
        }

        // 初始化日期输入
        function initializeDateInputs() {
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            
            const checkInInput = document.getElementById('checkInDate');
            const checkOutInput = document.getElementById('checkOutDate');
            
            checkInInput.min = today.toISOString().split('T')[0];
            checkInInput.value = today.toISOString().split('T')[0];
            
            checkOutInput.min = tomorrow.toISOString().split('T')[0];
            checkOutInput.value = tomorrow.toISOString().split('T')[0];
            
            // 监听日期变化
            checkInInput.addEventListener('change', function() {
                const checkInDate = new Date(this.value);
                const nextDay = new Date(checkInDate);
                nextDay.setDate(nextDay.getDate() + 1);
                
                checkOutInput.min = nextDay.toISOString().split('T')[0];
                if (new Date(checkOutInput.value) <= checkInDate) {
                    checkOutInput.value = nextDay.toISOString().split('T')[0];
                }
                updateBookingSummary();
            });
            
            checkOutInput.addEventListener('change', updateBookingSummary);
        }
        
        // 初始化人数控制
        function initializeGuestsControls() {
            const decreaseBtn = document.getElementById('guestsDecrease');
            const increaseBtn = document.getElementById('guestsIncrease');
            const countSpan = document.getElementById('guestsCount');

            if (!decreaseBtn || !increaseBtn || !countSpan) {
                console.error('人数控制元素未找到');
                return;
            }

            console.log('初始化人数控制，当前人数:', currentGuests, '最大人数:', maxGuests);

            decreaseBtn.addEventListener('click', function(e) {
                e.preventDefault();
                console.log('点击减少按钮，当前人数:', currentGuests);
                if (currentGuests > 1) {
                    currentGuests--;
                    countSpan.textContent = currentGuests;
                    updateGuestsButtons();
                    updateBookingSummary();
                    console.log('减少后人数:', currentGuests);
                }
            });

            increaseBtn.addEventListener('click', function(e) {
                e.preventDefault();
                console.log('点击增加按钮，当前人数:', currentGuests, '最大人数:', maxGuests);
                if (currentGuests < maxGuests) {
                    currentGuests++;
                    countSpan.textContent = currentGuests;
                    updateGuestsButtons();
                    updateBookingSummary();
                    console.log('增加后人数:', currentGuests);
                } else {
                    console.log('已达到最大人数限制');
                }
            });

            // 初始化显示
            countSpan.textContent = currentGuests;
            // 注意：此时maxGuests可能还是默认值1，真正的值会在loadRoomDetail后设置
        }
        
        // 更新人数按钮状态
        function updateGuestsButtons() {
            const decreaseBtn = document.getElementById('guestsDecrease');
            const increaseBtn = document.getElementById('guestsIncrease');

            if (!decreaseBtn || !increaseBtn) {
                console.error('按钮元素未找到');
                return;
            }

            console.log('更新按钮状态 - 当前人数:', currentGuests, '最大人数:', maxGuests);

            // 更新按钮禁用状态
            const shouldDisableDecrease = currentGuests <= 1;
            const shouldDisableIncrease = currentGuests >= maxGuests;

            decreaseBtn.disabled = shouldDisableDecrease;
            increaseBtn.disabled = shouldDisableIncrease;

            console.log('减少按钮禁用:', shouldDisableDecrease, '增加按钮禁用:', shouldDisableIncrease);

            // 更新按钮样式
            if (shouldDisableDecrease) {
                decreaseBtn.style.opacity = '0.5';
                decreaseBtn.style.cursor = 'not-allowed';
            } else {
                decreaseBtn.style.opacity = '1';
                decreaseBtn.style.cursor = 'pointer';
            }

            if (shouldDisableIncrease) {
                increaseBtn.style.opacity = '0.5';
                increaseBtn.style.cursor = 'not-allowed';
            } else {
                increaseBtn.style.opacity = '1';
                increaseBtn.style.cursor = 'pointer';
            }
        }
        
        // 更新预订摘要
        function updateBookingSummary() {
            const checkInDate = document.getElementById('checkInDate').value;
            const checkOutDate = document.getElementById('checkOutDate').value;
            
            if (!checkInDate || !checkOutDate || !currentRoom) return;
            
            const checkIn = new Date(checkInDate);
            const checkOut = new Date(checkOutDate);
            const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
            
            if (nights > 0) {
                const roomFee = currentRoom.pricePerNight * nights;
                const totalPrice = roomFee;
                
                document.getElementById('nightsCount').textContent = nights;
                document.getElementById('roomFee').textContent = roomFee;
                document.getElementById('totalPrice').textContent = totalPrice;
                document.getElementById('bookingSummary').style.display = 'block';
            } else {
                document.getElementById('bookingSummary').style.display = 'none';
            }
        }
        
        // 初始化表单验证
        function initializeFormValidation() {
            document.getElementById('bookingForm').addEventListener('submit', function(e) {
                e.preventDefault();
                submitBooking();
            });
        }
        
        // 提交预订
        async function submitBooking() {
            const checkInDate = document.getElementById('checkInDate').value;
            const checkOutDate = document.getElementById('checkOutDate').value;
            const contactName = document.getElementById('contactName').value;
            const contactPhone = document.getElementById('contactPhone').value;
            const contactEmail = document.getElementById('contactEmail').value;
            const specialRequests = document.getElementById('specialRequests').value;
            
            // 基本验证
            if (!checkInDate || !checkOutDate || !contactName || !contactPhone) {
                showMessage('请填写完整的预订信息', 'error');
                return;
            }
            
            const bookingBtn = document.getElementById('bookingBtn');
            bookingBtn.disabled = true;
            bookingBtn.textContent = '🔄 预订中...';
            
            try {
                const orderData = {
                    roomId: parseInt(roomId),
                    checkInDate: checkInDate,
                    checkOutDate: checkOutDate,
                    guests: currentGuests,
                    contactName: contactName,
                    contactPhone: contactPhone,
                    contactEmail: contactEmail,
                    specialRequests: specialRequests
                };
                
                const response = await fetch('<%= request.getContextPath() %>/order/create', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(orderData)
                });
                
                const data = await response.json();
                
                if (data.code === 200) {
                    showMessage('预订成功！正在跳转到订单详情...', 'success');
                    setTimeout(() => {
                        window.location.href = '<%= request.getContextPath() %>/order/detail/' + data.data.id;
                    }, 2000);
                } else {
                    showMessage(data.message || '预订失败', 'error');
                }
            } catch (error) {
                console.error('预订失败:', error);
                showMessage('网络错误，请稍后重试', 'error');
            } finally {
                bookingBtn.disabled = false;
                bookingBtn.textContent = '✨ 立即预订';
            }
        }
        
        // 显示消息
        function showMessage(message, type) {
            const container = document.getElementById('messageContainer');
            const messageDiv = document.createElement('div');
            messageDiv.className = type === 'error' ? 'error-message' : 'success-message';
            messageDiv.textContent = message;
            
            container.innerHTML = '';
            container.appendChild(messageDiv);
            
            setTimeout(() => {
                if (messageDiv.parentNode) {
                    messageDiv.remove();
                }
            }, 5000);
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
