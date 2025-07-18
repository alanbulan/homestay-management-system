package com.hms.dto;

import java.io.Serializable;

/**
 * 用户登录DTO
 */
public class LoginDTO implements Serializable {
    
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
     * 记住我
     */
    private Boolean rememberMe;
    
    // 构造方法
    public LoginDTO() {}
    
    public LoginDTO(String username, String password) {
        this.username = username;
        this.password = password;
        this.rememberMe = false;
    }
    
    public LoginDTO(String username, String password, Boolean rememberMe) {
        this.username = username;
        this.password = password;
        this.rememberMe = rememberMe;
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
    
    public Boolean getRememberMe() {
        return rememberMe;
    }
    
    public void setRememberMe(Boolean rememberMe) {
        this.rememberMe = rememberMe;
    }
    
    /**
     * 验证数据有效性
     */
    public boolean isValid() {
        return username != null && !username.trim().isEmpty() &&
               password != null && !password.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "LoginDTO{" +
                "username='" + username + '\'' +
                ", password='***'" +
                ", rememberMe=" + rememberMe +
                '}';
    }
}
