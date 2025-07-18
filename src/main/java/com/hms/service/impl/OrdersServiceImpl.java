package com.hms.service.impl;

import com.hms.dto.OrderCreateDTO;
import com.hms.entity.Orders;
import com.hms.entity.Room;
import com.hms.entity.User;
import com.hms.mapper.OrdersMapper;
import com.hms.mapper.RoomMapper;
import com.hms.mapper.UserMapper;
import com.hms.service.OrdersService;
import com.hms.util.Constants;
import com.hms.util.DateTimeUtil;
import com.hms.util.OrderNoGenerator;
import com.hms.vo.PageResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 订单Service实现类
 */
@Service
@Transactional
public class OrdersServiceImpl implements OrdersService {

    private static final Logger logger = LoggerFactory.getLogger(OrdersServiceImpl.class);

    @Autowired
    private OrdersMapper ordersMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoomMapper roomMapper;

    @Override
    @Transactional(readOnly = true)
    public Orders getOrderById(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        return ordersMapper.selectById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Orders getOrderByOrderNo(String orderNo) {
        if (orderNo == null || orderNo.trim().isEmpty()) {
            throw new IllegalArgumentException("订单号不能为空");
        }
        return ordersMapper.selectByOrderNo(orderNo);
    }

    @Override
    @Transactional(readOnly = true)
    public Orders getOrderWithDetails(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        return ordersMapper.selectByIdWithDetails(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Orders> getOrdersByUserId(Long userId, Integer orderStatus, Integer paymentStatus) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return ordersMapper.selectByUserId(userId, orderStatus, paymentStatus);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<Orders> getOrderList(Integer pageNum, Integer pageSize,
            Long userId, Long roomId,
            Integer orderStatus, Integer paymentStatus,
            LocalDate startDate, LocalDate endDate,
            String keyword) {
        // 参数校验和默认值设置
        if (pageNum == null || pageNum < 1) {
            pageNum = Constants.Page.DEFAULT_PAGE_NUM;
        }
        if (pageSize == null || pageSize < 1) {
            pageSize = Constants.Page.DEFAULT_PAGE_SIZE;
        }
        if (pageSize > Constants.Page.MAX_PAGE_SIZE) {
            pageSize = Constants.Page.MAX_PAGE_SIZE;
        }

        logger.debug("查询订单列表: pageNum={}, pageSize={}, userId={}, roomId={}, orderStatus={}, keyword={}",
                pageNum, pageSize, userId, roomId, orderStatus, keyword);

        // 查询总数
        Long total = ordersMapper.countOrders(userId, roomId, orderStatus, paymentStatus, startDate, endDate, keyword);

        // 计算分页参数
        int offset = (pageNum - 1) * pageSize;

        // 查询数据（分页）
        List<Orders> orders = ordersMapper.selectAllWithPaging(userId, roomId, orderStatus, paymentStatus,
                startDate, endDate, keyword, offset, pageSize);

        // 封装分页结果
        return PageResult.of(pageNum, pageSize, total, orders);
    }

    @Override
    public Orders createOrder(Long userId, OrderCreateDTO orderCreateDTO) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (orderCreateDTO == null || !orderCreateDTO.isValid()) {
            String error = orderCreateDTO != null ? orderCreateDTO.getValidationError() : "订单信息不能为空";
            throw new IllegalArgumentException(error);
        }

        logger.info("创建订单: userId={}, roomId={}, checkIn={}, checkOut={}",
                userId, orderCreateDTO.getRoomId(), orderCreateDTO.getCheckInDate(), orderCreateDTO.getCheckOutDate());

        // 检查用户是否存在
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        // 检查房源是否存在
        Room room = roomMapper.selectById(orderCreateDTO.getRoomId());
        if (room == null) {
            throw new RuntimeException("房源不存在");
        }
        if (!room.isAvailable()) {
            throw new RuntimeException("房源不可用");
        }

        // 检查房源在指定日期是否可用
        boolean isAvailable = roomMapper.isRoomAvailable(
                orderCreateDTO.getRoomId(),
                orderCreateDTO.getCheckInDate(),
                orderCreateDTO.getCheckOutDate(),
                null);
        if (!isAvailable) {
            throw new RuntimeException("房源在指定日期不可用");
        }

        // 检查入住人数是否超过限制
        if (orderCreateDTO.getGuests() > room.getMaxGuests()) {
            throw new RuntimeException("入住人数超过房源限制");
        }

        // 计算入住天数和总价
        Integer nights = orderCreateDTO.calculateNights();
        if (nights <= 0) {
            throw new RuntimeException("入住天数必须大于0");
        }

        BigDecimal totalPrice = room.getPricePerNight().multiply(new BigDecimal(nights));

        // 生成订单号
        String orderNo;
        do {
            orderNo = OrderNoGenerator.generate();
        } while (isOrderNoExists(orderNo, null));

        // 创建订单对象
        Orders order = new Orders();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setRoomId(orderCreateDTO.getRoomId());
        order.setCheckInDate(orderCreateDTO.getCheckInDate());
        order.setCheckOutDate(orderCreateDTO.getCheckOutDate());
        order.setNights(nights);
        order.setGuests(orderCreateDTO.getGuests());
        order.setTotalPrice(totalPrice);
        order.setContactName(orderCreateDTO.getContactName());
        order.setContactPhone(orderCreateDTO.getContactPhone());
        order.setContactEmail(orderCreateDTO.getContactEmail());
        order.setSpecialRequests(orderCreateDTO.getSpecialRequests());
        order.setOrderStatus(Constants.OrderStatus.PENDING);
        order.setPaymentStatus(Constants.PaymentStatus.UNPAID);
        order.setDeleted(Constants.DeleteFlag.NOT_DELETED);

        // 保存订单
        int result = ordersMapper.insert(order);
        if (result <= 0) {
            throw new RuntimeException("创建订单失败");
        }

        logger.info("订单创建成功: {} (ID: {})", order.getOrderNo(), order.getId());
        return order;
    }

    @Override
    public Orders updateOrder(Orders orders) {
        if (orders == null || orders.getId() == null) {
            throw new IllegalArgumentException("订单信息不完整");
        }

        logger.info("更新订单信息: ID={}", orders.getId());

        // 检查订单是否存在
        Orders existingOrder = ordersMapper.selectById(orders.getId());
        if (existingOrder == null) {
            throw new RuntimeException("订单不存在");
        }

        // 更新订单信息
        int result = ordersMapper.update(orders);
        if (result <= 0) {
            throw new RuntimeException("更新订单信息失败");
        }

        logger.info("订单信息更新成功: ID={}", orders.getId());
        return ordersMapper.selectById(orders.getId());
    }

    @Override
    public boolean confirmOrder(Long orderId) {
        if (orderId == null || orderId <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }

        logger.info("确认订单: ID={}", orderId);

        // 检查订单状态
        Orders order = ordersMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (order.getOrderStatus() != Constants.OrderStatus.PENDING) {
            throw new RuntimeException("订单状态不允许确认");
        }

        int result = ordersMapper.updateOrderStatus(orderId, Constants.OrderStatus.CONFIRMED);
        boolean success = result > 0;

        if (success) {
            logger.info("订单确认成功: ID={}", orderId);
        } else {
            logger.warn("订单确认失败: ID={}", orderId);
        }

        return success;
    }

    @Override
    public boolean cancelOrder(Long orderId, String cancelReason) {
        if (orderId == null || orderId <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }

        logger.info("取消订单: ID={}, reason={}", orderId, cancelReason);

        // 检查订单状态
        Orders order = ordersMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (!order.canCancel()) {
            throw new RuntimeException("订单状态不允许取消");
        }

        int result = ordersMapper.cancelOrder(orderId, cancelReason, LocalDateTime.now());
        boolean success = result > 0;

        if (success) {
            logger.info("订单取消成功: ID={}", orderId);
        } else {
            logger.warn("订单取消失败: ID={}", orderId);
        }

        return success;
    }

    @Override
    public boolean cancelOrderByUser(Long orderId, Long userId, String cancelReason) {
        if (orderId == null || orderId <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }

        logger.info("用户取消订单: orderId={}, userId={}, reason={}", orderId, userId, cancelReason);

        // 检查订单是否属于该用户
        Orders order = ordersMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (!order.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作此订单");
        }
        if (!order.canCancel()) {
            throw new RuntimeException("订单状态不允许取消");
        }

        return cancelOrder(orderId, cancelReason);
    }

    @Override
    public boolean checkIn(Long orderId) {
        if (orderId == null || orderId <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }

        logger.info("办理入住: ID={}", orderId);

        // 检查订单状态
        Orders order = ordersMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (order.getOrderStatus() != Constants.OrderStatus.CONFIRMED) {
            throw new RuntimeException("订单状态不允许入住");
        }

        int result = ordersMapper.updateOrderStatus(orderId, Constants.OrderStatus.CHECKED_IN);
        boolean success = result > 0;

        if (success) {
            logger.info("入住办理成功: ID={}", orderId);
        } else {
            logger.warn("入住办理失败: ID={}", orderId);
        }

        return success;
    }

    @Override
    public boolean completeOrder(Long orderId) {
        if (orderId == null || orderId <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }

        logger.info("完成订单: ID={}", orderId);

        // 检查订单状态
        Orders order = ordersMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (order.getOrderStatus() != Constants.OrderStatus.CHECKED_IN) {
            throw new RuntimeException("订单状态不允许完成");
        }

        int result = ordersMapper.updateOrderStatus(orderId, Constants.OrderStatus.COMPLETED);
        boolean success = result > 0;

        if (success) {
            logger.info("订单完成成功: ID={}", orderId);
        } else {
            logger.warn("订单完成失败: ID={}", orderId);
        }

        return success;
    }

    @Override
    public boolean updatePaymentStatus(Long orderId, Integer paymentStatus) {
        if (orderId == null || orderId <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }
        if (paymentStatus == null) {
            throw new IllegalArgumentException("支付状态不能为空");
        }

        logger.info("更新支付状态: orderId={}, paymentStatus={}", orderId, paymentStatus);

        LocalDateTime paymentTime = paymentStatus == Constants.PaymentStatus.PAID ? LocalDateTime.now() : null;
        int result = ordersMapper.updatePaymentStatus(orderId, paymentStatus, paymentTime);
        boolean success = result > 0;

        if (success) {
            logger.info("支付状态更新成功: orderId={}", orderId);
        } else {
            logger.warn("支付状态更新失败: orderId={}", orderId);
        }

        return success;
    }

    @Override
    public boolean payOrder(Long orderId) {
        return updatePaymentStatus(orderId, Constants.PaymentStatus.PAID);
    }

    @Override
    public boolean refundOrder(Long orderId) {
        return updatePaymentStatus(orderId, Constants.PaymentStatus.REFUNDED);
    }

    @Override
    public boolean deleteOrder(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("订单ID不能为空");
        }

        logger.info("删除订单: ID={}", id);

        int result = ordersMapper.deleteById(id);
        boolean success = result > 0;

        if (success) {
            logger.info("订单删除成功: ID={}", id);
        } else {
            logger.warn("订单删除失败: ID={}", id);
        }

        return success;
    }

    @Override
    public int deleteOrders(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            throw new IllegalArgumentException("订单ID列表不能为空");
        }

        logger.info("批量删除订单: count={}", ids.size());

        int result = ordersMapper.deleteBatch(ids);

        logger.info("批量删除订单完成: 删除数量={}", result);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isOrderNoExists(String orderNo, Long excludeId) {
        if (orderNo == null || orderNo.trim().isEmpty()) {
            return false;
        }
        return ordersMapper.existsByOrderNo(orderNo, excludeId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Orders> getExpiringSoonOrders(Integer beforeHours) {
        if (beforeHours == null || beforeHours < 0) {
            beforeHours = 24; // 默认24小时
        }
        return ordersMapper.selectExpiringSoon(beforeHours);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Orders> getPendingAutoConfirmOrders(Integer beforeHours) {
        if (beforeHours == null || beforeHours < 0) {
            beforeHours = 24; // 默认24小时
        }
        return ordersMapper.selectPendingAutoConfirm(beforeHours);
    }

    @Override
    public int autoConfirmOrders(Integer beforeHours) {
        if (beforeHours == null || beforeHours < 0) {
            beforeHours = 24; // 默认24小时
        }

        logger.info("自动确认订单: beforeHours={}", beforeHours);

        List<Orders> pendingOrders = getPendingAutoConfirmOrders(beforeHours);
        int confirmedCount = 0;

        for (Orders order : pendingOrders) {
            try {
                if (confirmOrder(order.getId())) {
                    confirmedCount++;
                }
            } catch (Exception e) {
                logger.warn("自动确认订单失败: orderId={}, error={}", order.getId(), e.getMessage());
            }
        }

        logger.info("自动确认订单完成: 确认数量={}", confirmedCount);
        return confirmedCount;
    }

    @Override
    @Transactional(readOnly = true)
    public Long countUserOrders(Long userId, Integer orderStatus) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return ordersMapper.countUserOrders(userId, orderStatus);
    }

    @Override
    @Transactional(readOnly = true)
    public Long countRoomOrders(Long roomId, Integer orderStatus) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        return ordersMapper.countRoomOrders(roomId, orderStatus);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getOrderStatistics() {
        logger.debug("获取订单统计信息");

        Map<String, Object> statistics = new HashMap<>();

        // 总订单数
        Long totalOrders = ordersMapper.countOrders(null, null, null, null, null, null, null);
        statistics.put("totalOrders", totalOrders);

        // 各状态订单数
        Long pendingOrders = ordersMapper.countOrders(null, null, Constants.OrderStatus.PENDING, null, null, null,
                null);
        statistics.put("pendingOrders", pendingOrders);

        Long confirmedOrders = ordersMapper.countOrders(null, null, Constants.OrderStatus.CONFIRMED, null, null, null,
                null);
        statistics.put("confirmedOrders", confirmedOrders);

        Long checkedInOrders = ordersMapper.countOrders(null, null, Constants.OrderStatus.CHECKED_IN, null, null, null,
                null);
        statistics.put("checkedInOrders", checkedInOrders);

        Long completedOrders = ordersMapper.countOrders(null, null, Constants.OrderStatus.COMPLETED, null, null, null,
                null);
        statistics.put("completedOrders", completedOrders);

        Long cancelledOrders = ordersMapper.countOrders(null, null, Constants.OrderStatus.CANCELLED, null, null, null,
                null);
        statistics.put("cancelledOrders", cancelledOrders);

        // 各支付状态订单数
        Long unpaidOrders = ordersMapper.countOrders(null, null, null, Constants.PaymentStatus.UNPAID, null, null,
                null);
        statistics.put("unpaidOrders", unpaidOrders);

        Long paidOrders = ordersMapper.countOrders(null, null, null, Constants.PaymentStatus.PAID, null, null, null);
        statistics.put("paidOrders", paidOrders);

        Long refundedOrders = ordersMapper.countOrders(null, null, null, Constants.PaymentStatus.REFUNDED, null, null,
                null);
        statistics.put("refundedOrders", refundedOrders);

        return statistics;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getUserOrderStatistics(Long userId) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }

        logger.debug("获取用户订单统计信息: userId={}", userId);

        Map<String, Object> statistics = new HashMap<>();

        // 总订单数
        Long totalOrders = countUserOrders(userId, null);
        statistics.put("totalOrders", totalOrders);

        // 各状态订单数
        Long pendingOrders = countUserOrders(userId, Constants.OrderStatus.PENDING);
        statistics.put("pendingOrders", pendingOrders);

        Long confirmedOrders = countUserOrders(userId, Constants.OrderStatus.CONFIRMED);
        statistics.put("confirmedOrders", confirmedOrders);

        Long checkedInOrders = countUserOrders(userId, Constants.OrderStatus.CHECKED_IN);
        statistics.put("checkedInOrders", checkedInOrders);

        Long completedOrders = countUserOrders(userId, Constants.OrderStatus.COMPLETED);
        statistics.put("completedOrders", completedOrders);

        Long cancelledOrders = countUserOrders(userId, Constants.OrderStatus.CANCELLED);
        statistics.put("cancelledOrders", cancelledOrders);

        // 用户总消费金额
        Double totalSpent = ordersMapper.getUserTotalSpent(userId);
        statistics.put("totalSpent", totalSpent != null ? totalSpent : 0.0);

        return statistics;
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalOrderCount() {
        logger.debug("获取订单总数");
        return ordersMapper.countOrders(null, null, null, null, null, null, null);
    }

    @Override
    @Transactional(readOnly = true)
    public long getPendingOrderCount() {
        logger.debug("获取待确认订单数");
        return ordersMapper.countOrders(null, null, Constants.OrderStatus.PENDING, null, null, null, null);
    }

    @Override
    @Transactional(readOnly = true)
    public long getCompletedOrderCountToday() {
        logger.debug("获取今日完成订单数");
        return ordersMapper.countCompletedOrdersToday();
    }

    @Override
    @Transactional(readOnly = true)
    public double getTotalRevenue() {
        logger.debug("获取总收入");
        Double revenue = ordersMapper.getTotalRevenue();
        return revenue != null ? revenue : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public double getRevenueToday() {
        logger.debug("获取今日收入");
        Double revenue = ordersMapper.getRevenueToday();
        return revenue != null ? revenue : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public double getRevenueThisMonth() {
        logger.debug("获取本月收入");
        Double revenue = ordersMapper.getRevenueThisMonth();
        return revenue != null ? revenue : 0.0;
    }
}
