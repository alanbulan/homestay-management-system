package com.hms.controller;

import com.hms.config.LoginInterceptor;
import com.hms.entity.User;
import com.hms.service.OrdersService;
import com.hms.service.RoomService;
import com.hms.service.UserService;
import com.hms.vo.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * 管理员后台控制器
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private OrdersService ordersService;

    /**
     * 管理员后台首页
     */
    @GetMapping({ "", "/", "/index" })
    public String index(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser == null || !currentUser.isAdmin()) {
            return "redirect:/user/login";
        }

        model.addAttribute("user", currentUser);
        return "admin/index";
    }

    /**
     * 获取仪表板统计数据
     */
    @GetMapping("/dashboard/stats")
    @ResponseBody
    public Result<Map<String, Object>> getDashboardStats(HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            Map<String, Object> stats = new HashMap<>();

            // 用户统计 - 使用现有的方法，添加异常处理
            long totalUsers = 0, activeUsers = 0, newUsersToday = 0;
            try {
                totalUsers = userService.getTotalUserCount();
                activeUsers = userService.getActiveUserCount();
                newUsersToday = userService.getNewUserCountToday();
            } catch (Exception e) {
                logger.warn("获取用户统计数据失败: {}", e.getMessage());
            }

            // 房源统计 - 使用现有的统计方法，添加异常处理
            long totalRooms = 0, onlineRooms = 0, newRoomsToday = 0;
            try {
                Map<String, Object> roomStats = roomService.getRoomStatistics();
                totalRooms = (Long) roomStats.getOrDefault("totalRooms", 0L);
                onlineRooms = (Long) roomStats.getOrDefault("onlineRooms", 0L);
                newRoomsToday = roomService.getNewRoomCountToday();
            } catch (Exception e) {
                logger.warn("获取房源统计数据失败: {}", e.getMessage());
            }

            // 订单统计 - 使用现有的统计方法，添加异常处理
            long totalOrders = 0, pendingOrders = 0, completedOrdersToday = 0;
            try {
                Map<String, Object> orderStats = ordersService.getOrderStatistics();
                totalOrders = (Long) orderStats.getOrDefault("totalOrders", 0L);
                pendingOrders = (Long) orderStats.getOrDefault("pendingOrders", 0L);
                completedOrdersToday = ordersService.getCompletedOrderCountToday();
            } catch (Exception e) {
                logger.warn("获取订单统计数据失败: {}", e.getMessage());
            }

            // 收入统计 - 使用现有的方法，添加异常处理
            double totalRevenue = 0.0, revenueToday = 0.0, revenueThisMonth = 0.0;
            try {
                totalRevenue = ordersService.getTotalRevenue();
                revenueToday = ordersService.getRevenueToday();
                revenueThisMonth = ordersService.getRevenueThisMonth();
            } catch (Exception e) {
                logger.warn("获取收入统计数据失败: {}", e.getMessage());
            }

            Map<String, Object> userStats = new HashMap<>();
            userStats.put("total", totalUsers);
            userStats.put("active", activeUsers);
            userStats.put("newToday", newUsersToday);
            stats.put("users", userStats);

            Map<String, Object> roomStatsResult = new HashMap<>();
            roomStatsResult.put("total", totalRooms);
            roomStatsResult.put("online", onlineRooms);
            roomStatsResult.put("newToday", newRoomsToday);
            stats.put("rooms", roomStatsResult);

            Map<String, Object> orderStatsResult = new HashMap<>();
            orderStatsResult.put("total", totalOrders);
            orderStatsResult.put("pending", pendingOrders);
            orderStatsResult.put("completedToday", completedOrdersToday);
            stats.put("orders", orderStatsResult);

            Map<String, Object> revenueStats = new HashMap<>();
            revenueStats.put("total", totalRevenue);
            revenueStats.put("today", revenueToday);
            revenueStats.put("thisMonth", revenueThisMonth);
            stats.put("revenue", revenueStats);

            return Result.success(stats);

        } catch (Exception e) {
            logger.error("获取仪表板统计数据失败: {}", e.getMessage(), e);
            return Result.error("获取统计数据失败");
        }
    }

    /**
     * 用户管理页面
     */
    @GetMapping("/users")
    public String usersPage(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser == null || !currentUser.isAdmin()) {
            return "redirect:/user/login";
        }

        model.addAttribute("user", currentUser);
        return "admin/users";
    }

    /**
     * 房源管理页面
     */
    @GetMapping("/rooms")
    public String roomsPage(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser == null || !currentUser.isAdmin()) {
            return "redirect:/user/login";
        }

        model.addAttribute("user", currentUser);
        return "admin/rooms";
    }

    /**
     * 订单管理页面
     */
    @GetMapping("/orders")
    public String ordersPage(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser == null || !currentUser.isAdmin()) {
            return "redirect:/user/login";
        }

        model.addAttribute("user", currentUser);
        return "admin/orders";
    }

    /**
     * 系统设置页面
     */
    @GetMapping("/settings")
    public String settingsPage(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser == null || !currentUser.isAdmin()) {
            return "redirect:/user/login";
        }

        model.addAttribute("user", currentUser);
        return "admin/settings";
    }

}
