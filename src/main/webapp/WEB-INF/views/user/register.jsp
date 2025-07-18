<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🎀 用户注册 - HMS</title>
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
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="30" cy="30" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="70" cy="20" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="20" cy="70" r="1.5" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="80" r="1" fill="rgba(255,255,255,0.1)"/></svg>') repeat;
            animation: float 25s infinite linear;
            pointer-events: none;
        }
        
        @keyframes float {
            0% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-15px) rotate(180deg); }
            100% { transform: translateY(0px) rotate(360deg); }
        }
        
        .register-container {
            background: var(--bg-primary);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-heavy);
            padding: var(--spacing-2xl);
            width: 100%;
            max-width: 450px;
            position: relative;
            z-index: 1;
            animation: slideIn 0.8s ease-out;
        }
        
        .register-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--secondary-color), var(--primary-color), var(--accent-color));
            border-radius: var(--border-radius-large) var(--border-radius-large) 0 0;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: var(--spacing-xl);
        }
        
        .register-title {
            font-size: var(--font-size-2xl);
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--spacing-sm);
            font-weight: 700;
        }
        
        .register-subtitle {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }
        
        .form-row {
            display: flex;
            gap: var(--spacing-md);
            margin-bottom: var(--spacing-lg);
        }
        
        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
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
        
        .password-strength {
            margin-top: var(--spacing-sm);
            font-size: var(--font-size-xs);
        }
        
        .strength-bar {
            height: 4px;
            background: var(--bg-tertiary);
            border-radius: 2px;
            margin-top: var(--spacing-xs);
            overflow: hidden;
        }
        
        .strength-fill {
            height: 100%;
            transition: all var(--transition-normal);
            border-radius: 2px;
        }
        
        .strength-weak { background: var(--error-color); width: 25%; }
        .strength-medium { background: var(--warning-color); width: 50%; }
        .strength-strong { background: var(--success-color); width: 75%; }
        .strength-very-strong { background: var(--accent-color); width: 100%; }
        
        .register-btn {
            width: 100%;
            padding: var(--spacing-md);
            background: var(--secondary-color);
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
        
        .register-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left var(--transition-normal);
        }
        
        .register-btn:hover::before {
            left: 100%;
        }
        
        .register-btn:hover {
            background: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }
        
        .register-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .register-footer {
            text-align: center;
            margin-top: var(--spacing-xl);
            padding-top: var(--spacing-lg);
            border-top: 1px solid var(--border-color);
        }
        
        .register-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-size: var(--font-size-sm);
            transition: all var(--transition-fast);
        }
        
        .register-footer a:hover {
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
        
        .field-error {
            color: var(--error-color);
            font-size: var(--font-size-xs);
            margin-top: var(--spacing-xs);
            display: none;
        }
        
        .form-control.error {
            border-color: var(--error-color);
        }
        
        .form-control.success {
            border-color: var(--success-color);
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
            .register-container {
                margin: var(--spacing-md);
                padding: var(--spacing-lg);
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .form-row .form-group {
                margin-bottom: var(--spacing-lg);
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1 class="register-title">🎀 用户注册</h1>
            <p class="register-subtitle">加入HMS民宿管理系统</p>
        </div>
        
        <div id="message-container"></div>
        
        <form id="registerForm">
            <div class="form-group">
                <label class="form-label" for="username">👤 用户名</label>
                <div style="position: relative;">
                    <input type="text" id="username" name="username" class="form-control form-control-icon" 
                           placeholder="请输入用户名（3-20个字符）" required>
                    <span class="form-icon">👤</span>
                </div>
                <div class="field-error" id="username-error"></div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="realName">🌸 真实姓名</label>
                    <input type="text" id="realName" name="realName" class="form-control" 
                           placeholder="请输入真实姓名" required>
                    <div class="field-error" id="realName-error"></div>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="phone">📱 手机号</label>
                    <input type="tel" id="phone" name="phone" class="form-control" 
                           placeholder="请输入手机号">
                    <div class="field-error" id="phone-error"></div>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="email">📧 邮箱地址</label>
                <div style="position: relative;">
                    <input type="email" id="email" name="email" class="form-control form-control-icon" 
                           placeholder="请输入邮箱地址" required>
                    <span class="form-icon">📧</span>
                </div>
                <div class="field-error" id="email-error"></div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="password">🔒 密码</label>
                <div style="position: relative;">
                    <input type="password" id="password" name="password" class="form-control form-control-icon" 
                           placeholder="请输入密码（至少6位）" required>
                    <span class="form-icon">🔒</span>
                </div>
                <div class="password-strength">
                    <div class="strength-bar">
                        <div class="strength-fill" id="strength-fill"></div>
                    </div>
                    <span id="strength-text" style="color: var(--text-light);">密码强度：未输入</span>
                </div>
                <div class="field-error" id="password-error"></div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="confirmPassword">🔐 确认密码</label>
                <div style="position: relative;">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control form-control-icon" 
                           placeholder="请再次输入密码" required>
                    <span class="form-icon">🔐</span>
                </div>
                <div class="field-error" id="confirmPassword-error"></div>
            </div>
            
            <button type="submit" class="register-btn" id="registerBtn">
                ✨ 立即注册
            </button>
        </form>
        
        <div class="register-footer">
            <p style="margin-bottom: var(--spacing-sm); color: var(--text-secondary); font-size: var(--font-size-sm);">
                已有账户？
            </p>
            <a href="${pageContext.request.contextPath}/user/login">🌸 立即登录</a>
            <span style="margin: 0 var(--spacing-sm); color: var(--text-light);">|</span>
            <a href="${pageContext.request.contextPath}/">🏠 返回首页</a>
        </div>
    </div>
    
    <script>
        // 表单验证规则
        const validators = {
            username: {
                required: true,
                minLength: 3,
                maxLength: 20,
                pattern: /^[a-zA-Z0-9_]+$/,
                message: '用户名只能包含字母、数字和下划线，长度3-20位'
            },
            realName: {
                required: true,
                minLength: 2,
                maxLength: 10,
                message: '真实姓名长度2-10位'
            },
            email: {
                required: true,
                pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                message: '请输入有效的邮箱地址'
            },
            phone: {
                required: false,
                pattern: /^1[3-9]\d{9}$/,
                message: '请输入有效的手机号'
            },
            password: {
                required: true,
                minLength: 6,
                message: '密码至少6位'
            },
            confirmPassword: {
                required: true,
                match: 'password',
                message: '两次输入的密码不一致'
            }
        };
        
        // 密码强度检测
        function checkPasswordStrength(password) {
            let strength = 0;
            let text = '弱';
            let className = 'strength-weak';
            
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            if (strength >= 5) {
                text = '很强';
                className = 'strength-very-strong';
            } else if (strength >= 4) {
                text = '强';
                className = 'strength-strong';
            } else if (strength >= 2) {
                text = '中等';
                className = 'strength-medium';
            }
            
            return { strength, text, className };
        }
        
        // 字段验证
        function validateField(fieldName, value) {
            const rule = validators[fieldName];
            if (!rule) return { valid: true };
            
            if (rule.required && (!value || value.trim() === '')) {
                return { valid: false, message: `${fieldName}不能为空` };
            }
            
            if (value && rule.minLength && value.length < rule.minLength) {
                return { valid: false, message: rule.message };
            }
            
            if (value && rule.maxLength && value.length > rule.maxLength) {
                return { valid: false, message: rule.message };
            }
            
            if (value && rule.pattern && !rule.pattern.test(value)) {
                return { valid: false, message: rule.message };
            }
            
            if (rule.match) {
                const matchValue = document.getElementById(rule.match).value;
                if (value !== matchValue) {
                    return { valid: false, message: rule.message };
                }
            }
            
            return { valid: true };
        }
        
        // 显示字段错误
        function showFieldError(fieldName, message) {
            const field = document.getElementById(fieldName);
            const errorDiv = document.getElementById(fieldName + '-error');
            
            field.classList.add('error');
            field.classList.remove('success');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
        }
        
        // 显示字段成功
        function showFieldSuccess(fieldName) {
            const field = document.getElementById(fieldName);
            const errorDiv = document.getElementById(fieldName + '-error');
            
            field.classList.remove('error');
            field.classList.add('success');
            errorDiv.style.display = 'none';
        }
        
        // 密码强度监听
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthFill = document.getElementById('strength-fill');
            const strengthText = document.getElementById('strength-text');
            
            if (!password) {
                strengthFill.className = 'strength-fill';
                strengthText.textContent = '密码强度：未输入';
                strengthText.style.color = 'var(--text-light)';
                return;
            }
            
            const result = checkPasswordStrength(password);
            strengthFill.className = `strength-fill ${result.className}`;
            strengthText.textContent = `密码强度：${result.text}`;
            
            if (result.className === 'strength-weak') {
                strengthText.style.color = 'var(--error-color)';
            } else if (result.className === 'strength-medium') {
                strengthText.style.color = 'var(--warning-color)';
            } else {
                strengthText.style.color = 'var(--success-color)';
            }
        });
        
        // 实时验证
        Object.keys(validators).forEach(fieldName => {
            const field = document.getElementById(fieldName);
            if (field) {
                field.addEventListener('blur', function() {
                    const result = validateField(fieldName, this.value);
                    if (result.valid) {
                        showFieldSuccess(fieldName);
                    } else {
                        showFieldError(fieldName, result.message);
                    }
                });
            }
        });
        
        // 表单提交
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 验证所有字段
            let isValid = true;
            const formData = {};
            
            Object.keys(validators).forEach(fieldName => {
                const field = document.getElementById(fieldName);
                if (field) {
                    const value = field.value;
                    formData[fieldName] = value;
                    
                    const result = validateField(fieldName, value);
                    if (result.valid) {
                        showFieldSuccess(fieldName);
                    } else {
                        showFieldError(fieldName, result.message);
                        isValid = false;
                    }
                }
            });
            
            if (!isValid) {
                showMessage('请检查表单信息', 'error');
                return;
            }
            
            const registerBtn = document.getElementById('registerBtn');
            registerBtn.disabled = true;
            registerBtn.innerHTML = '🔄 注册中...';
            
            // 发送注册请求
            fetch('${pageContext.request.contextPath}/user/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    showMessage('注册成功！正在跳转到房源列表...', 'success');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/room/list';
                    }, 2000);
                } else {
                    showMessage(data.message || '注册失败', 'error');
                }
            })
            .catch(error => {
                console.error('注册错误:', error);
                showMessage('网络错误，请稍后重试', 'error');
            })
            .finally(() => {
                registerBtn.disabled = false;
                registerBtn.innerHTML = '✨ 立即注册';
            });
        });
        
        function showMessage(message, type) {
            const container = document.getElementById('message-container');
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
