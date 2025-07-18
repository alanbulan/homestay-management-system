package com.hms.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * 订单创建DTO
 */
public class OrderCreateDTO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
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
     * 入住人数
     */
    private Integer guests;
    
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
    
    // 构造方法
    public OrderCreateDTO() {}
    
    public OrderCreateDTO(Long roomId, LocalDate checkInDate, LocalDate checkOutDate, 
                          Integer guests, String contactName, String contactPhone) {
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.guests = guests;
        this.contactName = contactName;
        this.contactPhone = contactPhone;
    }
    
    // Getter和Setter方法
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
    
    public Integer getGuests() {
        return guests;
    }
    
    public void setGuests(Integer guests) {
        this.guests = guests;
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
    
    /**
     * 计算入住天数
     */
    public Integer calculateNights() {
        if (checkInDate == null || checkOutDate == null) {
            return 0;
        }
        return (int) (checkOutDate.toEpochDay() - checkInDate.toEpochDay());
    }
    
    /**
     * 验证数据有效性
     */
    public boolean isValid() {
        // 检查必填字段
        if (roomId == null || roomId <= 0) {
            return false;
        }
        if (checkInDate == null || checkOutDate == null) {
            return false;
        }
        if (guests == null || guests <= 0) {
            return false;
        }
        if (contactName == null || contactName.trim().isEmpty()) {
            return false;
        }
        if (contactPhone == null || contactPhone.trim().isEmpty()) {
            return false;
        }
        
        // 检查日期逻辑
        if (!checkOutDate.isAfter(checkInDate)) {
            return false;
        }
        
        // 检查入住日期不能是过去的日期
        if (checkInDate.isBefore(LocalDate.now())) {
            return false;
        }
        
        return true;
    }
    
    /**
     * 获取验证错误信息
     */
    public String getValidationError() {
        if (roomId == null || roomId <= 0) {
            return "请选择房源";
        }
        if (checkInDate == null) {
            return "请选择入住日期";
        }
        if (checkOutDate == null) {
            return "请选择退房日期";
        }
        if (checkInDate.isBefore(LocalDate.now())) {
            return "入住日期不能是过去的日期";
        }
        if (!checkOutDate.isAfter(checkInDate)) {
            return "退房日期必须晚于入住日期";
        }
        if (guests == null || guests <= 0) {
            return "入住人数必须大于0";
        }
        if (contactName == null || contactName.trim().isEmpty()) {
            return "联系人姓名不能为空";
        }
        if (contactPhone == null || contactPhone.trim().isEmpty()) {
            return "联系人电话不能为空";
        }
        return null;
    }
    
    @Override
    public String toString() {
        return "OrderCreateDTO{" +
                "roomId=" + roomId +
                ", checkInDate=" + checkInDate +
                ", checkOutDate=" + checkOutDate +
                ", guests=" + guests +
                ", contactName='" + contactName + '\'' +
                ", contactPhone='" + contactPhone + '\'' +
                ", contactEmail='" + contactEmail + '\'' +
                ", nights=" + calculateNights() +
                '}';
    }
}
