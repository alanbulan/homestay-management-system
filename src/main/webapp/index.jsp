<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🏠 HMS - 民宿管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/background.css">
    <style>
        body {
            padding: var(--spacing-lg);
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .hero-section {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-heavy);
            padding: var(--spacing-2xl);
            text-align: center;
            margin-bottom: var(--spacing-xl);
            position: relative;
            animation: fadeIn 0.8s ease-out;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--accent-color));
            border-radius: var(--border-radius-large) var(--border-radius-large) 0 0;
        }

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
        }

        .stat-card {
            background: var(--bg-primary);
            border-radius: var(--border-radius);
            padding: var(--spacing-lg);
            text-align: center;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
            border-color: var(--primary-color);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: var(--spacing-xs);
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
            font-weight: 500;
        }

        .logo {
            font-size: 3rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--spacing-sm);
            font-weight: 700;
            letter-spacing: 2px;
        }

        .subtitle {
            color: var(--text-secondary);
            margin-bottom: var(--spacing-xl);
            font-size: var(--font-size-lg);
            font-weight: 300;
        }
        
        .btn-group {
            display: flex;
            gap: var(--spacing-md);
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: var(--spacing-xl);
        }

        .hero-btn {
            padding: var(--spacing-md) var(--spacing-xl);
            border: 2px solid transparent;
            border-radius: var(--border-radius);
            font-size: var(--font-size-base);
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: var(--spacing-sm);
            transition: all var(--transition-normal);
            min-width: 140px;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .hero-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left var(--transition-normal);
        }

        .hero-btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-secondary {
            background: var(--bg-primary);
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-secondary:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }
        
        .features {
            margin-top: var(--spacing-xl);
            text-align: left;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: var(--spacing-md);
            padding: var(--spacing-md);
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            transition: all var(--transition-fast);
            position: relative;
        }

        .feature-item:hover {
            transform: translateX(8px);
            border-color: var(--primary-color);
            background: rgba(107, 115, 255, 0.05);
        }

        .feature-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: var(--spacing-md);
            font-size: var(--font-size-lg);
            font-weight: 600;
            box-shadow: var(--shadow-light);
        }

        .feature-content h4 {
            color: var(--text-primary);
            margin-bottom: var(--spacing-xs);
            font-weight: 600;
        }

        .feature-content small {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
            line-height: 1.4;
        }

        .status {
            margin-top: var(--spacing-xl);
            padding: var(--spacing-lg);
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            border: 1px solid var(--success-color);
            border-radius: var(--border-radius);
            color: #155724;
            position: relative;
            overflow: hidden;
        }

        .status::before {
            content: '✨';
            position: absolute;
            top: var(--spacing-sm);
            right: var(--spacing-sm);
            font-size: var(--font-size-lg);
            opacity: 0.7;
        }

        .status.error {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            border-color: var(--error-color);
            color: #721c24;
        }

        .status.error::before {
            content: '⚠️';
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            body {
                padding: var(--spacing-md);
            }

            .hero-section {
                padding: var(--spacing-lg);
            }

            .logo {
                font-size: 2.5rem;
            }

            .btn-group {
                flex-direction: column;
                align-items: center;
            }

            .hero-btn {
                width: 100%;
                max-width: 280px;
            }

            .quick-stats {
                grid-template-columns: repeat(2, 1fr);
                gap: var(--spacing-md);
            }

            .feature-item {
                flex-direction: column;
                text-align: center;
            }

            .feature-icon {
                margin-right: 0;
                margin-bottom: var(--spacing-sm);
            }
        }

        @media (max-width: 480px) {
            .quick-stats {
                grid-template-columns: 1fr;
            }

            .stat-number {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- 主要介绍区域 -->
        <div class="hero-section">
            <div class="logo">🏠 HMS</div>
            <h1 style="color: var(--text-primary); margin-bottom: var(--spacing-sm); font-weight: 600;">民宿管理系统</h1>
            <p class="subtitle">✨ Homestay Management System ✨</p>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/room/list" class="hero-btn btn-primary">
                    🏡 浏览房源
                </a>
                <a href="${pageContext.request.contextPath}/user/login" class="hero-btn btn-secondary">
                    👤 用户登录
                </a>
                <a href="${pageContext.request.contextPath}/user/register" class="hero-btn btn-secondary">
                    📝 用户注册
                </a>
            </div>
        </div>

        <!-- 快速统计 -->
        <div class="quick-stats">
            <div class="stat-card">
                <div class="stat-number" id="roomCount">8</div>
                <div class="stat-label">🏠 精品房源</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="cityCount">8</div>
                <div class="stat-label">🌍 热门城市</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="imageCount">29</div>
                <div class="stat-label">📸 真实图片</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="orderCount">10</div>
                <div class="stat-label">📋 订单记录</div>
            </div>
        </div>

        <!-- 功能特性 -->
        <div class="features">
            <div class="feature-item">
                <div class="feature-icon">🏡</div>
                <div class="feature-content">
                    <h4>房源管理</h4>
                    <small>精品房源，覆盖北京、上海、杭州等热门城市，支持图片轮播展示</small>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">📅</div>
                <div class="feature-content">
                    <h4>在线预订</h4>
                    <small>便捷的在线预订系统，支持日期选择、人数设置和实时价格计算</small>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">👥</div>
                <div class="feature-content">
                    <h4>用户管理</h4>
                    <small>完整的用户注册登录体系，用户与管理员双端，支持权限管理</small>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">📊</div>
                <div class="feature-content">
                    <h4>订单跟踪</h4>
                    <small>全流程订单管理，订单数据统计，支持状态跟踪和历史查询</small>
                </div>
            </div>
        </div>

        <!-- 系统状态 -->
        <div class="status">
            <strong>🎯 系统状态：</strong> 正常运行<br>
            <small>版本：v1.0.0 | 基于SSM框架构建 | 数据已中文化 | 图片显示正常</small>
        </div>
    </div>

    <script>
        // 加载统计数据
        function loadStats() {
            fetch('${pageContext.request.contextPath}/api/stats')
                .then(response => response.json())
                .then(result => {
                    if (result.code === 200) {
                        const data = result.data;
                        document.getElementById('roomCount').textContent = data.roomCount || 8;
                        document.getElementById('cityCount').textContent = data.cityCount || 8;
                        document.getElementById('imageCount').textContent = data.imageCount || 29;
                        document.getElementById('orderCount').textContent = data.orderCount || 10;
                    } else {
                        console.error('获取统计数据失败:', result.message);
                    }
                })
                .catch(error => {
                    console.error('获取统计数据失败:', error);
                });
        }

        // 页面加载动画
        document.addEventListener('DOMContentLoaded', function() {
            // 加载统计数据
            loadStats();

            // 统计卡片动画
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.animation = 'fadeIn 0.6s ease-out ' + (index * 0.1) + 's both';
                }, 200);
            });

            // 功能特性动画
            const features = document.querySelectorAll('.feature-item');
            features.forEach((item, index) => {
                setTimeout(() => {
                    item.style.animation = 'fadeIn 0.6s ease-out ' + (index * 0.1) + 's both';
                }, 500);
            });
        });

        // 按钮点击效果
        document.querySelectorAll('.hero-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;

                ripple.style.cssText =
                    'position: absolute;' +
                    'width: ' + size + 'px;' +
                    'height: ' + size + 'px;' +
                    'left: ' + x + 'px;' +
                    'top: ' + y + 'px;' +
                    'background: rgba(255,255,255,0.3);' +
                    'border-radius: 50%;' +
                    'transform: scale(0);' +
                    'animation: ripple 0.6s ease-out;' +
                    'pointer-events: none;';

                this.appendChild(ripple);
                setTimeout(() => ripple.remove(), 600);
            });
        });
    </script>

    <style>
        @keyframes ripple {
            to { transform: scale(2); opacity: 0; }
        }
    </style>
</body>
</html>
