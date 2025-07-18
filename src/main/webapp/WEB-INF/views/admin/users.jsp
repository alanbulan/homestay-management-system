<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>👥 用户管理 - HMS</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css">
    <style>
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
            max-width: 600px;
            width: 90%;
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

        .mb-3 {
            margin-bottom: 1rem;
        }

        body.modal-open {
            overflow: hidden;
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

        .form-label {
            font-weight: 500;
            margin-bottom: 6px;
            color: #333;
            font-size: 14px;
        }

        .mb-3 {
            margin-bottom: 20px;
        }

        .form-text {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }

        /* 强制表格对齐 - 覆盖所有其他样式 */
        .data-table th,
        .data-table td,
        table th,
        table td {
            text-align: center !important;
            vertical-align: middle !important;
        }

        .data-table .text-center,
        table .text-center,
        .text-center {
            text-align: center !important;
        }

        /* 确保表格内容居中 */
        #userTableBody td {
            text-align: center !important;
        }

        #userTableBody th {
            text-align: center !important;
        }

        /* 操作按钮列样式 */
        .action-buttons {
            white-space: nowrap;
        }

        .action-buttons .btn {
            margin: 0 2px;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
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
                        <h1 class="page-title">用户管理</h1>
                        <p class="page-subtitle">管理系统用户信息</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary" onclick="showAddUserModal()">
                            <i class="bi bi-plus"></i> 添加用户
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
                            <label class="form-label">用户类型</label>
                            <select class="form-control" id="userTypeFilter">
                                <option value="">全部类型</option>
                                <option value="0">普通用户</option>
                                <option value="1">管理员</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">账户状态</label>
                            <select class="form-control" id="statusFilter">
                                <option value="">全部状态</option>
                                <option value="1">正常</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">搜索关键词</label>
                            <input type="text" class="form-control" id="searchKeyword" placeholder="用户名、姓名、邮箱、手机号">
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-primary" onclick="searchUsers()">
                            <i class="bi bi-search"></i> 搜索
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="resetUserFilters()">
                            <i class="bi bi-arrow-clockwise"></i> 重置
                        </button>
                    </div>
                </div>

                <!-- 用户列表 -->
                <div class="content-card">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th class="text-center">用户名</th>
                                    <th class="text-center">真实姓名</th>
                                    <th class="text-center">邮箱</th>
                                    <th class="text-center">手机号</th>
                                    <th class="text-center">用户类型</th>
                                    <th class="text-center">状态</th>
                                    <th class="text-center">注册时间</th>
                                    <th class="text-center">操作</th>
                                </tr>
                            </thead>
                            <tbody id="userTableBody">
                                <!-- 用户数据将通过JavaScript加载 -->
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
            </main>
        </div>
    </div>

    <!-- 添加用户模态框 -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加用户</h5>
                    <button type="button" class="btn-close" onclick="hideModal('addUserModal')">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="addUserForm">
                        <div class="mb-3">
                            <label class="form-label">用户名 *</label>
                            <input type="text" class="form-control" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">密码 *</label>
                            <input type="password" class="form-control" name="password" id="addPassword" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">真实姓名</label>
                            <input type="text" class="form-control" name="realName">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">邮箱</label>
                            <input type="email" class="form-control" name="email">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">手机号</label>
                            <input type="tel" class="form-control" name="phone">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">用户类型</label>
                            <select class="form-select" name="userType">
                                <option value="0">普通用户</option>
                                <option value="1">管理员</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">状态</label>
                            <select class="form-select" name="status">
                                <option value="1">正常</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="hideModal('addUserModal')">取消</button>
                    <button type="button" class="btn btn-primary" onclick="addUser()">添加</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 编辑用户模态框 -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑用户</h5>
                    <button type="button" class="btn-close" onclick="hideModal('editUserModal')">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm">
                        <input type="hidden" name="id" id="editUserId">
                        <div class="mb-3">
                            <label class="form-label">用户名 *</label>
                            <input type="text" class="form-control" name="username" id="editUsername" required readonly>
                            <small class="form-text text-muted">用户名不可修改</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">新密码</label>
                            <input type="password" class="form-control" name="password" id="editPassword" placeholder="留空则不修改密码">
                            <small class="form-text text-muted">留空则不修改密码</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">真实姓名</label>
                            <input type="text" class="form-control" name="realName" id="editRealName">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">邮箱</label>
                            <input type="email" class="form-control" name="email" id="editEmail">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">手机号</label>
                            <input type="tel" class="form-control" name="phone" id="editPhone">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">用户类型</label>
                            <select class="form-select" name="userType" id="editUserType">
                                <option value="0">普通用户</option>
                                <option value="1">管理员</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">状态</label>
                            <select class="form-select" name="status" id="editStatus">
                                <option value="1">正常</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline" onclick="hideModal('editUserModal')">取消</button>
                    <button type="button" class="btn btn-primary" onclick="updateUser()">保存</button>
                </div>
            </div>
        </div>
    </div>
    <script>
        let currentPage = 1;
        const pageSize = 5;

        // 格式化日期函数
        function formatDate(dateString) {
            if (!dateString) return '-';
            const date = new Date(dateString);
            return date.toLocaleDateString();
        }

        // 加载用户列表
        function loadUsers(page = 1) {
            const userType = document.getElementById('userTypeFilter').value;
            const status = document.getElementById('statusFilter').value;
            const keyword = document.getElementById('searchKeyword').value;
            
            const params = new URLSearchParams({
                pageNum: page,
                pageSize: pageSize
            });
            
            if (userType) params.append('userType', userType);
            if (status) params.append('status', status);
            if (keyword) params.append('keyword', keyword);
            
            fetch('${pageContext.request.contextPath}/user/list?' + params)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        renderUserTable(data.data.list);
                        renderPagination(data.data.pageNum, data.data.pages, data.data.total);
                        currentPage = page;
                    } else {
                        alert('加载用户列表失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('加载用户列表失败:', error);
                    alert('加载用户列表失败');
                });
        }

        // 渲染用户表格
        function renderUserTable(users) {
            const tbody = document.getElementById('userTableBody');
            tbody.innerHTML = '';
            
            users.forEach(user => {
                const row = document.createElement('tr');
                // 构建用户类型徽章
                const userTypeBadge = user.userType == 1
                    ? '<span class="badge badge-danger">管理员</span>'
                    : '<span class="badge badge-primary">普通用户</span>';

                // 构建状态徽章
                const statusBadge = user.status == 1
                    ? '<span class="badge badge-success">正常</span>'
                    : '<span class="badge badge-secondary">禁用</span>';

                row.innerHTML =
                    '<td class="text-center">' + user.id + '</td>' +
                    '<td class="text-center">' + user.username + '</td>' +
                    '<td class="text-center">' + (user.realName || '-') + '</td>' +
                    '<td class="text-center">' + (user.email || '-') + '</td>' +
                    '<td class="text-center">' + (user.phone || '-') + '</td>' +
                    '<td class="text-center">' + userTypeBadge + '</td>' +
                    '<td class="text-center">' + statusBadge + '</td>' +
                    '<td class="text-center">' + formatDate(user.createTime) + '</td>' +
                    '<td class="text-center action-buttons">' +
                        '<button class="btn btn-outline btn-action" onclick="editUser(' + user.id + ')" title="编辑">' +
                            '<i class="bi bi-pencil"></i>' +
                        '</button>' +
                        '<button class="btn btn-' + (user.status == 1 ? 'warning' : 'success') + ' btn-action" onclick="toggleUserStatus(' + user.id + ', ' + (user.status == 1 ? 0 : 1) + ')" title="' + (user.status == 1 ? '禁用' : '启用') + '">' +
                            '<i class="bi bi-' + (user.status == 1 ? 'pause' : 'play') + '"></i>' +
                        '</button>' +
                        '<button class="btn btn-danger btn-action" onclick="deleteUser(' + user.id + ')" title="删除">' +
                            '<i class="bi bi-trash"></i>' +
                        '</button>' +
                    '</td>';
                tbody.appendChild(row);
            });
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
            prevBtn.onclick = () => {
                if (currentPage > 1) {
                    loadUsers(currentPage - 1);
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
            nextBtn.onclick = () => {
                if (currentPage < totalPages) {
                    loadUsers(currentPage + 1);
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
            btn.onclick = () => loadUsers(pageNum);
            return btn;
        }

        // 搜索用户
        function searchUsers() {
            loadUsers(1);
        }

        // 重置用户筛选器
        function resetUserFilters() {
            document.getElementById('userTypeFilter').value = '';
            document.getElementById('statusFilter').value = '';
            document.getElementById('searchKeyword').value = '';
            loadUsers(1);
        }

        // 添加用户
        function addUser() {
            console.log('=== 开始添加用户 ===');

            // 等待一下确保DOM完全加载
            setTimeout(function() {
                // 逐个获取表单元素并调试
                const usernameInput = document.querySelector('#addUserForm input[name="username"]');
                const passwordInput = document.querySelector('#addUserForm input[name="password"]');
                const realNameInput = document.querySelector('#addUserForm input[name="realName"]');
                const emailInput = document.querySelector('#addUserForm input[name="email"]');
                const phoneInput = document.querySelector('#addUserForm input[name="phone"]');
                const userTypeSelect = document.querySelector('#addUserForm select[name="userType"]');
                const statusSelect = document.querySelector('#addUserForm select[name="status"]');

                console.log('表单元素检查:');
                console.log('用户名输入框:', usernameInput);
                console.log('密码输入框:', passwordInput);
                console.log('密码输入框值:', passwordInput ? passwordInput.value : 'null');
                console.log('密码输入框类型:', passwordInput ? passwordInput.type : 'null');

                if (!passwordInput) {
                    alert('找不到密码输入框');
                    return;
                }

                // 获取值
                const username = usernameInput ? usernameInput.value.trim() : '';
                const password = passwordInput ? passwordInput.value : '';
                const realName = realNameInput ? realNameInput.value.trim() : '';
                const email = emailInput ? emailInput.value.trim() : '';
                const phone = phoneInput ? phoneInput.value.trim() : '';
                const userType = userTypeSelect ? parseInt(userTypeSelect.value) : 0;
                const status = statusSelect ? parseInt(statusSelect.value) : 1;

                console.log('获取到的值:');
                console.log('用户名:', username);
                console.log('密码:', password);
                console.log('密码长度:', password.length);

                // 验证
                if (!username) {
                    alert('请输入用户名');
                    return;
                }

                if (!password) {
                    alert('请输入密码');
                    return;
                }

                if (password.length < 6) {
                    alert('密码长度不能少于6位');
                    return;
                }

                const userData = {
                    username: username,
                    password: password,
                    realName: realName,
                    email: email,
                    phone: phone,
                    userType: userType,
                    status: status
                };

                console.log('最终用户数据:', userData);
                console.log('JSON字符串:', JSON.stringify(userData));

                // 发送请求
                fetch('${pageContext.request.contextPath}/user/create', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(userData)
                })
                .then(response => response.json())
                .then(data => {
                    console.log('服务器响应:', data);
                    if (data.code === 200) {
                        alert('用户添加成功');
                        hideModal('addUserModal');
                        loadUsers(currentPage);
                    } else {
                        alert('添加用户失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('添加用户失败:', error);
                    alert('添加用户失败');
                });

            }, 100); // 延迟100ms确保DOM稳定
        }

        // 切换用户状态
        function toggleUserStatus(userId, newStatus) {
            const action = newStatus === 1 ? '启用' : '禁用';
            if (!confirm('确定要' + action + '该用户吗？')) {
                return;
            }

            const params = new URLSearchParams();
            params.append('userId', userId);
            params.append('status', newStatus);

            fetch('${pageContext.request.contextPath}/user/updateStatus', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('用户' + action + '成功');
                    loadUsers(currentPage);
                } else {
                    alert(action + '用户失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error(action + '用户失败:', error);
                alert(action + '用户失败');
            });
        }

        // 删除用户
        function deleteUser(userId) {
            if (!confirm('确定要删除该用户吗？此操作不可恢复！')) {
                return;
            }
            
            fetch('${pageContext.request.contextPath}/user/' + userId, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('用户删除成功');
                    loadUsers(currentPage);
                } else {
                    alert('删除用户失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('删除用户失败:', error);
                alert('删除用户失败');
            });
        }

        // 显示添加用户模态框
        function showAddUserModal() {
            const modal = document.getElementById('addUserModal');
            modal.classList.add('show');
            modal.style.display = 'block';
            document.body.classList.add('modal-open');

            // 重置表单
            document.getElementById('addUserForm').reset();
        }

        // 隐藏模态框
        function hideModal(modalId) {
            const modal = document.getElementById(modalId);
            modal.classList.remove('show');
            modal.style.display = 'none';
            document.body.classList.remove('modal-open');
        }

        // 编辑用户
        function editUser(userId) {
            // 获取用户详情
            fetch('${pageContext.request.contextPath}/user/' + userId)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        const user = data.data;
                        // 填充编辑表单
                        document.getElementById('editUserId').value = user.id;
                        document.getElementById('editUsername').value = user.username;
                        document.getElementById('editRealName').value = user.realName || '';
                        document.getElementById('editEmail').value = user.email || '';
                        document.getElementById('editPhone').value = user.phone || '';
                        document.getElementById('editUserType').value = user.userType;
                        document.getElementById('editStatus').value = user.status;
                        document.getElementById('editPassword').value = ''; // 清空密码字段

                        // 显示编辑模态框
                        showEditUserModal();
                    } else {
                        alert('获取用户信息失败: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('获取用户信息失败:', error);
                    alert('获取用户信息失败');
                });
        }

        // 更新用户
        function updateUser() {
            const form = document.getElementById('editUserForm');
            const formData = new FormData(form);
            const userData = Object.fromEntries(formData);

            console.log('编辑用户原始数据:', userData);

            // 如果密码为空，则删除密码字段
            if (!userData.password || userData.password.trim() === '') {
                delete userData.password;
                console.log('密码为空，已删除密码字段');
            } else {
                console.log('密码不为空，将更新密码:', userData.password);
            }

            console.log('最终发送的数据:', userData);
            console.log('JSON字符串:', JSON.stringify(userData));

            fetch('${pageContext.request.contextPath}/user/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('用户更新成功');
                    hideModal('editUserModal');
                    loadUsers(currentPage);
                } else {
                    alert('更新用户失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('更新用户失败:', error);
                alert('更新用户失败');
            });
        }

        // 显示编辑用户模态框
        function showEditUserModal() {
            document.getElementById('editUserModal').classList.add('show');
            document.getElementById('editUserModal').style.display = 'flex';
        }

        // 页面加载完成后执行
        document.addEventListener('DOMContentLoaded', function() {
            loadUsers(1);

            // 绑定回车搜索
            document.getElementById('searchKeyword').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchUsers();
                }
            });

            // 绑定模态框关闭事件
            document.addEventListener('click', function(e) {
                if (e.target.classList.contains('modal')) {
                    e.target.classList.remove('show');
                    e.target.style.display = 'none';
                }
                if (e.target.classList.contains('btn-close')) {
                    const modal = e.target.closest('.modal');
                    if (modal) {
                        modal.classList.remove('show');
                        modal.style.display = 'none';
                    }
                }
            });
        });
    </script>
</body>
</html>
