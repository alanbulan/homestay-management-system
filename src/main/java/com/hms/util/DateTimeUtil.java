package com.hms.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

/**
 * 日期时间工具类
 */
public class DateTimeUtil {
    
    /**
     * 常用日期格式
     */
    public static final String DATE_PATTERN = "yyyy-MM-dd";
    public static final String DATETIME_PATTERN = "yyyy-MM-dd HH:mm:ss";
    public static final String TIME_PATTERN = "HH:mm:ss";
    public static final String COMPACT_DATE_PATTERN = "yyyyMMdd";
    public static final String COMPACT_DATETIME_PATTERN = "yyyyMMddHHmmss";
    
    /**
     * 常用格式化器
     */
    public static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern(DATE_PATTERN);
    public static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern(DATETIME_PATTERN);
    public static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern(TIME_PATTERN);
    public static final DateTimeFormatter COMPACT_DATE_FORMATTER = DateTimeFormatter.ofPattern(COMPACT_DATE_PATTERN);
    public static final DateTimeFormatter COMPACT_DATETIME_FORMATTER = DateTimeFormatter.ofPattern(COMPACT_DATETIME_PATTERN);
    
    /**
     * 获取当前日期字符串
     * 
     * @return yyyy-MM-dd格式的日期字符串
     */
    public static String getCurrentDate() {
        return LocalDate.now().format(DATE_FORMATTER);
    }
    
    /**
     * 获取当前日期时间字符串
     * 
     * @return yyyy-MM-dd HH:mm:ss格式的日期时间字符串
     */
    public static String getCurrentDateTime() {
        return LocalDateTime.now().format(DATETIME_FORMATTER);
    }
    
    /**
     * 格式化日期
     * 
     * @param date 日期
     * @return yyyy-MM-dd格式的日期字符串
     */
    public static String formatDate(LocalDate date) {
        return date == null ? null : date.format(DATE_FORMATTER);
    }
    
    /**
     * 格式化日期时间
     * 
     * @param dateTime 日期时间
     * @return yyyy-MM-dd HH:mm:ss格式的日期时间字符串
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        return dateTime == null ? null : dateTime.format(DATETIME_FORMATTER);
    }
    
    /**
     * 解析日期字符串
     * 
     * @param dateStr yyyy-MM-dd格式的日期字符串
     * @return LocalDate对象
     */
    public static LocalDate parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(dateStr, DATE_FORMATTER);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 解析日期时间字符串
     * 
     * @param dateTimeStr yyyy-MM-dd HH:mm:ss格式的日期时间字符串
     * @return LocalDateTime对象
     */
    public static LocalDateTime parseDateTime(String dateTimeStr) {
        if (dateTimeStr == null || dateTimeStr.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDateTime.parse(dateTimeStr, DATETIME_FORMATTER);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 计算两个日期之间的天数
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 天数差（endDate - startDate）
     */
    public static long daysBetween(LocalDate startDate, LocalDate endDate) {
        if (startDate == null || endDate == null) {
            return 0;
        }
        return ChronoUnit.DAYS.between(startDate, endDate);
    }
    
    /**
     * 计算两个日期时间之间的小时数
     * 
     * @param startDateTime 开始日期时间
     * @param endDateTime 结束日期时间
     * @return 小时数差
     */
    public static long hoursBetween(LocalDateTime startDateTime, LocalDateTime endDateTime) {
        if (startDateTime == null || endDateTime == null) {
            return 0;
        }
        return ChronoUnit.HOURS.between(startDateTime, endDateTime);
    }
    
    /**
     * 判断日期是否在指定范围内
     * 
     * @param date 要检查的日期
     * @param startDate 开始日期（包含）
     * @param endDate 结束日期（包含）
     * @return 是否在范围内
     */
    public static boolean isDateInRange(LocalDate date, LocalDate startDate, LocalDate endDate) {
        if (date == null || startDate == null || endDate == null) {
            return false;
        }
        return !date.isBefore(startDate) && !date.isAfter(endDate);
    }
    
    /**
     * 判断是否为今天
     * 
     * @param date 日期
     * @return 是否为今天
     */
    public static boolean isToday(LocalDate date) {
        return date != null && date.equals(LocalDate.now());
    }
    
    /**
     * 判断是否为过去的日期
     * 
     * @param date 日期
     * @return 是否为过去的日期
     */
    public static boolean isPastDate(LocalDate date) {
        return date != null && date.isBefore(LocalDate.now());
    }
    
    /**
     * 判断是否为未来的日期
     * 
     * @param date 日期
     * @return 是否为未来的日期
     */
    public static boolean isFutureDate(LocalDate date) {
        return date != null && date.isAfter(LocalDate.now());
    }
    
    /**
     * 获取指定日期的开始时间（00:00:00）
     * 
     * @param date 日期
     * @return 该日期的开始时间
     */
    public static LocalDateTime getStartOfDay(LocalDate date) {
        return date == null ? null : date.atStartOfDay();
    }
    
    /**
     * 获取指定日期的结束时间（23:59:59）
     * 
     * @param date 日期
     * @return 该日期的结束时间
     */
    public static LocalDateTime getEndOfDay(LocalDate date) {
        return date == null ? null : date.atTime(23, 59, 59);
    }
    
    /**
     * 获取友好的时间描述
     * 
     * @param dateTime 日期时间
     * @return 友好的时间描述，如"刚刚"、"5分钟前"、"2小时前"等
     */
    public static String getFriendlyTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        
        LocalDateTime now = LocalDateTime.now();
        long minutes = ChronoUnit.MINUTES.between(dateTime, now);
        
        if (minutes < 1) {
            return "刚刚";
        } else if (minutes < 60) {
            return minutes + "分钟前";
        } else if (minutes < 1440) { // 24小时
            long hours = minutes / 60;
            return hours + "小时前";
        } else if (minutes < 10080) { // 7天
            long days = minutes / 1440;
            return days + "天前";
        } else {
            return formatDateTime(dateTime);
        }
    }
    
    /**
     * 验证日期字符串格式
     * 
     * @param dateStr 日期字符串
     * @param pattern 日期格式
     * @return 是否有效
     */
    public static boolean isValidDate(String dateStr, String pattern) {
        if (dateStr == null || pattern == null) {
            return false;
        }
        
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
            LocalDate.parse(dateStr, formatter);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 验证日期时间字符串格式
     * 
     * @param dateTimeStr 日期时间字符串
     * @param pattern 日期时间格式
     * @return 是否有效
     */
    public static boolean isValidDateTime(String dateTimeStr, String pattern) {
        if (dateTimeStr == null || pattern == null) {
            return false;
        }
        
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
            LocalDateTime.parse(dateTimeStr, formatter);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
