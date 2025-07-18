package com.hms.mapper;

import com.hms.entity.Orders;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 订单Mapper接口
 */
public interface OrdersMapper {

        /**
         * 根据ID查询订单
         * 
         * @param id 订单ID
         * @return 订单信息
         */
        Orders selectById(@Param("id") Long id);

        /**
         * 根据订单号查询订单
         * 
         * @param orderNo 订单号
         * @return 订单信息
         */
        Orders selectByOrderNo(@Param("orderNo") String orderNo);

        /**
         * 根据ID查询订单（包含用户和房源信息）
         * 
         * @param id 订单ID
         * @return 订单信息（包含关联信息）
         */
        Orders selectByIdWithDetails(@Param("id") Long id);

        /**
         * 根据用户ID查询订单列表
         * 
         * @param userId        用户ID
         * @param orderStatus   订单状态（可选）
         * @param paymentStatus 支付状态（可选）
         * @return 订单列表
         */
        List<Orders> selectByUserId(@Param("userId") Long userId,
                        @Param("orderStatus") Integer orderStatus,
                        @Param("paymentStatus") Integer paymentStatus);

        /**
         * 查询所有订单（分页）
         * 
         * @param userId        用户ID（可选）
         * @param roomId        房源ID（可选）
         * @param orderStatus   订单状态（可选）
         * @param paymentStatus 支付状态（可选）
         * @param startDate     开始日期（可选）
         * @param endDate       结束日期（可选）
         * @param keyword       搜索关键词（可选）
         * @return 订单列表
         */
        List<Orders> selectAll(@Param("userId") Long userId,
                        @Param("roomId") Long roomId,
                        @Param("orderStatus") Integer orderStatus,
                        @Param("paymentStatus") Integer paymentStatus,
                        @Param("startDate") LocalDate startDate,
                        @Param("endDate") LocalDate endDate,
                        @Param("keyword") String keyword);

        /**
         * 分页查询订单列表
         * 
         * @param userId        用户ID（可选）
         * @param roomId        房间ID（可选）
         * @param orderStatus   订单状态（可选）
         * @param paymentStatus 支付状态（可选）
         * @param startDate     开始日期（可选）
         * @param endDate       结束日期（可选）
         * @param keyword       搜索关键词（可选）
         * @param offset        偏移量
         * @param limit         限制数量
         * @return 订单列表
         */
        List<Orders> selectAllWithPaging(@Param("userId") Long userId,
                        @Param("roomId") Long roomId,
                        @Param("orderStatus") Integer orderStatus,
                        @Param("paymentStatus") Integer paymentStatus,
                        @Param("startDate") LocalDate startDate,
                        @Param("endDate") LocalDate endDate,
                        @Param("keyword") String keyword,
                        @Param("offset") Integer offset,
                        @Param("limit") Integer limit);

        /**
         * 统计订单数量
         * 
         * @param userId        用户ID（可选）
         * @param roomId        房源ID（可选）
         * @param orderStatus   订单状态（可选）
         * @param paymentStatus 支付状态（可选）
         * @param startDate     开始日期（可选）
         * @param endDate       结束日期（可选）
         * @param keyword       搜索关键词（可选）
         * @return 订单数量
         */
        Long countOrders(@Param("userId") Long userId,
                        @Param("roomId") Long roomId,
                        @Param("orderStatus") Integer orderStatus,
                        @Param("paymentStatus") Integer paymentStatus,
                        @Param("startDate") LocalDate startDate,
                        @Param("endDate") LocalDate endDate,
                        @Param("keyword") String keyword);

        /**
         * 插入订单
         * 
         * @param orders 订单信息
         * @return 影响行数
         */
        int insert(Orders orders);

        /**
         * 更新订单信息
         * 
         * @param orders 订单信息
         * @return 影响行数
         */
        int update(Orders orders);

        /**
         * 更新订单状态
         * 
         * @param id          订单ID
         * @param orderStatus 新订单状态
         * @return 影响行数
         */
        int updateOrderStatus(@Param("id") Long id, @Param("orderStatus") Integer orderStatus);

        /**
         * 更新支付状态
         * 
         * @param id            订单ID
         * @param paymentStatus 新支付状态
         * @param paymentTime   支付时间
         * @return 影响行数
         */
        int updatePaymentStatus(@Param("id") Long id,
                        @Param("paymentStatus") Integer paymentStatus,
                        @Param("paymentTime") LocalDateTime paymentTime);

        /**
         * 取消订单
         * 
         * @param id           订单ID
         * @param cancelReason 取消原因
         * @param cancelTime   取消时间
         * @return 影响行数
         */
        int cancelOrder(@Param("id") Long id,
                        @Param("cancelReason") String cancelReason,
                        @Param("cancelTime") LocalDateTime cancelTime);

        /**
         * 逻辑删除订单
         * 
         * @param id 订单ID
         * @return 影响行数
         */
        int deleteById(@Param("id") Long id);

        /**
         * 批量逻辑删除订单
         * 
         * @param ids 订单ID列表
         * @return 影响行数
         */
        int deleteBatch(@Param("ids") List<Long> ids);

        /**
         * 查询即将到期的订单（用于自动处理）
         * 
         * @param beforeHours 多少小时前
         * @return 订单列表
         */
        List<Orders> selectExpiringSoon(@Param("beforeHours") Integer beforeHours);

        /**
         * 查询需要自动确认的订单
         * 
         * @param beforeHours 多少小时前创建的订单
         * @return 订单列表
         */
        List<Orders> selectPendingAutoConfirm(@Param("beforeHours") Integer beforeHours);

        /**
         * 统计用户订单数量
         * 
         * @param userId      用户ID
         * @param orderStatus 订单状态（可选）
         * @return 订单数量
         */
        Long countUserOrders(@Param("userId") Long userId, @Param("orderStatus") Integer orderStatus);

        /**
         * 统计房源订单数量
         * 
         * @param roomId      房源ID
         * @param orderStatus 订单状态（可选）
         * @return 订单数量
         */
        Long countRoomOrders(@Param("roomId") Long roomId, @Param("orderStatus") Integer orderStatus);

        /**
         * 检查订单号是否存在
         *
         * @param orderNo   订单号
         * @param excludeId 排除的订单ID（用于更新时检查）
         * @return 是否存在
         */
        boolean existsByOrderNo(@Param("orderNo") String orderNo, @Param("excludeId") Long excludeId);

        /**
         * 统计今日完成订单数
         *
         * @return 今日完成订单数
         */
        long countCompletedOrdersToday();

        /**
         * 获取总收入
         *
         * @return 总收入
         */
        Double getTotalRevenue();

        /**
         * 获取今日收入
         *
         * @return 今日收入
         */
        Double getRevenueToday();

        /**
         * 获取本月收入
         *
         * @return 本月收入
         */
        Double getRevenueThisMonth();

        /**
         * 获取用户总消费金额
         *
         * @param userId 用户ID
         * @return 用户总消费金额
         */
        Double getUserTotalSpent(@Param("userId") Long userId);
}
