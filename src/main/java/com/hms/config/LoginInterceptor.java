package com.hms.config;

import com.hms.entity.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 登录拦截器
 */
public class LoginInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(LoginInterceptor.class);

    /**
     * 用户会话键名
     */
    public static final String USER_SESSION_KEY = "currentUser";

    /**
     * 管理员会话键名
     */
    public static final String ADMIN_SESSION_KEY = "currentAdmin";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // 移除上下文路径
        if (contextPath != null && !contextPath.isEmpty()) {
            requestURI = requestURI.substring(contextPath.length());
        }

        logger.debug("拦截请求: {}", requestURI);

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute(USER_SESSION_KEY);

        // 检查是否已登录
        if (currentUser == null) {
            logger.debug("用户未登录，重定向到登录页面");

            // 如果是AJAX请求，返回JSON响应
            if (isAjaxRequest(request)) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"code\":401,\"message\":\"请先登录\"}");
                return false;
            }

            // 保存原始请求URL，登录后可以重定向回来
            String originalUrl = request.getRequestURL().toString();
            String queryString = request.getQueryString();
            if (queryString != null) {
                originalUrl += "?" + queryString;
            }
            session.setAttribute("originalUrl", originalUrl);

            // 重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/user/login");
            return false;
        }

        // 检查用户状态
        if (!currentUser.isActive()) {
            logger.warn("用户账户已被禁用: {}", currentUser.getUsername());

            // 清除会话
            session.removeAttribute(USER_SESSION_KEY);
            session.removeAttribute(ADMIN_SESSION_KEY);

            if (isAjaxRequest(request)) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"code\":403,\"message\":\"账户已被禁用\"}");
                return false;
            }

            response.sendRedirect(request.getContextPath() + "/login?error=account_disabled");
            return false;
        }

        // 检查管理员权限
        if (isAdminPath(requestURI)) {
            if (!currentUser.isAdmin()) {
                logger.warn("非管理员用户尝试访问管理员页面: {} -> {}", currentUser.getUsername(), requestURI);

                if (isAjaxRequest(request)) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"code\":403,\"message\":\"权限不足\"}");
                    return false;
                }

                response.sendRedirect(request.getContextPath() + "/403");
                return false;
            }

            // 设置管理员会话
            session.setAttribute(ADMIN_SESSION_KEY, currentUser);
        }

        // 检查管理员是否访问普通用户页面
        if (currentUser.isAdmin() && isUserOnlyPath(requestURI)) {
            logger.warn("管理员用户尝试访问普通用户页面: {} -> {}", currentUser.getUsername(), requestURI);

            if (isAjaxRequest(request)) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"code\":403,\"message\":\"管理员不能访问用户页面\"}");
                return false;
            }

            // 重定向到管理员首页
            response.sendRedirect(request.getContextPath() + "/admin");
            return false;
        }

        // 更新最后访问时间
        session.setAttribute("lastAccessTime", System.currentTimeMillis());

        logger.debug("用户 {} 通过权限验证，访问: {}", currentUser.getUsername(), requestURI);
        return true;
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

    /**
     * 判断是否为管理员路径
     *
     * @param requestURI 请求URI
     * @return 是否为管理员路径
     */
    private boolean isAdminPath(String requestURI) {
        return requestURI.startsWith("/admin/") ||
                requestURI.startsWith("/management/") ||
                requestURI.equals("/admin") ||
                requestURI.equals("/management");
    }

    /**
     * 判断是否为普通用户专用路径（管理员不应该访问）
     *
     * @param requestURI 请求URI
     * @return 是否为普通用户专用路径
     */
    private boolean isUserOnlyPath(String requestURI) {
        return requestURI.startsWith("/order/my") || // 我的订单
                requestURI.startsWith("/order/detail/") || // 订单详情（普通用户）
                requestURI.startsWith("/user/profile") || // 用户个人资料
                requestURI.startsWith("/user/orders") || // 用户订单列表
                requestURI.equals("/order/my"); // 我的订单首页
    }

    /**
     * 获取当前登录用户
     * 
     * @param request HTTP请求
     * @return 当前用户，如果未登录返回null
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute(USER_SESSION_KEY);
    }

    /**
     * 设置当前登录用户
     * 
     * @param request HTTP请求
     * @param user    用户对象
     */
    public static void setCurrentUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession();
        if (user == null) {
            session.removeAttribute(USER_SESSION_KEY);
            session.removeAttribute(ADMIN_SESSION_KEY);
        } else {
            session.setAttribute(USER_SESSION_KEY, user);
            if (user.isAdmin()) {
                session.setAttribute(ADMIN_SESSION_KEY, user);
            }
        }
    }

    /**
     * 检查当前用户是否为管理员
     * 
     * @param request HTTP请求
     * @return 是否为管理员
     */
    public static boolean isCurrentUserAdmin(HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        return currentUser != null && currentUser.isAdmin();
    }

    /**
     * 用户登出
     * 
     * @param request HTTP请求
     */
    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(USER_SESSION_KEY);
            session.removeAttribute(ADMIN_SESSION_KEY);
            session.removeAttribute("originalUrl");
            session.removeAttribute("lastAccessTime");
            session.invalidate();
        }
    }
}
