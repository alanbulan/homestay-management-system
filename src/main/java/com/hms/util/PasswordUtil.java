package com.hms.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * 密码加密工具类
 */
public class PasswordUtil {
    
    /**
     * 盐值长度
     */
    private static final int SALT_LENGTH = 16;
    
    /**
     * 加密算法
     */
    private static final String ALGORITHM = "SHA-256";
    
    /**
     * 生成随机盐值
     * 
     * @return Base64编码的盐值
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * 使用盐值加密密码
     * 
     * @param password 原始密码
     * @param salt 盐值
     * @return 加密后的密码
     */
    public static String encrypt(String password, String salt) {
        if (password == null || salt == null) {
            throw new IllegalArgumentException("密码和盐值不能为空");
        }
        
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            
            // 将盐值和密码组合
            String saltedPassword = salt + password;
            byte[] hashedBytes = md.digest(saltedPassword.getBytes());
            
            // 转换为Base64编码
            return Base64.getEncoder().encodeToString(hashedBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("加密算法不支持", e);
        }
    }
    
    /**
     * 加密密码（自动生成盐值）
     * 
     * @param password 原始密码
     * @return 格式：盐值$加密密码
     */
    public static String encrypt(String password) {
        if (password == null) {
            throw new IllegalArgumentException("密码不能为空");
        }
        
        String salt = generateSalt();
        String encryptedPassword = encrypt(password, salt);
        return salt + "$" + encryptedPassword;
    }
    
    /**
     * 验证密码
     * 
     * @param password 原始密码
     * @param encryptedPassword 加密后的密码（格式：盐值$加密密码）
     * @return 是否匹配
     */
    public static boolean verify(String password, String encryptedPassword) {
        if (password == null || encryptedPassword == null) {
            return false;
        }
        
        try {
            // 分离盐值和加密密码
            String[] parts = encryptedPassword.split("\\$");
            if (parts.length != 2) {
                return false;
            }
            
            String salt = parts[0];
            String storedHash = parts[1];
            
            // 使用相同的盐值加密输入的密码
            String inputHash = encrypt(password, salt);
            
            // 比较加密结果
            return storedHash.equals(inputHash);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 简单MD5加密（用于兼容旧数据）
     * 
     * @param password 原始密码
     * @return MD5加密后的密码
     */
    public static String md5(String password) {
        if (password == null) {
            throw new IllegalArgumentException("密码不能为空");
        }
        
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashedBytes = md.digest(password.getBytes());
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5算法不支持", e);
        }
    }
    
    /**
     * 验证MD5密码
     * 
     * @param password 原始密码
     * @param md5Password MD5加密的密码
     * @return 是否匹配
     */
    public static boolean verifyMd5(String password, String md5Password) {
        if (password == null || md5Password == null) {
            return false;
        }
        
        try {
            return md5(password).equals(md5Password.toLowerCase());
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 检查密码强度
     * 
     * @param password 密码
     * @return 强度等级：0-弱，1-中，2-强
     */
    public static int checkStrength(String password) {
        if (password == null || password.length() < 6) {
            return 0; // 弱
        }
        
        int score = 0;
        
        // 长度检查
        if (password.length() >= 8) {
            score++;
        }
        
        // 包含数字
        if (password.matches(".*\\d.*")) {
            score++;
        }
        
        // 包含小写字母
        if (password.matches(".*[a-z].*")) {
            score++;
        }
        
        // 包含大写字母
        if (password.matches(".*[A-Z].*")) {
            score++;
        }
        
        // 包含特殊字符
        if (password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
            score++;
        }
        
        // 根据得分返回强度等级
        if (score <= 2) {
            return 0; // 弱
        } else if (score <= 3) {
            return 1; // 中
        } else {
            return 2; // 强
        }
    }
    
    /**
     * 获取密码强度描述
     * 
     * @param password 密码
     * @return 强度描述
     */
    public static String getStrengthDescription(String password) {
        int strength = checkStrength(password);
        switch (strength) {
            case 0: return "弱";
            case 1: return "中";
            case 2: return "强";
            default: return "未知";
        }
    }
}
