package com.hms.config;

import com.hms.vo.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;

/**
 * 全局异常处理器
 */
@ControllerAdvice
public class GlobalExceptionHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
    
    /**
     * 处理数据库异常
     */
    @ExceptionHandler({SQLException.class, DataAccessException.class})
    @ResponseBody
    public Result<Void> handleDatabaseException(Exception e, HttpServletRequest request) {
        logger.error("数据库异常: {} - {}", request.getRequestURI(), e.getMessage(), e);
        
        if (isAjaxRequest(request)) {
            return Result.error("数据库操作失败，请稍后重试");
        }
        
        return Result.error("系统繁忙，请稍后重试");
    }
    
    /**
     * 处理空指针异常
     */
    @ExceptionHandler(NullPointerException.class)
    @ResponseBody
    public Result<Void> handleNullPointerException(NullPointerException e, HttpServletRequest request) {
        logger.error("空指针异常: {} - {}", request.getRequestURI(), e.getMessage(), e);
        
        if (isAjaxRequest(request)) {
            return Result.error("系统内部错误");
        }
        
        return Result.error("系统异常，请联系管理员");
    }
    
    /**
     * 处理参数异常
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseBody
    public Result<Void> handleIllegalArgumentException(IllegalArgumentException e, HttpServletRequest request) {
        logger.warn("参数异常: {} - {}", request.getRequestURI(), e.getMessage());
        
        return Result.badRequest(e.getMessage());
    }
    
    /**
     * 处理运行时异常
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseBody
    public Result<Void> handleRuntimeException(RuntimeException e, HttpServletRequest request) {
        logger.error("运行时异常: {} - {}", request.getRequestURI(), e.getMessage(), e);
        
        if (isAjaxRequest(request)) {
            return Result.error("操作失败：" + e.getMessage());
        }
        
        return Result.error("系统异常，请稍后重试");
    }
    
    /**
     * 处理所有其他异常
     */
    @ExceptionHandler(Exception.class)
    public Object handleGenericException(Exception e, HttpServletRequest request) {
        logger.error("未处理的异常: {} - {}", request.getRequestURI(), e.getMessage(), e);
        
        if (isAjaxRequest(request)) {
            return Result.error("系统异常，请稍后重试");
        }
        
        // 对于非AJAX请求，返回错误页面
        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/500");
        mav.addObject("error", "系统异常，请稍后重试");
        mav.addObject("message", e.getMessage());
        mav.addObject("url", request.getRequestURI());
        return mav;
    }
    
    /**
     * 处理404错误
     */
    @ExceptionHandler(org.springframework.web.servlet.NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public Object handleNotFoundException(Exception e, HttpServletRequest request) {
        logger.warn("404错误: {} - {}", request.getRequestURI(), e.getMessage());
        
        if (isAjaxRequest(request)) {
            return Result.notFound("请求的资源不存在");
        }
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/404");
        mav.addObject("error", "页面不存在");
        mav.addObject("url", request.getRequestURI());
        return mav;
    }
    
    /**
     * 处理方法不支持异常
     */
    @ExceptionHandler(org.springframework.web.HttpRequestMethodNotSupportedException.class)
    @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
    @ResponseBody
    public Result<Void> handleMethodNotSupportedException(Exception e, HttpServletRequest request) {
        logger.warn("方法不支持异常: {} - {}", request.getRequestURI(), e.getMessage());
        
        return Result.error(405, "请求方法不支持");
    }
    
    /**
     * 处理媒体类型不支持异常
     */
    @ExceptionHandler(org.springframework.web.HttpMediaTypeNotSupportedException.class)
    @ResponseStatus(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
    @ResponseBody
    public Result<Void> handleMediaTypeNotSupportedException(Exception e, HttpServletRequest request) {
        logger.warn("媒体类型不支持异常: {} - {}", request.getRequestURI(), e.getMessage());
        
        return Result.error(415, "不支持的媒体类型");
    }
    
    /**
     * 处理参数绑定异常
     */
    @ExceptionHandler(org.springframework.web.bind.MissingServletRequestParameterException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    public Result<Void> handleMissingParameterException(
            org.springframework.web.bind.MissingServletRequestParameterException e, 
            HttpServletRequest request) {
        logger.warn("缺少请求参数: {} - {}", request.getRequestURI(), e.getMessage());
        
        return Result.badRequest("缺少必需的参数: " + e.getParameterName());
    }
    
    /**
     * 处理类型转换异常
     */
    @ExceptionHandler(org.springframework.beans.TypeMismatchException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    public Result<Void> handleTypeMismatchException(
            org.springframework.beans.TypeMismatchException e, 
            HttpServletRequest request) {
        logger.warn("类型转换异常: {} - {}", request.getRequestURI(), e.getMessage());
        
        return Result.badRequest("参数类型错误: " + e.getPropertyName());
    }
    
    /**
     * 判断是否为AJAX请求
     * 
     * @param request HTTP请求
     * @return 是否为AJAX请求
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        String contentType = request.getHeader("Content-Type");
        
        return "XMLHttpRequest".equals(requestedWith) ||
               (accept != null && accept.contains("application/json")) ||
               (contentType != null && contentType.contains("application/json"));
    }
}
