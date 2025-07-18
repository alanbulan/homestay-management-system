package com.hms.controller;

import com.hms.config.LoginInterceptor;
import com.hms.entity.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * 用户仪表板控制器
 */
@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);

    /**
     * 用户仪表板首页 - 重定向到房源列表
     */
    @GetMapping({ "", "/", "/index" })
    public String index(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // 如果是管理员，重定向到管理员后台
        if (currentUser.isAdmin()) {
            return "redirect:/admin";
        }

        // 普通用户重定向到房源列表
        return "redirect:/room/list";
    }
}
