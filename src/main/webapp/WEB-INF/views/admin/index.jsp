<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>📊 仪表板 - HMS</title>
    <link
      href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.7.2/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/admin.css"
    />

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
              <a
                class="nav-link active"
                href="${pageContext.request.contextPath}/admin"
              >
                <i class="bi bi-speedometer2"></i>
                仪表板
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/admin/users"
              >
                <i class="bi bi-people"></i>
                用户管理
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/admin/rooms"
              >
                <i class="bi bi-building"></i>
                房源管理
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/admin/orders"
              >
                <i class="bi bi-receipt"></i>
                订单管理
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/admin/settings"
              >
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
              <h1 class="page-title">仪表板</h1>
              <p class="page-subtitle">系统概览和数据统计</p>
            </div>
            <div>
              <span style="color: #6c757d">欢迎回来，管理员</span>
            </div>
          </div>

          <!-- 统计卡片 -->
          <div class="stats-grid">
            <div class="stat-card users">
              <div class="stat-icon">
                <i class="bi bi-people"></i>
              </div>
              <div class="stat-number" id="totalUsers">-</div>
              <div class="stat-label">用户总数</div>
              <div class="stat-detail" id="activeUsers">活跃: -</div>
            </div>

            <div class="stat-card rooms">
              <div class="stat-icon">
                <i class="bi bi-building"></i>
              </div>
              <div class="stat-number" id="totalRooms">-</div>
              <div class="stat-label">房源总数</div>
              <div class="stat-detail" id="onlineRooms">在线: -</div>
            </div>

            <div class="stat-card orders">
              <div class="stat-icon">
                <i class="bi bi-receipt"></i>
              </div>
              <div class="stat-number" id="totalOrders">-</div>
              <div class="stat-label">订单总数</div>
              <div class="stat-detail" id="pendingOrders">待处理: -</div>
            </div>

            <div class="stat-card revenue">
              <div class="stat-icon">
                <i class="bi bi-currency-dollar"></i>
              </div>
              <div class="stat-number" id="totalRevenue">¥-</div>
              <div class="stat-label">总收入</div>
              <div class="stat-detail" id="revenueToday">今日: ¥-</div>
            </div>
          </div>


        </div>
      </main>
    </div>

    <script>
      // 页面加载时获取统计数据
      document.addEventListener("DOMContentLoaded", function () {
        loadDashboardStats();
      });

      // 加载仪表板统计数据
      function loadDashboardStats() {
        fetch("${pageContext.request.contextPath}/admin/dashboard/stats")
          .then((response) => response.json())
          .then((result) => {
            if (result.success) {
              updateStatsDisplay(result.data);
            } else {
              console.error("加载统计数据失败:", result.message);
              // 保持默认显示
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            // 保持默认显示
          });
      }




      // 更新统计数据显示
      function updateStatsDisplay(stats) {
        // 更新上方统计卡片
        if (stats.users) {
          document.getElementById("totalUsers").textContent =
            stats.users.total || 0;
          document.getElementById("activeUsers").textContent =
            "活跃: " + (stats.users.active || 0);
        }

        if (stats.rooms) {
          document.getElementById("totalRooms").textContent =
            stats.rooms.total || 0;
          document.getElementById("onlineRooms").textContent =
            "在线: " + (stats.rooms.online || 0);
        }

        if (stats.orders) {
          document.getElementById("totalOrders").textContent =
            stats.orders.total || 0;
          document.getElementById("pendingOrders").textContent =
            "待处理: " + (stats.orders.pending || 0);
        }

        if (stats.revenue) {
          document.getElementById("totalRevenue").textContent =
            "¥" + (stats.revenue.total || 0).toFixed(2);
          document.getElementById("revenueToday").textContent =
            "今日: ¥" + (stats.revenue.today || 0).toFixed(2);
        }


      }




    </script>
  </body>
</html>
