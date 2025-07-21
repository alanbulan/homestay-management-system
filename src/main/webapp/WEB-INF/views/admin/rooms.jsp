<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🏠 房源管理 - HMS</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">
    <style>
        .room-image {
            width: 60px;
            height: 40px;
            object-fit: cover;
            border-radius: 6px;
        }

        /* 模态框样式修复 */
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1050;
        }

        .modal.show {
            display: flex !important;
        }

        .modal-dialog {
            max-width: 900px;
            width: 95%;
            margin: 20px;
        }

        .modal-content {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            padding: 20px 24px 16px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .btn-close {
            background: none;
            border: none;
            font-size: 24px;
            color: #666;
            cursor: pointer;
            padding: 0;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            transition: all 0.2s;
        }

        .btn-close:hover {
            background-color: #f8f9fa;
            color: #333;
        }

        .modal-body {
            padding: 24px;
        }

        .modal-footer {
            padding: 16px 24px 24px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid #ddd;
            color: #666;
        }

        .btn-outline:hover {
            background-color: #f8f9fa;
            border-color: #bbb;
            color: #333;
        }

        body.modal-open {
            overflow: hidden;
        }

        /* 表单行布局 */
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            flex: 1 1 100%;
        }

        /* 表单样式修复 */
        .form-control, .form-select {
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
            outline: none;
        }

        .input-group {
            display: flex;
            width: 100%;
        }

        .input-group .form-control {
            flex: 1;
            border-radius: 0 4px 4px 0;
        }

        .input-group-text {
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            padding: 8px 12px;
            font-size: 14px;
            color: #666;
        }

        .input-group-text:first-child {
            border-radius: 4px 0 0 4px;
            border-right: none;
        }

        .input-group-text:last-child {
            border-radius: 0 4px 4px 0;
            border-left: none;
        }

        .form-label {
            font-weight: 500;
            margin-bottom: 6px;
            color: #333;
            font-size: 14px;
        }

        .mb-3 {
            margin-bottom: 20px;
        }

        .row {
            margin-left: -12px;
            margin-right: -12px;
        }

        .col-md-6 {
            padding-left: 12px;
            padding-right: 12px;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        .form-text {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }



        /* 复选框组样式 */
        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 12px;
            margin-top: 8px;
        }

        .checkbox-group label {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            cursor: pointer;
        }

        .checkbox-group input[type="checkbox"] {
            margin: 0;
        }

        /* 动画效果 */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

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
        #roomTableBody td {
            text-align: center !important;
        }

        #roomTableBody th {
            text-align: center !important;
        }

        /* 图片管理样式 */
        .image-list {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            min-height: 60px;
            background-color: #f9f9f9;
        }

        .image-item {
            display: flex;
            align-items: center;
            padding: 8px;
            margin-bottom: 8px;
            background-color: white;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
        }

        .image-item:last-child {
            margin-bottom: 0;
        }

        .image-preview {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 10px;
        }

        .image-url-input {
            flex: 1;
            margin-right: 10px;
        }

        .image-actions {
            display: flex;
            gap: 5px;
        }

        .cover-badge {
            background-color: #28a745;
            color: white;
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 10px;
            margin-left: 5px;
        }

        /* 强制覆盖筛选器字体大小 */
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/rooms">
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
                        <h1 class="page-title">房源管理</h1>
                        <p class="page-subtitle">管理系统房源信息</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary" onclick="showAddRoomModal()">
                            <i class="bi bi-plus"></i> 添加房源
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
                            <label class="form-label">所在城市</label>
                            <select class="form-control" id="cityFilter">
                                <option value="">全部城市</option>
                                <option value="北京">北京</option>
                                <option value="上海">上海</option>
                                <option value="广州">广州</option>
                                <option value="深圳">深圳</option>
                                <option value="杭州">杭州</option>
                                <option value="成都">成都</option>
                                <option value="西安">西安</option>
                                <option value="南京">南京</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">房源类型</label>
                            <select class="form-control" id="roomTypeFilter">
                                <option value="">全部房型</option>
                                <option value="整套房子">整套房子</option>
                                <option value="独立房间">独立房间</option>
                                <option value="合住房间">合住房间</option>
                                <option value="单人房">单人房</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">房源状态</label>
                            <select class="form-control" id="statusFilter">
                                <option value="">全部状态</option>
                                <option value="1">可用</option>
                                <option value="0">不可用</option>
                                <option value="2">维护中</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">搜索关键词</label>
                            <input type="text" class="form-control" id="searchKeyword" placeholder="房源名称、地址">
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-primary" onclick="searchRooms()">
                            <i class="bi bi-search"></i> 搜索
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="resetRoomFilters()">
                            <i class="bi bi-arrow-clockwise"></i> 重置
                        </button>
                    </div>
                </div>

                <!-- 房源列表 -->
                <div class="content-card">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th class="text-center">图片</th>
                                    <th class="text-center">房源名称</th>
                                    <th class="text-center">城市</th>
                                    <th class="text-center">房型</th>
                                    <th class="text-center">价格</th>
                                    <th class="text-center">状态</th>
                                    <th class="text-center">创建时间</th>
                                    <th class="text-center">操作</th>
                                </tr>
                            </thead>
                            <tbody id="roomTableBody">
                                <tr>
                                    <td>1</td>
                                    <td><span style="color: #6c757d;">无图片</span></td>
                                    <td>温馨小屋</td>
                                    <td>北京</td>
                                    <td>整套房子</td>
                                    <td>¥299.00</td>
                                    <td><span class="badge badge-success">可用</span></td>
                                    <td>2024-01-15</td>
                                    <td>
                                        <button class="btn btn-primary btn-action" onclick="editRoom(1)" title="编辑">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-danger btn-action" onclick="deleteRoom(1)" title="删除">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td><span style="color: #6c757d;">无图片</span></td>
                                    <td>现代公寓</td>
                                    <td>上海</td>
                                    <td>独立房间</td>
                                    <td>¥199.00</td>
                                    <td><span class="badge badge-success">可用</span></td>
                                    <td>2024-01-14</td>
                                    <td>
                                        <button class="btn btn-primary btn-action" onclick="editRoom(2)" title="编辑">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-danger btn-action" onclick="deleteRoom(2)" title="删除">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td><span style="color: #6c757d;">无图片</span></td>
                                    <td>海景别墅</td>
                                    <td>深圳</td>
                                    <td>整套房子</td>
                                    <td>¥599.00</td>
                                    <td><span class="badge badge-danger">不可用</span></td>
                                    <td>2024-01-13</td>
                                    <td>
                                        <button class="btn btn-primary btn-action" onclick="editRoom(3)" title="编辑">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-danger btn-action" onclick="deleteRoom(3)" title="删除">
                                            <i class="bi bi-trash"></i>
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

    <!-- 编辑房源模态框 -->
    <div class="modal fade" id="editRoomModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑房源</h5>
                    <button type="button" class="btn-close" onclick="hideEditRoomModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="editRoomForm">
                        <input type="hidden" name="id" id="editRoomId">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">房源名称 *</label>
                                    <input type="text" class="form-control" name="roomName" id="editRoomName" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">城市 *</label>
                                    <select class="form-select" name="city" id="editRoomCity" required>
                                        <option value="">请选择城市</option>
                                        <option value="北京">北京</option>
                                        <option value="上海">上海</option>
                                        <option value="广州">广州</option>
                                        <option value="深圳">深圳</option>
                                        <option value="杭州">杭州</option>
                                        <option value="成都">成都</option>
                                        <option value="西安">西安</option>
                                        <option value="南京">南京</option>
                                        <option value="武汉">武汉</option>
                                        <option value="重庆">重庆</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">房型 *</label>
                                    <select class="form-select" name="roomType" id="editRoomType" required>
                                        <option value="">请选择房型</option>
                                        <option value="单人房">单人房</option>
                                        <option value="双人房">双人房</option>
                                        <option value="套房">套房</option>
                                        <option value="整套房子">整套房子</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">价格 *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">¥</span>
                                        <input type="number" class="form-control" name="pricePerNight" id="editRoomPrice" min="0" step="0.01" required>
                                        <span class="input-group-text">元/晚</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">详细地址 *</label>
                            <input type="text" class="form-control" name="address" id="editRoomAddress" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">房源描述</label>
                            <textarea class="form-control" name="description" id="editRoomDescription" rows="4" placeholder="请描述房源的特色、设施等信息"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">最大入住人数</label>
                                    <input type="number" class="form-control" name="maxGuests" id="editRoomMaxGuests" min="1" value="2">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">状态</label>
                                    <select class="form-select" name="status" id="editRoomStatus">
                                        <option value="1">可用</option>
                                        <option value="0">不可用</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">房源图片</label>
                            <div id="editImageList" class="image-list">
                                <!-- 图片列表将通过JavaScript动态生成 -->
                            </div>
                            <div class="mt-2">
                                <button type="button" class="btn btn-outline-primary btn-sm" onclick="addEditImage()">
                                    <i class="bi bi-plus"></i> 添加图片
                                </button>
                            </div>
                            <small class="form-text text-muted">第一张图片将作为封面图片显示</small>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="hideEditRoomModal()">取消</button>
                    <button type="button" class="btn btn-primary" onclick="updateRoom()">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 添加房源模态框 -->
    <div class="modal" id="addRoomModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加房源</h5>
                    <button type="button" class="btn-close" onclick="closeAddRoomModal()">&times;</button>
                </div>
            <div class="modal-body">
                <form id="addRoomForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">房源名称 *</label>
                            <input type="text" class="form-control" name="roomName" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">房型 *</label>
                            <select class="form-control" name="roomType" required>
                                <option value="">请选择房型</option>
                                <option value="整套房子">整套房子</option>
                                <option value="独立房间">独立房间</option>
                                <option value="合住房间">合住房间</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">城市 *</label>
                            <select class="form-control" name="city" required>
                                <option value="">请选择城市</option>
                                <option value="北京">北京</option>
                                <option value="上海">上海</option>
                                <option value="广州">广州</option>
                                <option value="深圳">深圳</option>
                                <option value="杭州">杭州</option>
                                <option value="成都">成都</option>
                                <option value="西安">西安</option>
                                <option value="青岛">青岛</option>
                                <option value="厦门">厦门</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">区域</label>
                            <input type="text" class="form-control" name="district" placeholder="如：朝阳区">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">详细地址 *</label>
                        <input type="text" class="form-control" name="address" required placeholder="请输入详细地址">
                    </div>

                    <div class="form-group">
                        <label class="form-label">房源描述</label>
                        <textarea class="form-control" name="description" rows="3" placeholder="请描述房源特色、周边环境等"></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">每晚价格 (元) *</label>
                            <input type="number" class="form-control" name="pricePerNight" required min="0" step="0.01">
                        </div>
                        <div class="form-group">
                            <label class="form-label">最大入住人数 *</label>
                            <input type="number" class="form-control" name="maxGuests" required min="1" max="20">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">房间面积 (㎡)</label>
                            <input type="number" class="form-control" name="area" min="0" step="0.1">
                        </div>
                        <div class="form-group">
                            <label class="form-label">楼层</label>
                            <input type="number" class="form-control" name="floor" min="1" max="100">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">入住时间</label>
                            <input type="time" class="form-control" name="checkInTime" value="14:00">
                        </div>
                        <div class="form-group">
                            <label class="form-label">退房时间</label>
                            <input type="time" class="form-control" name="checkOutTime" value="12:00">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">房间设施</label>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="facilities" value="WiFi"> WiFi</label>
                            <label><input type="checkbox" name="facilities" value="空调"> 空调</label>
                            <label><input type="checkbox" name="facilities" value="电视"> 电视</label>
                            <label><input type="checkbox" name="facilities" value="洗衣机"> 洗衣机</label>
                            <label><input type="checkbox" name="facilities" value="冰箱"> 冰箱</label>
                            <label><input type="checkbox" name="facilities" value="厨房"> 厨房</label>
                            <label><input type="checkbox" name="facilities" value="停车位"> 停车位</label>
                            <label><input type="checkbox" name="facilities" value="健身房"> 健身房</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">房源状态</label>
                        <select class="form-control" name="status">
                            <option value="1">上架</option>
                            <option value="0">下架</option>
                            <option value="2">维护中</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeAddRoomModal()">取消</button>
                <button type="button" class="btn btn-primary" onclick="submitAddRoom()">
                    <i class="bi bi-check"></i> 添加房源
                </button>
            </div>
            </div>
        </div>
    </div>

    <script>
        let currentPage = 1;
        const pageSize = 5;

        // 页面加载时获取房源列表
        document.addEventListener('DOMContentLoaded', function() {
            console.log('页面加载完成');
            loadRooms();

            // 绑定回车搜索
            document.getElementById('searchKeyword').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchRooms();
                }
            });

            // 绑定模态框点击外部关闭事件
            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('modal')) {
                    e.target.classList.remove('show');
                }
            });
        });

        // 加载房源列表
        function loadRooms(page = 1) {
            console.log('加载房源列表，页码:', page);

            const city = document.getElementById('cityFilter').value;
            const roomType = document.getElementById('roomTypeFilter').value;
            const status = document.getElementById('statusFilter').value;
            const keyword = document.getElementById('searchKeyword').value;

            const params = new URLSearchParams({
                pageNum: page,
                pageSize: pageSize
            });

            if (city) params.append('city', city);
            if (roomType) params.append('roomType', roomType);
            if (status) params.append('status', status);
            if (keyword) params.append('keyword', keyword);

            console.log('请求参数:', params.toString());

            fetch('${pageContext.request.contextPath}/room/manage/list?' + params)
                .then(response => {
                    console.log('响应状态:', response.status);
                    return response.json();
                })
                .then(result => {
                    console.log('API响应:', result);
                    if (result.code === 200) {
                        const pageData = result.data;
                        console.log('房源数据:', pageData);
                        renderRoomTable(pageData.list || []);
                        renderPagination(pageData.pageNum, pageData.pages, pageData.total);
                        currentPage = page;
                    } else {
                        console.error('API错误:', result.message);
                        alert('加载房源列表失败: ' + result.message);
                    }
                })
                .catch(error => {
                    console.error('请求失败:', error);
                    alert('加载房源列表失败: ' + error.message);
                });
        }

        // 渲染房源表格
        function renderRoomTable(rooms) {
            console.log('渲染房源表格，数据:', rooms);
            const tbody = document.getElementById('roomTableBody');
            tbody.innerHTML = '';

            if (!rooms || rooms.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center">暂无房源数据</td></tr>';
                return;
            }

            rooms.forEach(room => {
                console.log('处理房源:', room);
                const row = document.createElement('tr');

                // 构建图片状态显示
                const imageStatus = room.coverImage
                    ? '<img src="' + room.coverImage + '" alt="房源图片" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;" onerror="this.style.display=\'none\'; this.parentNode.innerHTML=\'<span style=\\\'color: #6c757d;\\\'>无图片</span>\';">'
                    : '<span style="color: #6c757d;">无图片</span>';

                // 构建状态徽章
                const statusBadge = getStatusBadge(room.status);

                row.innerHTML =
                    '<td class="text-center">' + (room.id || '-') + '</td>' +
                    '<td class="text-center">' + imageStatus + '</td>' +
                    '<td class="text-center">' + (room.roomName || '-') + '</td>' +
                    '<td class="text-center">' + (room.city || '-') + '</td>' +
                    '<td class="text-center">' + getRoomTypeText(room.roomType) + '</td>' +
                    '<td class="text-center">¥' + (room.pricePerNight ? room.pricePerNight.toFixed(2) : '0.00') + '</td>' +
                    '<td class="text-center">' + statusBadge + '</td>' +
                    '<td class="text-center">' + formatDate(room.createTime) + '</td>' +
                    '<td class="text-center action-buttons">' +
                        '<button class="btn btn-primary btn-action" onclick="editRoom(' + room.id + ')" title="编辑">' +
                            '<i class="bi bi-pencil"></i>' +
                        '</button>' +
                        '<button class="btn btn-danger btn-action" onclick="deleteRoom(' + room.id + ')" title="删除">' +
                            '<i class="bi bi-trash"></i>' +
                        '</button>' +
                    '</td>';

                tbody.appendChild(row);
            });
        }

        // 获取状态徽章
        function getStatusBadge(status) {
            switch(status) {
                case 1:
                    return '<span class="badge badge-success">可用</span>';
                case 0:
                    return '<span class="badge badge-secondary">下架</span>';
                case 2:
                    return '<span class="badge badge-warning">维护中</span>';
                default:
                    return '<span class="badge badge-secondary">未知</span>';
            }
        }

        // 获取房型文本
        function getRoomTypeText(roomType) {
            if (!roomType) return '未知';

            // 根据实际数据库中的房型值进行映射
            const types = {
                '整套房子': '整套房子',
                '独立房间': '独立房间',
                '合住房间': '合住房间',
                '单人间': '单人间',
                '双人间': '双人间',
                '套房': '套房',
                '公寓': '公寓'
            };
            return types[roomType] || roomType;
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
                    loadRooms(currentPage - 1);
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
                    loadRooms(currentPage + 1);
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
                loadRooms(pageNum);
            };
            return btn;
        }

        // 搜索房源
        function searchRooms() {
            loadRooms(1);
        }

        // 重置房源筛选器
        function resetRoomFilters() {
            document.getElementById('cityFilter').value = '';
            document.getElementById('roomTypeFilter').value = '';
            document.getElementById('statusFilter').value = '';
            document.getElementById('searchKeyword').value = '';
            loadRooms(1);
        }

        // 显示添加房源模态框
        function showAddRoomModal() {
            document.getElementById('addRoomModal').classList.add('show');
            // 重置表单
            document.getElementById('addRoomForm').reset();
        }

        // 关闭添加房源模态框
        function closeAddRoomModal() {
            document.getElementById('addRoomModal').classList.remove('show');
        }

        // 提交添加房源
        function submitAddRoom() {
            const form = document.getElementById('addRoomForm');
            const formData = new FormData(form);

            // 构建房源对象
            const roomData = {
                roomName: formData.get('roomName'),
                roomType: formData.get('roomType'),
                city: formData.get('city'),
                district: formData.get('district'),
                address: formData.get('address'),
                description: formData.get('description'),
                pricePerNight: parseFloat(formData.get('pricePerNight')),
                maxGuests: parseInt(formData.get('maxGuests')),
                area: formData.get('area') ? parseFloat(formData.get('area')) : null,
                floor: formData.get('floor') ? parseInt(formData.get('floor')) : null,
                checkInTime: (formData.get('checkInTime') || '14:00') + ':00',
                checkOutTime: (formData.get('checkOutTime') || '12:00') + ':00',
                status: parseInt(formData.get('status')) || 1
            };

            // 处理设施复选框
            const facilities = [];
            const facilityCheckboxes = form.querySelectorAll('input[name="facilities"]:checked');
            facilityCheckboxes.forEach(checkbox => {
                facilities.push(checkbox.value);
            });
            roomData.facilities = JSON.stringify(facilities);

            // 验证必填字段
            if (!roomData.roomName || !roomData.roomType || !roomData.city || !roomData.address || !roomData.pricePerNight || !roomData.maxGuests) {
                alert('请填写所有必填字段');
                return;
            }

            // 发送请求
            fetch('${pageContext.request.contextPath}/room/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(roomData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('房源添加成功');
                    closeAddRoomModal();
                    loadRooms(1); // 重新加载房源列表
                } else {
                    alert('添加失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('添加房源失败:', error);
                alert('添加房源失败');
            });
        }

        // 编辑房源
        function editRoom(id) {
            // 获取房源详情
            fetch('${pageContext.request.contextPath}/room/detail/' + id + '/api')
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        const room = data.data;
                        // 填充编辑表单
                        document.getElementById('editRoomId').value = room.id;
                        document.getElementById('editRoomName').value = room.roomName;
                        document.getElementById('editRoomCity').value = room.city;
                        document.getElementById('editRoomType').value = room.roomType;
                        document.getElementById('editRoomPrice').value = room.pricePerNight;
                        document.getElementById('editRoomAddress').value = room.address || '';
                        document.getElementById('editRoomDescription').value = room.description || '';
                        document.getElementById('editRoomMaxGuests').value = room.maxGuests || 2;
                        document.getElementById('editRoomStatus').value = room.status;

                        // 加载图片列表
                        loadEditImages(room.images || []);

                        // 显示编辑模态框
                        showEditRoomModal();
                    } else {
                        alert('获取房源信息失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('获取房源信息失败:', error);
                    alert('获取房源信息失败');
                });
        }

        // 更新房源
        function updateRoom() {
            const form = document.getElementById('editRoomForm');
            const formData = new FormData(form);
            const roomData = Object.fromEntries(formData);

            // 数据验证
            if (!roomData.roomName || !roomData.city || !roomData.roomType || !roomData.pricePerNight || !roomData.address) {
                alert('请填写所有必填字段');
                return;
            }

            // 收集图片数据
            const imageInputs = document.querySelectorAll('#editImageList .image-url-input');
            const images = [];
            let coverIndex = -1;

            imageInputs.forEach((input, index) => {
                const url = input.value.trim();
                if (url) {
                    const isCover = input.parentElement.querySelector('.cover-badge') !== null;
                    if (isCover) coverIndex = images.length;

                    images.push({
                        id: input.dataset.imageId || null,
                        imageUrl: url,
                        isCover: isCover ? 1 : 0,
                        sortOrder: index + 1
                    });
                }
            });

            // 如果没有设置封面，第一张图片作为封面
            if (images.length > 0 && coverIndex === -1) {
                images[0].isCover = 1;
            }

            roomData.images = images;

            fetch('${pageContext.request.contextPath}/room/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(roomData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('房源更新成功');
                    hideEditRoomModal();
                    loadRooms(currentPage);
                } else {
                    alert('更新房源失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('更新房源失败:', error);
                alert('更新房源失败');
            });
        }

        // 显示编辑房源模态框
        function showEditRoomModal() {
            document.getElementById('editRoomModal').classList.add('show');
            document.getElementById('editRoomModal').style.display = 'flex';
        }

        // 隐藏编辑房源模态框
        function hideEditRoomModal() {
            document.getElementById('editRoomModal').classList.remove('show');
            document.getElementById('editRoomModal').style.display = 'none';
        }

        // 加载编辑图片列表
        function loadEditImages(images) {
            const imageList = document.getElementById('editImageList');
            imageList.innerHTML = '';

            if (images && images.length > 0) {
                images.forEach((image, index) => {
                    addEditImageItem(image.imageUrl, index === 0, image.id);
                });
            } else {
                // 如果没有图片，添加一个空的输入框
                addEditImageItem('', true);
            }
        }

        // 添加编辑图片项
        function addEditImageItem(url = '', isCover = false, imageId = null) {
            const imageList = document.getElementById('editImageList');
            const imageItem = document.createElement('div');
            imageItem.className = 'image-item';

            const imgSrc = url || '/hms/static/images/placeholder.png';
            const coverBadge = isCover ? '<span class="cover-badge">封面</span>' : '';
            const starButton = !isCover ? '<button type="button" class="btn btn-sm btn-outline-success" onclick="setCover(this)" title="设为封面"><i class="bi bi-star"></i></button>' : '';

            imageItem.innerHTML =
                '<img class="image-preview" src="' + imgSrc + '" onerror="this.src=\'/hms/static/images/placeholder.png\'" alt="预览">' +
                '<input type="url" class="form-control image-url-input" placeholder="请输入图片URL" value="' + url + '" onchange="updateImagePreview(this)" data-image-id="' + (imageId || '') + '">' +
                coverBadge +
                '<div class="image-actions">' +
                    starButton +
                    '<button type="button" class="btn btn-sm btn-outline-danger" onclick="removeEditImage(this)" title="删除"><i class="bi bi-trash"></i></button>' +
                '</div>';

            imageList.appendChild(imageItem);
        }

        // 添加编辑图片
        function addEditImage() {
            addEditImageItem();
        }

        // 删除编辑图片
        function removeEditImage(button) {
            const imageItem = button.closest('.image-item');
            const isCover = imageItem.querySelector('.cover-badge');

            if (isCover) {
                alert('不能删除封面图片，请先设置其他图片为封面');
                return;
            }

            imageItem.remove();
        }

        // 设置封面
        function setCover(button) {
            const imageList = document.getElementById('editImageList');
            const allItems = imageList.querySelectorAll('.image-item');

            // 移除所有封面标记
            allItems.forEach(item => {
                const badge = item.querySelector('.cover-badge');
                const starBtn = item.querySelector('.btn-outline-success');
                if (badge) badge.remove();
                if (starBtn) starBtn.style.display = 'inline-block';
            });

            // 添加新的封面标记
            const currentItem = button.closest('.image-item');
            const coverBadge = document.createElement('span');
            coverBadge.className = 'cover-badge';
            coverBadge.textContent = '封面';
            currentItem.insertBefore(coverBadge, currentItem.querySelector('.image-actions'));
            button.style.display = 'none';
        }

        // 更新图片预览
        function updateImagePreview(input) {
            const preview = input.parentElement.querySelector('.image-preview');
            if (input.value) {
                preview.src = input.value;
            } else {
                preview.src = '/hms/static/images/placeholder.png';
            }
        }

        // 删除房源
        function deleteRoom(id) {
            if (confirm('确定要删除这个房源吗？此操作不可恢复！')) {
                fetch('${pageContext.request.contextPath}/room/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'roomId=' + id
                })
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        alert('房源删除成功');
                        loadRooms(currentPage);
                    } else {
                        alert('删除失败: ' + result.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('删除房源失败');
                });
            }
        }
    </script>
</body>
</html>