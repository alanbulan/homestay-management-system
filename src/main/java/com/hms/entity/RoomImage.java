package com.hms.entity;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 房源图片实体类
 */
public class RoomImage implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 图片ID
     */
    private Long id;
    
    /**
     * 房源ID
     */
    private Long roomId;
    
    /**
     * 图片URL
     */
    private String imageUrl;
    
    /**
     * 图片名称
     */
    private String imageName;
    
    /**
     * 是否为封面图：0=否，1=是
     */
    private Integer isCover;
    
    /**
     * 排序顺序
     */
    private Integer sortOrder;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    /**
     * 逻辑删除：0=未删除，1=已删除
     */
    private Integer deleted;
    
    // 构造方法
    public RoomImage() {}
    
    public RoomImage(Long roomId, String imageUrl, String imageName, Integer isCover, Integer sortOrder) {
        this.roomId = roomId;
        this.imageUrl = imageUrl;
        this.imageName = imageName;
        this.isCover = isCover;
        this.sortOrder = sortOrder;
        this.deleted = 0;
    }
    
    // Getter和Setter方法
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getRoomId() {
        return roomId;
    }
    
    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getImageName() {
        return imageName;
    }
    
    public void setImageName(String imageName) {
        this.imageName = imageName;
    }
    
    public Integer getIsCover() {
        return isCover;
    }
    
    public void setIsCover(Integer isCover) {
        this.isCover = isCover;
    }
    
    public Integer getSortOrder() {
        return sortOrder;
    }
    
    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }
    
    public LocalDateTime getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
    
    public Integer getDeleted() {
        return deleted;
    }
    
    public void setDeleted(Integer deleted) {
        this.deleted = deleted;
    }
    
    /**
     * 判断是否为封面图
     */
    public boolean isCoverImage() {
        return isCover != null && isCover == 1;
    }
    
    /**
     * 判断图片是否有效
     */
    public boolean isValid() {
        return deleted == null || deleted == 0;
    }
    
    @Override
    public String toString() {
        return "RoomImage{" +
                "id=" + id +
                ", roomId=" + roomId +
                ", imageUrl='" + imageUrl + '\'' +
                ", imageName='" + imageName + '\'' +
                ", isCover=" + isCover +
                ", sortOrder=" + sortOrder +
                ", createTime=" + createTime +
                '}';
    }
}
