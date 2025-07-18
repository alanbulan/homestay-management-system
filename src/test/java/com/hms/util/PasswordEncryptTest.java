package com.hms.util;

import org.junit.Test;

/**
 * 密码加密测试工具
 * 用于生成加密密码，更新数据库
 */
public class PasswordEncryptTest {
    
    @Test
    public void generateEncryptedPasswords() {
        // 生成admin用户的加密密码
        String adminPassword = "admin123";
        String encryptedAdminPassword = PasswordUtil.encrypt(adminPassword);
        System.out.println("Admin用户加密密码: " + encryptedAdminPassword);
        
        // 生成testuser用户的加密密码
        String testPassword = "test123";
        String encryptedTestPassword = PasswordUtil.encrypt(testPassword);
        System.out.println("Test用户加密密码: " + encryptedTestPassword);
        
        // 验证加密是否正确
        boolean adminVerify = PasswordUtil.verify(adminPassword, encryptedAdminPassword);
        boolean testVerify = PasswordUtil.verify(testPassword, encryptedTestPassword);
        
        System.out.println("Admin密码验证: " + adminVerify);
        System.out.println("Test密码验证: " + testVerify);
        
        // 生成SQL更新语句
        System.out.println("\n=== SQL更新语句 ===");
        System.out.println("UPDATE user SET password = '" + encryptedAdminPassword + "' WHERE username = 'admin';");
        System.out.println("UPDATE user SET password = '" + encryptedTestPassword + "' WHERE username = 'testuser';");
    }
}
