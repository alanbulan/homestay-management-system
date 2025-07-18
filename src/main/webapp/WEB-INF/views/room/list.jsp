<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🏡 房源列表 - HMS</title>
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
        
        /* 搜索区域 - 强制应用统一的筛选器样式 */
        .search-section {
            background: #ffffff !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 12px !important;
            padding: 24px !important;
            margin: 24px auto !important;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
            max-width: 1200px;
        }

        .search-title {
            font-size: 18px !important;
            font-weight: 600 !important;
            color: #1a202c !important;
            margin-bottom: 16px !important;
            display: flex !important;
            align-items: center !important;
            gap: 8px !important;
            text-align: center !important;
            justify-content: center !important;
        }

        .search-form {
            display: grid !important;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)) !important;
            gap: 12px !important;
            margin-bottom: 16px !important;
        }

        .search-group {
            display: flex !important;
            flex-direction: column !important;
        }

        .search-label {
            font-size: 16px !important;
            color: #718096 !important;
            margin-bottom: 8px !important;
            font-weight: 500 !important;
        }

        .search-input {
            width: 100% !important;
            padding: 10px 12px !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 4px !important;
            font-size: 16px !important;
            background: #ffffff !important;
            color: #1a202c !important;
            transition: all 0.15s ease !important;
            min-height: 40px !important;
        }

        .search-input:focus {
            outline: none !important;
            border-color: #667eea !important;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1) !important;
        }

        .search-actions {
            display: flex !important;
            gap: 8px !important;
            justify-content: flex-end !important;
            margin-top: 16px !important;
        }

        .search-btn {
            padding: 10px 24px !important;
            background: linear-gradient(135deg, #667eea, #8fa4f3) !important;
            color: white !important;
            border: none !important;
            border-radius: 8px !important;
            font-size: 16px !important;
            font-weight: 500 !important;
            cursor: pointer !important;
            transition: all 0.3s ease !important;
            min-width: 120px !important;
        }

        .search-btn:hover {
            background: linear-gradient(135deg, #5a6fd8, #667eea) !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15) !important;
        }

        .reset-btn {
            padding: 10px 24px !important;
            background: #f7fafc !important;
            color: #718096 !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 8px !important;
            font-size: 16px !important;
            font-weight: 500 !important;
            cursor: pointer !important;
            transition: all 0.3s ease !important;
            min-width: 120px !important;
        }

        .reset-btn:hover {
            border-color: #667eea !important;
            color: #667eea !important;
        }
        
        /* 房源网格 */
        .rooms-section {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--spacing-md);
        }
        
        .rooms-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-xl);
        }
        
        .rooms-title {
            color: var(--text-primary);
            font-size: var(--font-size-xl);
            font-weight: 600;
        }
        
        .rooms-count {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }
        
        .rooms-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: var(--spacing-xl);
            margin-bottom: var(--spacing-2xl);
        }
        
        .room-card {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-light);
            overflow: hidden;
            transition: all var(--transition-normal);
            cursor: pointer;
        }
        
        .room-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
        }
        
        .room-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, var(--bg-tertiary), var(--border-color));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: var(--font-size-3xl);
            color: var(--text-light);
            position: relative;
            overflow: hidden;
        }
        
        .room-image::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="1" fill="rgba(107,115,255,0.1)"/><circle cx="80" cy="40" r="1.5" fill="rgba(255,107,157,0.1)"/><circle cx="40" cy="80" r="1" fill="rgba(78,205,196,0.1)"/></svg>') repeat;
            animation: float 20s infinite linear;
        }
        
        .room-content {
            padding: var(--spacing-lg);
        }
        
        .room-title {
            font-size: var(--font-size-lg);
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: var(--spacing-sm);
            line-height: 1.4;
        }
        
        .room-location {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
            margin-bottom: var(--spacing-md);
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
        }
        
        .room-features {
            display: flex;
            gap: var(--spacing-md);
            margin-bottom: var(--spacing-md);
            font-size: var(--font-size-sm);
            color: var(--text-secondary);
        }
        
        .room-feature {
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
        }
        
        .room-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: var(--spacing-md);
            border-top: 1px solid var(--border-color);
        }
        
        .room-price {
            font-size: var(--font-size-lg);
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .room-price-unit {
            font-size: var(--font-size-sm);
            font-weight: 400;
            color: var(--text-secondary);
        }
        
        .room-btn {
            padding: var(--spacing-sm) var(--spacing-lg);
            background: linear-gradient(135deg, var(--accent-color), var(--primary-light));
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-size: var(--font-size-sm);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        
        .room-btn:hover {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            transform: translateY(-1px);
        }
        
        /* 加载状态 */
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
        
        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: var(--spacing-2xl);
            color: var(--text-secondary);
        }
        
        .empty-icon {
            font-size: 4rem;
            margin-bottom: var(--spacing-lg);
            opacity: 0.5;
        }
        

        
        /* 响应式 */
        @media (max-width: 768px) {
            .search-form {
                grid-template-columns: 1fr;
            }

            .search-actions {
                flex-direction: column;
            }

            .rooms-grid {
                grid-template-columns: 1fr;
            }

            .navbar-content {
                flex-direction: column;
                gap: var(--spacing-md);
            }
            
            .rooms-header {
                flex-direction: column;
                gap: var(--spacing-sm);
                text-align: center;
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
    
    <!-- 搜索区域 -->
    <div class="search-section">
        <h1 class="search-title">
            🔍 寻找您的理想住所
        </h1>
        <form class="search-form" id="searchForm">
            <div class="search-group">
                <label class="search-label">🏙️ 所在城市</label>
                <select class="search-input" id="city" name="city">
                    <option value="">全部城市</option>
                </select>
            </div>

            <div class="search-group">
                <label class="search-label">📍 所在区域</label>
                <select class="search-input" id="district" name="district">
                    <option value="">全部区域</option>
                </select>
            </div>

            <div class="search-group">
                <label class="search-label">🏠 房源类型</label>
                <select class="search-input" id="roomType" name="roomType">
                    <option value="">全部房型</option>
                </select>
            </div>

            <div class="search-group">
                <label class="search-label">💰 最低价格</label>
                <input type="number" class="search-input" id="minPrice" name="minPrice" placeholder="请输入最低价格" min="0">
            </div>

            <div class="search-group">
                <label class="search-label">💰 最高价格</label>
                <input type="number" class="search-input" id="maxPrice" name="maxPrice" placeholder="请输入最高价格" min="0">
            </div>

            <div class="search-group">
                <label class="search-label">👥 入住人数</label>
                <select class="search-input" id="maxGuests" name="maxGuests">
                    <option value="">不限人数</option>
                    <option value="1">1人</option>
                    <option value="2">2人</option>
                    <option value="3">3人</option>
                    <option value="4">4人</option>
                    <option value="5">5人以上</option>
                </select>
            </div>

            <div class="search-group">
                <label class="search-label">🔍 搜索关键词</label>
                <input type="text" class="search-input" id="keyword" name="keyword" placeholder="房源名称或地址">
            </div>
        </form>
        <div class="search-actions">
            <button type="submit" form="searchForm" class="search-btn">
                🔍 搜索房源
            </button>
            <button type="button" class="reset-btn" onclick="resetSearchForm()">
                🔄 重置条件
            </button>
        </div>
    </div>
    
    <!-- 房源列表 -->
    <div class="rooms-section">
        <div class="rooms-header">
            <h2 class="rooms-title">🏡 房源列表</h2>
            <div class="rooms-count" id="roomsCount">正在加载...</div>
        </div>
        
        <div id="roomsContainer">
            <div class="loading">
                <div class="loading-spinner"></div>
                <div>正在加载房源信息...</div>
            </div>
        </div>
        

    </div>
    
    <script>
        // 获取上下文路径
        const contextPath = '<%= request.getContextPath() %>';

        let currentPage = 1;
        let currentFilters = {};

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadFilterOptions();
            loadRooms();
            
            // 搜索表单提交
            document.getElementById('searchForm').addEventListener('submit', function(e) {
                e.preventDefault();
                currentPage = 1;
                loadRooms();
            });
            
            // 城市选择变化时加载区域
            document.getElementById('city').addEventListener('change', function() {
                loadDistricts(this.value);
            });
        });
        
        // 重置搜索表单
        function resetSearchForm() {
            document.getElementById('searchForm').reset();
            document.getElementById('district').innerHTML = '<option value="">全部区域</option>';
            currentPage = 1;
            loadRooms();
        }

        // 加载筛选选项
        async function loadFilterOptions() {
            try {
                // 加载城市
                const citiesResponse = await fetch(contextPath + '/room/cities');
                const citiesData = await citiesResponse.json();
                if (citiesData.code === 200) {
                    const citySelect = document.getElementById('city');
                    citiesData.data.forEach(city => {
                        const option = document.createElement('option');
                        option.value = city;
                        option.textContent = city;
                        citySelect.appendChild(option);
                    });
                }

                // 加载房型
                const typesResponse = await fetch(contextPath + '/room/types');
                const typesData = await typesResponse.json();
                if (typesData.code === 200) {
                    const typeSelect = document.getElementById('roomType');
                    typesData.data.forEach(type => {
                        const option = document.createElement('option');
                        option.value = type;
                        option.textContent = type;
                        typeSelect.appendChild(option);
                    });
                }
            } catch (error) {
                console.error('加载筛选选项失败:', error);
            }
        }
        
        // 加载区域
        async function loadDistricts(city) {
            const districtSelect = document.getElementById('district');
            districtSelect.innerHTML = '<option value="">全部区域</option>';
            
            if (!city) return;
            
            try {
                const response = await fetch(contextPath + '/room/districts?city=' + encodeURIComponent(city));
                const data = await response.json();
                if (data.code === 200) {
                    data.data.forEach(district => {
                        const option = document.createElement('option');
                        option.value = district;
                        option.textContent = district;
                        districtSelect.appendChild(option);
                    });
                }
            } catch (error) {
                console.error('加载区域失败:', error);
            }
        }
        
        // 加载房源
        async function loadRooms() {
            const container = document.getElementById('roomsContainer');
            const countElement = document.getElementById('roomsCount');
            
            // 显示加载状态
            container.innerHTML =
                '<div class="loading">' +
                    '<div class="loading-spinner"></div>' +
                    '<div>正在加载房源信息...</div>' +
                '</div>';
            
            // 收集搜索参数
            const formData = new FormData(document.getElementById('searchForm'));
            const params = new URLSearchParams();
            params.append('pageNum', currentPage);
            params.append('pageSize', 12);
            
            for (let [key, value] of formData.entries()) {
                if (value.trim()) {
                    params.append(key, value);
                    currentFilters[key] = value;
                }
            }
            
            try {
                const response = await fetch(contextPath + '/room/search?' + params);
                const data = await response.json();

                console.log('API响应数据:', data);

                if (data.code === 200) {
                    const result = data.data;
                    console.log('房源数据:', result);
                    console.log('房源列表:', result.list);
                    displayRooms(result.list);

                    countElement.textContent = '共找到 ' + result.total + ' 个房源';
                } else {
                    container.innerHTML =
                        '<div class="empty-state">' +
                            '<div class="empty-icon">😔</div>' +
                            '<div>加载失败：' + data.message + '</div>' +
                        '</div>';
                }
            } catch (error) {
                console.error('加载房源失败:', error);
                container.innerHTML =
                    '<div class="empty-state">' +
                        '<div class="empty-icon">😔</div>' +
                        '<div>网络错误，请稍后重试</div>' +
                    '</div>';
            }
        }
        
        // 显示房源列表
        function displayRooms(rooms) {
            console.log('displayRooms被调用，参数:', rooms);
            const container = document.getElementById('roomsContainer');

            if (!rooms || rooms.length === 0) {
                container.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-icon">🏠</div>
                        <div>暂无符合条件的房源</div>
                        <div style="margin-top: var(--spacing-md); font-size: var(--font-size-sm);">
                            试试调整搜索条件
                        </div>
                    </div>
                `;
                return;
            }
            
            const roomsGrid = document.createElement('div');
            roomsGrid.className = 'rooms-grid';
            
            rooms.forEach(room => {
                console.log('处理房源:', room);
                const roomCard = createRoomCard(room);
                roomsGrid.appendChild(roomCard);
            });
            
            container.innerHTML = '';
            container.appendChild(roomsGrid);
        }
        
        // 创建房源卡片
        function createRoomCard(room) {
            const card = document.createElement('div');
            card.className = 'room-card';
            card.onclick = () => viewRoomDetail(room.id);
            
            // 构建图片HTML
            const imageHtml = room.coverImage ?
                '<img src="' + room.coverImage + '" alt="' + (room.roomName || '房源图片') + '" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.style.display=\'none\'; this.parentNode.innerHTML=\'🏠\';">' :
                '🏠';

            card.innerHTML =
                '<div class="room-image">' +
                    imageHtml +
                '</div>' +
                '<div class="room-content">' +
                    '<h3 class="room-title">' + (room.roomName != null ? room.roomName : '未命名房源') + '</h3>' +
                    '<div class="room-location">' +
                        '📍 ' + (room.city != null ? room.city : '') + (room.district != null ? ' · ' + room.district : '') +
                    '</div>' +
                    '<div class="room-features">' +
                        '<div class="room-feature">' +
                            '🏠 ' + (room.roomType != null ? room.roomType : '未知房型') +
                        '</div>' +
                        '<div class="room-feature">' +
                            '👥 最多' + (room.maxGuests != null ? room.maxGuests : 0) + '人' +
                        '</div>' +
                    '</div>' +
                    '<div class="room-footer">' +
                        '<div class="room-price">' +
                            '¥' + (room.pricePerNight != null ? room.pricePerNight : 0) +
                            '<span class="room-price-unit">/晚</span>' +
                        '</div>' +
                        '<button class="room-btn" onclick="event.stopPropagation(); viewRoomDetail(' + room.id + ')">' +
                            '查看详情' +
                        '</button>' +
                    '</div>' +
                '</div>';
            
            return card;
        }
        

        
        // 查看房源详情
        function viewRoomDetail(roomId) {
            window.location.href = contextPath + '/room/detail/' + roomId;
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
