<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🌸 用户登录 - HMS</title>
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
            animation: float 30s infinite linear;
            pointer-events: none;
        }
        
        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0px); }
        }
        
        .login-container {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-heavy);
            padding: var(--spacing-2xl);
            width: 100%;
            max-width: 400px;
            position: relative;
            z-index: 1;
            animation: slideIn 0.8s ease-out;
        }
        
        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--accent-color));
            border-radius: var(--border-radius-large) var(--border-radius-large) 0 0;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: var(--spacing-xl);
        }
        
        .login-title {
            font-size: var(--font-size-2xl);
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--spacing-sm);
            font-weight: 700;
        }
        
        .login-subtitle {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }
        
        .form-group {
            margin-bottom: var(--spacing-lg);
            position: relative;
        }
        
        .form-label {
            display: block;
            margin-bottom: var(--spacing-sm);
            font-weight: 500;
            color: var(--text-primary);
            font-size: var(--font-size-sm);
        }
        
        .form-control {
            width: 100%;
            padding: var(--spacing-md);
            font-size: var(--font-size-base);
            border: 2px solid var(--border-color);
            border-radius: var(--border-radius);
            background: var(--bg-primary);
            transition: all var(--transition-fast);
            min-height: 48px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(107, 115, 255, 0.1);
            transform: translateY(-1px);
        }
        
        .form-control::placeholder {
            color: var(--text-light);
        }
        
        .form-icon {
            position: absolute;
            left: var(--spacing-md);
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            font-size: var(--font-size-lg);
            pointer-events: none;
            transition: all var(--transition-fast);
        }
        
        .form-control:focus + .form-icon {
            color: var(--primary-color);
        }
        
        .form-control-icon {
            padding-left: calc(var(--spacing-md) + var(--spacing-xl));
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            margin-bottom: var(--spacing-lg);
        }
        
        .checkbox {
            width: 18px;
            height: 18px;
            border: 2px solid var(--border-color);
            border-radius: 4px;
            position: relative;
            cursor: pointer;
            transition: all var(--transition-fast);
            display: inline-block;
        }

        .checkbox input {
            opacity: 0;
            position: absolute;
            width: 100%;
            height: 100%;
            margin: 0;
            cursor: pointer;
            z-index: 1;
        }

        .checkmark {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 4px;
            transition: all var(--transition-fast);
        }

        .checkbox input:checked + .checkmark {
            background: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .checkbox input:checked + .checkmark::after {
            content: '✓';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 12px;
            font-weight: bold;
        }

        .checkbox:hover {
            border-color: var(--primary-color);
        }
        
        .login-btn {
            width: 100%;
            padding: var(--spacing-md);
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-size: var(--font-size-base);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
            min-height: 48px;
        }
        
        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left var(--transition-normal);
        }
        
        .login-btn:hover::before {
            left: 100%;
        }
        
        .login-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }
        
        .login-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .login-footer {
            text-align: center;
            margin-top: var(--spacing-xl);
            padding-top: var(--spacing-lg);
            border-top: 1px solid var(--border-color);
        }
        
        .login-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-size: var(--font-size-sm);
            transition: all var(--transition-fast);
        }
        
        .login-footer a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }
        
        .error-message {
            background: linear-gradient(135deg, #ffe6e6, #ffcccc);
            color: var(--error-color);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-small);
            margin-bottom: var(--spacing-md);
            font-size: var(--font-size-sm);
            border-left: 4px solid var(--error-color);
            animation: shake 0.5s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
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
            .login-container {
                margin: var(--spacing-md);
                padding: var(--spacing-lg);
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1 class="login-title">🌸 用户登录</h1>
            <p class="login-subtitle">欢迎回到HMS民宿管理系统</p>
        </div>
        
        <div id="message-container"></div>
        
        <form id="loginForm">
            <div class="form-group">
                <label class="form-label" for="username">👤 用户名</label>
                <div style="position: relative;">
                    <input type="text" id="username" name="username" class="form-control form-control-icon" 
                           placeholder="请输入用户名" required>
                    <span class="form-icon">👤</span>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="password">🔒 密码</label>
                <div style="position: relative;">
                    <input type="password" id="password" name="password" class="form-control form-control-icon" 
                           placeholder="请输入密码" required>
                    <span class="form-icon">🔒</span>
                </div>
            </div>
            
            <div class="remember-me">
                <div class="checkbox">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <span class="checkmark"></span>
                </div>
                <label for="rememberMe" style="cursor: pointer; font-size: var(--font-size-sm);">记住我</label>
            </div>
            
            <button type="submit" class="login-btn" id="loginBtn">
                ✨ 登录
            </button>
        </form>
        
        <div class="login-footer">
            <p style="margin-bottom: var(--spacing-sm); color: var(--text-secondary); font-size: var(--font-size-sm);">
                还没有账户？
            </p>
            <a href="${pageContext.request.contextPath}/user/register">🎀 立即注册</a>
            <span style="margin: 0 var(--spacing-sm); color: var(--text-light);">|</span>
            <a href="${pageContext.request.contextPath}/">🏠 返回首页</a>
        </div>
    </div>
    
    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const rememberMe = document.getElementById('rememberMe').checked;
            const loginBtn = document.getElementById('loginBtn');
            
            if (!username || !password) {
                showMessage('请填写完整的登录信息', 'error');
                return;
            }
            
            // 禁用按钮
            loginBtn.disabled = true;
            loginBtn.innerHTML = '🔄 登录中...';
            
            // 发送登录请求
            fetch('${pageContext.request.contextPath}/user/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    username: username,
                    password: password,
                    rememberMe: rememberMe
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    showMessage('登录成功！正在跳转...', 'success');
                    setTimeout(() => {
                        // 根据用户类型跳转到不同页面
                        if (data.data && data.data.userType === 1) {
                            // 管理员跳转到管理后台
                            window.location.href = '${pageContext.request.contextPath}/admin';
                        } else {
                            // 普通用户跳转到房源列表
                            window.location.href = '${pageContext.request.contextPath}/room/list';
                        }
                    }, 1500);
                } else {
                    showMessage(data.message || '登录失败', 'error');
                }
            })
            .catch(error => {
                console.error('登录错误:', error);
                showMessage('网络错误，请稍后重试', 'error');
            })
            .finally(() => {
                // 恢复按钮
                loginBtn.disabled = false;
                loginBtn.innerHTML = '✨ 登录';
            });
        });
        
        function showMessage(message, type) {
            const container = document.getElementById('message-container');
            const messageDiv = document.createElement('div');
            messageDiv.className = type === 'error' ? 'error-message' : 'success-message';
            messageDiv.textContent = message;
            
            container.innerHTML = '';
            container.appendChild(messageDiv);
            
            // 3秒后自动消失
            setTimeout(() => {
                if (messageDiv.parentNode) {
                    messageDiv.remove();
                }
            }, 3000);
        }
        
        // 输入框焦点效果
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentNode.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('blur', function() {
                this.parentNode.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>
