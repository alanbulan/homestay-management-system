package com.hms.service;

import com.hms.dto.OrderCreateDTO;
import com.hms.entity.Orders;
import com.hms.vo.PageResult;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 订单Service接口
 */
public interface OrdersService {

    /**
     * 根据ID查询订单
     * 
     * @param id 订单ID
     * @return 订单信息
     */
    Orders getOrderById(Long id);

    /**
     * 根据订单号查询订单
     * 
     * @param orderNo 订单号
     * @return 订单信息
     */
    Orders getOrderByOrderNo(String orderNo);

    /**
     * 根据ID查询订单（包含用户和房源信息）
     * 
     * @param id 订单ID
     * @return 订单信息（包含关联信息）
     */
    Orders getOrderWithDetails(Long id);

    /**
     * 根据用户ID查询订单列表
     * 
     * @param userId        用户ID
     * @param orderStatus   订单状态（可选）
     * @param paymentStatus 支付状态（可选）
     * @return 订单列表
     */
    List<Orders> getOrdersByUserId(Long userId, Integer orderStatus, Integer paymentStatus);

    /**
     * 分页查询订单列表
     * 
     * @param pageNum       页码
     * @param pageSize      页面大小
     * @param userId        用户ID（可选）
     * @param roomId        房源ID（可选）
     * @param orderStatus   订单状态（可选）
     * @param paymentStatus 支付状态（可选）
     * @param startDate     开始日期（可选）
     * @param endDate       结束日期（可选）
     * @param keyword       搜索关键词（可选）
     * @return 分页结果
     */
    PageResult<Orders> getOrderList(Integer pageNum, Integer pageSize,
            Long userId, Long roomId,
            Integer orderStatus, Integer paymentStatus,
            LocalDate startDate, LocalDate endDate,
            String keyword);

    /**
     * 创建订单
     * 
     * @param userId         用户ID
     * @param orderCreateDTO 订单创建信息
     * @return 创建成功的订单信息
     */
    Orders createOrder(Long userId, OrderCreateDTO orderCreateDTO);

    /**
     * 更新订单信息
     * 
     * @param orders 订单信息
     * @return 更新后的订单信息
     */
    Orders updateOrder(Orders orders);

    /**
     * 确认订单
     * 
     * @param orderId 订单ID
     * @return 是否确认成功
     */
    boolean confirmOrder(Long orderId);

    /**
     * 取消订单
     * 
     * @param orderId      订单ID
     * @param cancelReason 取消原因
     * @return 是否取消成功
     */
    boolean cancelOrder(Long orderId, String cancelReason);

    /**
     * 用户取消订单
     * 
     * @param orderId      订单ID
     * @param userId       用户ID
     * @param cancelReason 取消原因
     * @return 是否取消成功
     */
    boolean cancelOrderByUser(Long orderId, Long userId, String cancelReason);

    /**
     * 办理入住
     * 
     * @param orderId 订单ID
     * @return 是否办理成功
     */
    boolean checkIn(Long orderId);

    /**
     * 完成订单
     * 
     * @param orderId 订单ID
     * @return 是否完成成功
     */
    boolean completeOrder(Long orderId);

    /**
     * 更新支付状态
     * 
     * @param orderId       订单ID
     * @param paymentStatus 支付状态
     * @return 是否更新成功
     */
    boolean updatePaymentStatus(Long orderId, Integer paymentStatus);

    /**
     * 支付订单
     * 
     * @param orderId 订单ID
     * @return 是否支付成功
     */
    boolean payOrder(Long orderId);

    /**
     * 退款订单
     * 
     * @param orderId 订单ID
     * @return 是否退款成功
     */
    boolean refundOrder(Long orderId);

    /**
     * 删除订单
     * 
     * @param id 订单ID
     * @return 是否删除成功
     */
    boolean deleteOrder(Long id);

    /**
     * 批量删除订单
     * 
     * @param ids 订单ID列表
     * @return 删除成功的数量
     */
    int deleteOrders(List<Long> ids);

    /**
     * 检查订单号是否存在
     * 
     * @param orderNo   订单号
     * @param excludeId 排除的订单ID（用于更新时检查）
     * @return 是否存在
     */
    boolean isOrderNoExists(String orderNo, Long excludeId);

    /**
     * 查询即将到期的订单
     * 
     * @param beforeHours 多少小时前
     * @return 订单列表
     */
    List<Orders> getExpiringSoonOrders(Integer beforeHours);

    /**
     * 查询需要自动确认的订单
     * 
     * @param beforeHours 多少小时前创建的订单
     * @return 订单列表
     */
    List<Orders> getPendingAutoConfirmOrders(Integer beforeHours);

    /**
     * 自动确认订单
     * 
     * @param beforeHours 多少小时前创建的订单
     * @return 自动确认的订单数量
     */
    int autoConfirmOrders(Integer beforeHours);

    /**
     * 统计用户订单数量
     * 
     * @param userId      用户ID
     * @param orderStatus 订单状态（可选）
     * @return 订单数量
     */
    Long countUserOrders(Long userId, Integer orderStatus);

    /**
     * 统计房源订单数量
     * 
     * @param roomId      房源ID
     * @param orderStatus 订单状态（可选）
     * @return 订单数量
     */
    Long countRoomOrders(Long roomId, Integer orderStatus);

    /**
     * 获取订单统计信息
     * 
     * @return 统计信息Map
     */
    Map<String, Object> getOrderStatistics();

    /**
     * 获取用户订单统计信息
     *
     * @param userId 用户ID
     * @return 统计信息Map
     */
    Map<String, Object> getUserOrderStatistics(Long userId);

    /**
     * 获取订单总数
     *
     * @return 订单总数
     */
    long getTotalOrderCount();

    /**
     * 获取待确认订单数
     *
     * @return 待确认订单数
     */
    long getPendingOrderCount();

    /**
     * 获取今日完成订单数
     *
     * @return 今日完成订单数
     */
    long getCompletedOrderCountToday();

    /**
     * 获取总收入
     *
     * @return 总收入
     */
    double getTotalRevenue();

    /**
     * 获取今日收入
     *
     * @return 今日收入
     */
    double getRevenueToday();

    /**
     * 获取本月收入
     *
     * @return 本月收入
     */
    double getRevenueThisMonth();
}
