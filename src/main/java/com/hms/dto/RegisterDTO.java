package com.hms.dto;

import java.io.Serializable;

/**
 * 用户注册DTO
 */
public class RegisterDTO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 用户名
     */
    private String username;
    
    /**
     * 密码
     */
    private String password;
    
    /**
     * 确认密码
     */
    private String confirmPassword;
    
    /**
     * 邮箱
     */
    private String email;
    
    /**
     * 手机号
     */
    private String phone;
    
    /**
     * 真实姓名
     */
    private String realName;
    
    // 构造方法
    public RegisterDTO() {}
    
    public RegisterDTO(String username, String password, String confirmPassword, 
                       String email, String realName) {
        this.username = username;
        this.password = password;
        this.confirmPassword = confirmPassword;
        this.email = email;
        this.realName = realName;
    }
    
    // Getter和Setter方法
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getConfirmPassword() {
        return confirmPassword;
    }
    
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getRealName() {
        return realName;
    }
    
    public void setRealName(String realName) {
        this.realName = realName;
    }
    
    /**
     * 验证数据有效性
     */
    public boolean isValid() {
        // 检查必填字段
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return false;
        }
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        if (realName == null || realName.trim().isEmpty()) {
            return false;
        }
        
        // 检查密码一致性
        if (!password.equals(confirmPassword)) {
            return false;
        }
        
        // 检查用户名长度
        if (username.length() < 3 || username.length() > 20) {
            return false;
        }
        
        // 检查密码长度
        if (password.length() < 6 || password.length() > 20) {
            return false;
        }
        
        // 简单的邮箱格式验证
        if (!email.contains("@") || !email.contains(".")) {
            return false;
        }
        
        return true;
    }
    
    /**
     * 获取验证错误信息
     */
    public String getValidationError() {
        if (username == null || username.trim().isEmpty()) {
            return "用户名不能为空";
        }
        if (username.length() < 3 || username.length() > 20) {
            return "用户名长度必须在3-20个字符之间";
        }
        if (password == null || password.trim().isEmpty()) {
            return "密码不能为空";
        }
        if (password.length() < 6 || password.length() > 20) {
            return "密码长度必须在6-20个字符之间";
        }
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return "确认密码不能为空";
        }
        if (!password.equals(confirmPassword)) {
            return "两次输入的密码不一致";
        }
        if (email == null || email.trim().isEmpty()) {
            return "邮箱不能为空";
        }
        if (!email.contains("@") || !email.contains(".")) {
            return "邮箱格式不正确";
        }
        if (realName == null || realName.trim().isEmpty()) {
            return "真实姓名不能为空";
        }
        return null;
    }
    
    @Override
    public String toString() {
        return "RegisterDTO{" +
                "username='" + username + '\'' +
                ", password='***'" +
                ", confirmPassword='***'" +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", realName='" + realName + '\'' +
                '}';
    }
}
