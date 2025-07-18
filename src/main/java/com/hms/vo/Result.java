package com.hms.vo;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 统一响应结果类
 */
public class Result<T> implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 响应码
     */
    private Integer code;
    
    /**
     * 响应消息
     */
    private String message;
    
    /**
     * 响应数据
     */
    private T data;
    
    /**
     * 响应时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime timestamp;
    
    // 构造方法
    public Result() {
        this.timestamp = LocalDateTime.now();
    }
    
    public Result(Integer code, String message) {
        this();
        this.code = code;
        this.message = message;
    }
    
    public Result(Integer code, String message, T data) {
        this(code, message);
        this.data = data;
    }
    
    // 成功响应
    public static <T> Result<T> success() {
        return new Result<>(200, "操作成功");
    }
    
    public static <T> Result<T> success(T data) {
        return new Result<>(200, "操作成功", data);
    }
    
    public static <T> Result<T> success(String message, T data) {
        return new Result<>(200, message, data);
    }
    
    // 失败响应
    public static <T> Result<T> error() {
        return new Result<>(500, "操作失败");
    }
    
    public static <T> Result<T> error(String message) {
        return new Result<>(500, message);
    }
    
    public static <T> Result<T> error(Integer code, String message) {
        return new Result<>(code, message);
    }
    
    // 参数错误
    public static <T> Result<T> badRequest(String message) {
        return new Result<>(400, message);
    }
    
    // 未授权
    public static <T> Result<T> unauthorized() {
        return new Result<>(401, "未授权访问");
    }
    
    public static <T> Result<T> unauthorized(String message) {
        return new Result<>(401, message);
    }
    
    // 禁止访问
    public static <T> Result<T> forbidden() {
        return new Result<>(403, "禁止访问");
    }
    
    public static <T> Result<T> forbidden(String message) {
        return new Result<>(403, message);
    }
    
    // 资源不存在
    public static <T> Result<T> notFound() {
        return new Result<>(404, "资源不存在");
    }
    
    public static <T> Result<T> notFound(String message) {
        return new Result<>(404, message);
    }
    
    // Getter和Setter方法
    public Integer getCode() {
        return code;
    }
    
    public void setCode(Integer code) {
        this.code = code;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public T getData() {
        return data;
    }
    
    public void setData(T data) {
        this.data = data;
    }
    
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
    
    /**
     * 判断是否成功
     */
    public boolean isSuccess() {
        return code != null && code == 200;
    }
    
    @Override
    public String toString() {
        return "Result{" +
                "code=" + code +
                ", message='" + message + '\'' +
                ", data=" + data +
                ", timestamp=" + timestamp +
                '}';
    }
}
