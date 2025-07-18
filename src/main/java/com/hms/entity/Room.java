package com.hms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

/**
 * 房源实体类
 */
public class Room implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 房源ID
     */
    private Long id;
    
    /**
     * 房源名称
     */
    private String roomName;
    
    /**
     * 房型
     */
    private String roomType;
    
    /**
     * 房源描述
     */
    private String description;
    
    /**
     * 详细地址
     */
    private String address;
    
    /**
     * 所在城市
     */
    private String city;
    
    /**
     * 所在区域
     */
    private String district;
    
    /**
     * 每晚价格
     */
    private BigDecimal pricePerNight;
    
    /**
     * 最大入住人数
     */
    private Integer maxGuests;
    
    /**
     * 房间面积（平方米）
     */
    private BigDecimal area;
    
    /**
     * 楼层
     */
    private Integer floor;
    
    /**
     * 房间设施（JSON格式）
     */
    private String facilities;
    
    /**
     * 入住时间
     */
    @JsonFormat(pattern = "HH:mm:ss")
    private LocalTime checkInTime;
    
    /**
     * 退房时间
     */
    @JsonFormat(pattern = "HH:mm:ss")
    private LocalTime checkOutTime;
    
    /**
     * 房源状态：0=下架，1=上架，2=维护中
     */
    private Integer status;
    
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
     * 房源图片列表（关联查询）
     */
    private List<RoomImage> images;
    
    /**
     * 封面图片URL（关联查询）
     */
    private String coverImage;
    
    // 构造方法
    public Room() {}
    
    public Room(String roomName, String roomType, String description, String address, 
                String city, String district, BigDecimal pricePerNight, Integer maxGuests) {
        this.roomName = roomName;
        this.roomType = roomType;
        this.description = description;
        this.address = address;
        this.city = city;
        this.district = district;
        this.pricePerNight = pricePerNight;
        this.maxGuests = maxGuests;
        this.status = 1;
        this.deleted = 0;
    }
    
    // Getter和Setter方法
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    public String getRoomType() {
        return roomType;
    }
    
    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getDistrict() {
        return district;
    }
    
    public void setDistrict(String district) {
        this.district = district;
    }
    
    public BigDecimal getPricePerNight() {
        return pricePerNight;
    }
    
    public void setPricePerNight(BigDecimal pricePerNight) {
        this.pricePerNight = pricePerNight;
    }
    
    public Integer getMaxGuests() {
        return maxGuests;
    }
    
    public void setMaxGuests(Integer maxGuests) {
        this.maxGuests = maxGuests;
    }
    
    public BigDecimal getArea() {
        return area;
    }
    
    public void setArea(BigDecimal area) {
        this.area = area;
    }
    
    public Integer getFloor() {
        return floor;
    }
    
    public void setFloor(Integer floor) {
        this.floor = floor;
    }
    
    public String getFacilities() {
        return facilities;
    }
    
    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }
    
    public LocalTime getCheckInTime() {
        return checkInTime;
    }
    
    public void setCheckInTime(LocalTime checkInTime) {
        this.checkInTime = checkInTime;
    }
    
    public LocalTime getCheckOutTime() {
        return checkOutTime;
    }
    
    public void setCheckOutTime(LocalTime checkOutTime) {
        this.checkOutTime = checkOutTime;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setStatus(Integer status) {
        this.status = status;
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
    
    public List<RoomImage> getImages() {
        return images;
    }
    
    public void setImages(List<RoomImage> images) {
        this.images = images;
    }
    
    public String getCoverImage() {
        return coverImage;
    }
    
    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }
    
    /**
     * 判断房源是否可用
     */
    public boolean isAvailable() {
        return status != null && status == 1 && (deleted == null || deleted == 0);
    }
    
    @Override
    public String toString() {
        return "Room{" +
                "id=" + id +
                ", roomName='" + roomName + '\'' +
                ", roomType='" + roomType + '\'' +
                ", city='" + city + '\'' +
                ", district='" + district + '\'' +
                ", pricePerNight=" + pricePerNight +
                ", maxGuests=" + maxGuests +
                ", status=" + status +
                '}';
    }
}
