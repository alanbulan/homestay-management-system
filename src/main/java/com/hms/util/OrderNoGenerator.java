package com.hms.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 订单号生成工具类
 */
public class OrderNoGenerator {
    
    /**
     * 订单号前缀
     */
    private static final String ORDER_PREFIX = "HMS";
    
    /**
     * 日期格式化器
     */
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    
    /**
     * 序列号计数器
     */
    private static final AtomicInteger SEQUENCE = new AtomicInteger(1000);
    
    /**
     * 生成订单号
     * 格式：HMS + yyyyMMddHHmmss + 4位序列号
     * 例如：HMS202501160830001001
     * 
     * @return 订单号
     */
    public static String generate() {
        // 获取当前时间
        String dateTime = LocalDateTime.now().format(DATE_FORMATTER);
        
        // 获取序列号（循环使用1000-9999）
        int seq = SEQUENCE.getAndIncrement();
        if (seq > 9999) {
            SEQUENCE.set(1000);
            seq = SEQUENCE.getAndIncrement();
        }
        
        // 拼接订单号
        return ORDER_PREFIX + dateTime + String.format("%04d", seq);
    }
    
    /**
     * 验证订单号格式
     * 
     * @param orderNo 订单号
     * @return 是否有效
     */
    public static boolean isValid(String orderNo) {
        if (orderNo == null || orderNo.length() != 21) {
            return false;
        }
        
        // 检查前缀
        if (!orderNo.startsWith(ORDER_PREFIX)) {
            return false;
        }
        
        // 检查后面的部分是否都是数字
        String numberPart = orderNo.substring(ORDER_PREFIX.length());
        try {
            Long.parseLong(numberPart);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * 从订单号中提取日期时间
     * 
     * @param orderNo 订单号
     * @return 日期时间字符串，格式：yyyy-MM-dd HH:mm:ss
     */
    public static String extractDateTime(String orderNo) {
        if (!isValid(orderNo)) {
            return null;
        }
        
        try {
            String dateTimePart = orderNo.substring(ORDER_PREFIX.length(), ORDER_PREFIX.length() + 14);
            LocalDateTime dateTime = LocalDateTime.parse(dateTimePart, DATE_FORMATTER);
            return dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 从订单号中提取序列号
     * 
     * @param orderNo 订单号
     * @return 序列号
     */
    public static Integer extractSequence(String orderNo) {
        if (!isValid(orderNo)) {
            return null;
        }
        
        try {
            String sequencePart = orderNo.substring(ORDER_PREFIX.length() + 14);
            return Integer.parseInt(sequencePart);
        } catch (Exception e) {
            return null;
        }
    }
}
