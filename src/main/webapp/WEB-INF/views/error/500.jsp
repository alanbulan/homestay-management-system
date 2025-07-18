<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>😵 服务器错误 - HMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/background.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: var(--spacing-lg);
        }
        
        /* 背景装饰 */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="40" cy="80" r="1.5" fill="rgba(255,255,255,0.1)"/></svg>') repeat;
            animation: float 20s infinite linear;
            pointer-events: none;
        }
        
        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0px); }
        }
        
        .error-container {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-heavy);
            padding: var(--spacing-2xl);
            text-align: center;
            max-width: 500px;
            width: 90%;
            position: relative;
            z-index: 1;
            animation: slideIn 0.8s ease-out;
        }
        
        .error-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--error-color), var(--warning-color), var(--primary-color));
            border-radius: var(--border-radius-large) var(--border-radius-large) 0 0;
        }
        
        .error-icon {
            font-size: 6rem;
            margin-bottom: var(--spacing-lg);
            opacity: 0.8;
        }
        
        .error-title {
            font-size: var(--font-size-3xl);
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: var(--spacing-md);
        }
        
        .error-message {
            color: var(--text-secondary);
            font-size: var(--font-size-lg);
            margin-bottom: var(--spacing-xl);
            line-height: 1.6;
        }
        
        .error-actions {
            display: flex;
            gap: var(--spacing-md);
            justify-content: center;
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
        
        @keyframes slideIn {
            from { 
                opacity: 0; 
                transform: translateY(30px) scale(0.95); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0) scale(1); 
            }
        }
        
        /* 响应式 */
        @media (max-width: 480px) {
            .error-container {
                margin: var(--spacing-md);
                padding: var(--spacing-lg);
            }
            
            .error-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">😵</div>
        <h1 class="error-title">服务器错误</h1>
        <p class="error-message">
            抱歉，服务器遇到了一个错误，无法完成您的请求。<br>
            我们正在努力修复这个问题，请稍后再试。
        </p>
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                🏠 返回首页
            </a>
            <button onclick="location.reload()" class="btn btn-secondary">
                🔄 刷新页面
            </button>
        </div>
    </div>
</body>
</html>
