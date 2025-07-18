package com.hms.controller;

import com.hms.service.OrdersService;
import com.hms.service.RoomService;
import com.hms.service.UserService;
import com.hms.vo.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * 首页控制器
 */
@Controller
public class HomeController {

    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private RoomService roomService;

    @Autowired
    private OrdersService ordersService;

    /**
     * 首页
     */
    @GetMapping("/")
    public String index() {
        logger.info("访问首页");
        return "forward:/index.jsp";
    }

    /**
     * 获取首页统计数据
     */
    @GetMapping("/api/stats")
    @ResponseBody
    public Result<Map<String, Object>> getStats() {
        try {
            Map<String, Object> stats = new HashMap<>();

            // 获取房源总数
            Long roomCount = roomService.getRoomList(1, 1000, null, null, null, null, null, null, null, null)
                    .getTotal();
            stats.put("roomCount", roomCount);

            // 获取用户总数
            Long userCount = userService.getUserList(1, 1000, null, null, null).getTotal();
            stats.put("userCount", userCount);

            // 获取订单总数
            Long orderCount = ordersService.getOrderList(1, 1000, null, null, null, null, null, null, null).getTotal();
            stats.put("orderCount", orderCount);

            // 城市数量（暂时固定，可以后续从数据库统计）
            stats.put("cityCount", 8);

            // 图片数量（暂时固定，可以后续从数据库统计）
            stats.put("imageCount", 29);

            return Result.success(stats);
        } catch (Exception e) {
            logger.error("获取统计数据失败: {}", e.getMessage(), e);
            return Result.error("获取统计数据失败");
        }
    }

    /**
     * 系统状态检查
     */
    @GetMapping("/status")
    @ResponseBody
    public Result<Map<String, Object>> status(HttpServletRequest request) {
        logger.info("检查系统状态");

        Map<String, Object> statusInfo = new HashMap<>();
        statusInfo.put("systemName", "民宿管理系统");
        statusInfo.put("version", "1.0.0");
        statusInfo.put("framework", "SSM (Spring + Spring MVC + MyBatis)");
        statusInfo.put("javaVersion", System.getProperty("java.version"));
        statusInfo.put("serverTime", System.currentTimeMillis());
        statusInfo.put("contextPath", request.getContextPath());
        statusInfo.put("serverInfo", request.getServletContext().getServerInfo());

        // 检查数据库连接状态（这里先返回模拟状态）
        statusInfo.put("databaseStatus", "connected");
        statusInfo.put("status", "running");

        return Result.success("系统运行正常", statusInfo);
    }

    /**
     * 健康检查
     */
    @GetMapping("/health")
    @ResponseBody
    public Result<String> health() {
        logger.debug("健康检查");
        return Result.success("系统健康");
    }
}
