package com.hms.controller;

import com.hms.config.LoginInterceptor;
import com.hms.dto.OrderCreateDTO;
import com.hms.entity.Orders;
import com.hms.entity.User;
import com.hms.service.OrdersService;
import com.hms.util.Constants;
import com.hms.vo.PageResult;
import com.hms.vo.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 订单Controller
 */
@Controller
@RequestMapping("/order")
public class OrdersController {

    private static final Logger logger = LoggerFactory.getLogger(OrdersController.class);

    @Autowired
    private OrdersService ordersService;

    /**
     * 我的订单页面
     */
    @GetMapping("/my")
    public String myOrdersPage(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        model.addAttribute("user", currentUser);
        return "order/my-orders";
    }

    /**
     * 获取我的订单列表
     */
    @GetMapping("/my/list")
    @ResponseBody
    public Result<List<Orders>> getMyOrders(@RequestParam(required = false) Integer orderStatus,
            @RequestParam(required = false) Integer paymentStatus,
            HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            List<Orders> orders = ordersService.getOrdersByUserId(currentUser.getId(), orderStatus, paymentStatus);
            return Result.success(orders);

        } catch (Exception e) {
            logger.error("获取我的订单列表失败: {}", e.getMessage(), e);
            return Result.error("获取订单列表失败");
        }
    }

    /**
     * 创建订单
     */
    @PostMapping("/create")
    @ResponseBody
    public Result<Orders> createOrder(@RequestBody OrderCreateDTO orderCreateDTO, HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("请先登录");
            }

            Orders order = ordersService.createOrder(currentUser.getId(), orderCreateDTO);

            logger.info("用户创建订单成功: userId={}, orderNo={}", currentUser.getId(), order.getOrderNo());
            return Result.success("订单创建成功", order);

        } catch (Exception e) {
            logger.error("创建订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 订单详情页面（根据ID）
     */
    @GetMapping("/detail/{id}")
    public String orderDetailPage(@PathVariable Long id, HttpServletRequest request, Model model) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return "redirect:/user/login";
            }

            Orders order = ordersService.getOrderWithDetails(id);
            if (order == null) {
                model.addAttribute("error", "订单不存在");
                return "error/404";
            }

            // 检查权限：只能查看自己的订单或管理员可以查看所有订单
            if (!order.getUserId().equals(currentUser.getId()) && !currentUser.isAdmin()) {
                model.addAttribute("error", "无权查看此订单");
                return "error/403";
            }

            model.addAttribute("order", order);
            return "order/detail";

        } catch (Exception e) {
            logger.error("获取订单详情失败: {}", e.getMessage(), e);
            model.addAttribute("error", "获取订单详情失败");
            return "error/500";
        }
    }

    /**
     * 订单详情页面（根据订单号）- 普通用户
     */
    @GetMapping("/detail/no/{orderNo}")
    public String orderDetailPageByOrderNo(@PathVariable String orderNo, HttpServletRequest request, Model model) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return "redirect:/user/login";
            }

            // 管理员不应该访问普通用户页面，重定向到管理员页面
            if (currentUser.isAdmin()) {
                return "redirect:/admin/orders/detail/" + orderNo;
            }

            Orders order = ordersService.getOrderByOrderNo(orderNo);
            if (order == null) {
                model.addAttribute("error", "订单不存在");
                return "error/404";
            }

            // 检查权限：只能查看自己的订单
            if (!order.getUserId().equals(currentUser.getId())) {
                model.addAttribute("error", "无权查看此订单");
                return "error/403";
            }

            model.addAttribute("order", order);
            return "order/detail";

        } catch (Exception e) {
            logger.error("获取订单详情失败: {}", e.getMessage(), e);
            model.addAttribute("error", "获取订单详情失败");
            return "error/500";
        }
    }

    /**
     * 管理员订单详情页面（根据订单号）
     */
    @GetMapping("/admin/detail/{orderNo}")
    public String adminOrderDetailPage(@PathVariable String orderNo, HttpServletRequest request, Model model) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return "redirect:/user/login";
            }

            // 只有管理员可以访问
            if (!currentUser.isAdmin()) {
                model.addAttribute("error", "无权访问管理员页面");
                return "error/403";
            }

            Orders order = ordersService.getOrderByOrderNo(orderNo);
            if (order == null) {
                model.addAttribute("error", "订单不存在");
                return "error/404";
            }

            // 获取完整的订单详情
            Orders orderWithDetails = ordersService.getOrderWithDetails(order.getId());
            if (orderWithDetails == null) {
                model.addAttribute("error", "订单详情不存在");
                return "error/404";
            }

            model.addAttribute("order", orderWithDetails);
            return "admin/order-detail";

        } catch (Exception e) {
            logger.error("获取管理员订单详情失败: {}", e.getMessage(), e);
            model.addAttribute("error", "获取订单详情失败");
            return "error/500";
        }
    }

    /**
     * 获取订单详情（API - 根据ID）
     */
    @GetMapping("/api/detail/{id}")
    @ResponseBody
    public Result<Orders> getOrderDetail(@PathVariable Long id, HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            Orders order = ordersService.getOrderWithDetails(id);
            if (order == null) {
                return Result.notFound("订单不存在");
            }

            // 检查权限
            if (!order.getUserId().equals(currentUser.getId()) && !currentUser.isAdmin()) {
                return Result.forbidden("无权查看此订单");
            }

            return Result.success(order);

        } catch (Exception e) {
            logger.error("获取订单详情失败: {}", e.getMessage(), e);
            return Result.error("获取订单详情失败");
        }
    }

    /**
     * 获取订单详情（API - 根据订单号）
     */
    @GetMapping("/api/detail/no/{orderNo}")
    @ResponseBody
    public Result<Orders> getOrderDetailByOrderNo(@PathVariable String orderNo, HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            Orders order = ordersService.getOrderByOrderNo(orderNo);
            if (order == null) {
                return Result.notFound("订单不存在");
            }

            // 获取完整的订单详情
            Orders orderWithDetails = ordersService.getOrderWithDetails(order.getId());
            if (orderWithDetails == null) {
                return Result.notFound("订单详情不存在");
            }

            // 检查权限
            if (!orderWithDetails.getUserId().equals(currentUser.getId()) && !currentUser.isAdmin()) {
                return Result.forbidden("无权查看此订单");
            }

            return Result.success(orderWithDetails);

        } catch (Exception e) {
            logger.error("根据订单号获取订单详情失败: {}", e.getMessage(), e);
            return Result.error("获取订单详情失败");
        }
    }

    /**
     * 取消订单
     */
    @PostMapping("/cancel")
    @ResponseBody
    public Result<Void> cancelOrder(@RequestParam Long orderId,
            @RequestParam(required = false) String cancelReason,
            HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            boolean success = ordersService.cancelOrderByUser(orderId, currentUser.getId(), cancelReason);
            if (success) {
                logger.info("用户取消订单成功: userId={}, orderId={}", currentUser.getId(), orderId);
                return Result.success();
            } else {
                return Result.error("订单取消失败");
            }

        } catch (Exception e) {
            logger.error("取消订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 支付订单
     */
    @PostMapping("/pay")
    @ResponseBody
    public Result<Void> payOrder(@RequestParam Long orderId, HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            // 检查订单权限
            Orders order = ordersService.getOrderById(orderId);
            if (order == null) {
                return Result.notFound("订单不存在");
            }
            if (!order.getUserId().equals(currentUser.getId())) {
                return Result.forbidden("无权操作此订单");
            }

            boolean success = ordersService.payOrder(orderId);
            if (success) {
                logger.info("用户支付订单成功: userId={}, orderId={}", currentUser.getId(), orderId);
                return Result.success();
            } else {
                return Result.error("支付失败");
            }

        } catch (Exception e) {
            logger.error("支付订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取用户订单统计
     */
    @GetMapping("/my/statistics")
    @ResponseBody
    public Result<Map<String, Object>> getMyOrderStatistics(HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            Map<String, Object> statistics = ordersService.getUserOrderStatistics(currentUser.getId());
            return Result.success(statistics);

        } catch (Exception e) {
            logger.error("获取用户订单统计失败: {}", e.getMessage(), e);
            return Result.error("获取统计信息失败");
        }
    }

    // ==================== 管理员功能 ====================

    /**
     * 订单管理页面（管理员）
     */
    @GetMapping("/manage")
    public String managePage(HttpServletRequest request) {
        if (!LoginInterceptor.isCurrentUserAdmin(request)) {
            return "redirect:/403";
        }
        return "admin/order-manage";
    }

    /**
     * 分页查询订单列表（管理员）
     */
    @GetMapping("/manage/list")
    @ResponseBody
    public Result<PageResult<Orders>> getOrderListForAdmin(@RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long roomId,
            @RequestParam(required = false) Integer orderStatus,
            @RequestParam(required = false) Integer paymentStatus,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String keyword,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            PageResult<Orders> result = ordersService.getOrderList(pageNum, pageSize, userId, roomId,
                    orderStatus, paymentStatus, startDate, endDate, keyword);
            return Result.success(result);

        } catch (Exception e) {
            logger.error("查询订单列表失败: {}", e.getMessage(), e);
            return Result.error("查询失败");
        }
    }

    /**
     * 确认订单（管理员）
     */
    @PostMapping("/confirm")
    @ResponseBody
    public Result<Void> confirmOrder(@RequestParam Long orderId, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = ordersService.confirmOrder(orderId);
            if (success) {
                logger.info("管理员确认订单成功: orderId={}", orderId);
                return Result.success();
            } else {
                return Result.error("订单确认失败");
            }

        } catch (Exception e) {
            logger.error("确认订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 取消订单（管理员）
     */
    @PostMapping("/admin/cancel")
    @ResponseBody
    public Result<Void> adminCancelOrder(@RequestParam Long orderId,
            @RequestParam(required = false) String cancelReason,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = ordersService.cancelOrder(orderId, cancelReason);
            if (success) {
                logger.info("管理员取消订单成功: orderId={}", orderId);
                return Result.success();
            } else {
                return Result.error("订单取消失败");
            }

        } catch (Exception e) {
            logger.error("管理员取消订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 办理入住（管理员）
     */
    @PostMapping("/checkIn")
    @ResponseBody
    public Result<Void> checkIn(@RequestParam Long orderId, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = ordersService.checkIn(orderId);
            if (success) {
                logger.info("管理员办理入住成功: orderId={}", orderId);
                return Result.success();
            } else {
                return Result.error("入住办理失败");
            }

        } catch (Exception e) {
            logger.error("办理入住失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 完成订单（管理员）
     */
    @PostMapping("/complete")
    @ResponseBody
    public Result<Void> completeOrder(@RequestParam Long orderId, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = ordersService.completeOrder(orderId);
            if (success) {
                logger.info("管理员完成订单成功: orderId={}", orderId);
                return Result.success();
            } else {
                return Result.error("订单完成失败");
            }

        } catch (Exception e) {
            logger.error("完成订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 退款订单（管理员）
     */
    @PostMapping("/refund")
    @ResponseBody
    public Result<Void> refundOrder(@RequestParam Long orderId, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = ordersService.refundOrder(orderId);
            if (success) {
                logger.info("管理员退款订单成功: orderId={}", orderId);
                return Result.success();
            } else {
                return Result.error("退款失败");
            }

        } catch (Exception e) {
            logger.error("退款订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取订单统计信息（管理员）
     */
    @GetMapping("/statistics")
    @ResponseBody
    public Result<Map<String, Object>> getOrderStatistics(HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            Map<String, Object> statistics = ordersService.getOrderStatistics();
            return Result.success(statistics);

        } catch (Exception e) {
            logger.error("获取订单统计信息失败: {}", e.getMessage(), e);
            return Result.error("获取统计信息失败");
        }
    }

    /**
     * 自动确认订单（管理员）
     */
    @PostMapping("/autoConfirm")
    @ResponseBody
    public Result<Integer> autoConfirmOrders(@RequestParam(defaultValue = "24") Integer beforeHours,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            int confirmedCount = ordersService.autoConfirmOrders(beforeHours);

            logger.info("管理员执行自动确认订单: 确认数量={}", confirmedCount);
            return Result.success("自动确认完成", confirmedCount);

        } catch (Exception e) {
            logger.error("自动确认订单失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }
}
