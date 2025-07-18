package com.hms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 订单实体类
 */
public class Orders implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 订单ID
     */
    private Long id;
    
    /**
     * 订单号
     */
    private String orderNo;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 房源ID
     */
    private Long roomId;
    
    /**
     * 入住日期
     */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate checkInDate;
    
    /**
     * 退房日期
     */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate checkOutDate;
    
    /**
     * 入住天数
     */
    private Integer nights;
    
    /**
     * 入住人数
     */
    private Integer guests;
    
    /**
     * 订单总价
     */
    private BigDecimal totalPrice;
    
    /**
     * 联系人姓名
     */
    private String contactName;
    
    /**
     * 联系人电话
     */
    private String contactPhone;
    
    /**
     * 联系人邮箱
     */
    private String contactEmail;
    
    /**
     * 特殊要求
     */
    private String specialRequests;
    
    /**
     * 订单状态：0=待确认，1=已确认，2=已入住，3=已完成，4=已取消
     */
    private Integer orderStatus;
    
    /**
     * 支付状态：0=未支付，1=已支付，2=已退款
     */
    private Integer paymentStatus;
    
    /**
     * 支付时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime paymentTime;
    
    /**
     * 取消原因
     */
    private String cancelReason;
    
    /**
     * 取消时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime cancelTime;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    
    /**
     * 逻辑删除：0=未删除，1=已删除
     */
    private Integer deleted;
    
    /**
     * 关联用户信息（查询时使用）
     */
    private User user;
    
    /**
     * 关联房源信息（查询时使用）
     */
    private Room room;
    
    // 构造方法
    public Orders() {}
    
    public Orders(String orderNo, Long userId, Long roomId, LocalDate checkInDate, 
                  LocalDate checkOutDate, Integer nights, Integer guests, BigDecimal totalPrice,
                  String contactName, String contactPhone) {
        this.orderNo = orderNo;
        this.userId = userId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.nights = nights;
        this.guests = guests;
        this.totalPrice = totalPrice;
        this.contactName = contactName;
        this.contactPhone = contactPhone;
        this.orderStatus = 0; // 待确认
        this.paymentStatus = 0; // 未支付
        this.deleted = 0;
    }
    
    // Getter和Setter方法
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getOrderNo() {
        return orderNo;
    }
    
    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public Long getRoomId() {
        return roomId;
    }
    
    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }
    
    public LocalDate getCheckInDate() {
        return checkInDate;
    }
    
    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }
    
    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }
    
    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }
    
    public Integer getNights() {
        return nights;
    }
    
    public void setNights(Integer nights) {
        this.nights = nights;
    }
    
    public Integer getGuests() {
        return guests;
    }
    
    public void setGuests(Integer guests) {
        this.guests = guests;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public String getContactName() {
        return contactName;
    }
    
    public void setContactName(String contactName) {
        this.contactName = contactName;
    }
    
    public String getContactPhone() {
        return contactPhone;
    }
    
    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }
    
    public String getContactEmail() {
        return contactEmail;
    }
    
    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }
    
    public String getSpecialRequests() {
        return specialRequests;
    }
    
    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }
    
    public Integer getOrderStatus() {
        return orderStatus;
    }
    
    public void setOrderStatus(Integer orderStatus) {
        this.orderStatus = orderStatus;
    }
    
    public Integer getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(Integer paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public LocalDateTime getPaymentTime() {
        return paymentTime;
    }
    
    public void setPaymentTime(LocalDateTime paymentTime) {
        this.paymentTime = paymentTime;
    }
    
    public String getCancelReason() {
        return cancelReason;
    }
    
    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }
    
    public LocalDateTime getCancelTime() {
        return cancelTime;
    }
    
    public void setCancelTime(LocalDateTime cancelTime) {
        this.cancelTime = cancelTime;
    }
    
    public LocalDateTime getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
    
    public LocalDateTime getUpdateTime() {
        return updateTime;
    }
    
    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }
    
    public Integer getDeleted() {
        return deleted;
    }
    
    public void setDeleted(Integer deleted) {
        this.deleted = deleted;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Room getRoom() {
        return room;
    }
    
    public void setRoom(Room room) {
        this.room = room;
    }
    
    /**
     * 获取订单状态描述
     */
    public String getOrderStatusDesc() {
        if (orderStatus == null) return "未知";
        switch (orderStatus) {
            case 0: return "待确认";
            case 1: return "已确认";
            case 2: return "已入住";
            case 3: return "已完成";
            case 4: return "已取消";
            default: return "未知";
        }
    }
    
    /**
     * 获取支付状态描述
     */
    public String getPaymentStatusDesc() {
        if (paymentStatus == null) return "未知";
        switch (paymentStatus) {
            case 0: return "未支付";
            case 1: return "已支付";
            case 2: return "已退款";
            default: return "未知";
        }
    }
    
    /**
     * 判断订单是否可以取消
     */
    public boolean canCancel() {
        return orderStatus != null && (orderStatus == 0 || orderStatus == 1) && 
               (deleted == null || deleted == 0);
    }
    
    @Override
    public String toString() {
        return "Orders{" +
                "id=" + id +
                ", orderNo='" + orderNo + '\'' +
                ", userId=" + userId +
                ", roomId=" + roomId +
                ", checkInDate=" + checkInDate +
                ", checkOutDate=" + checkOutDate +
                ", nights=" + nights +
                ", totalPrice=" + totalPrice +
                ", orderStatus=" + orderStatus +
                ", paymentStatus=" + paymentStatus +
                '}';
    }
}
