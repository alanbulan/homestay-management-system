package com.hms.mapper;

import com.hms.entity.RoomImage;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 房源图片Mapper接口
 */
public interface RoomImageMapper {
    
    /**
     * 根据ID查询图片
     * 
     * @param id 图片ID
     * @return 图片信息
     */
    RoomImage selectById(@Param("id") Long id);
    
    /**
     * 根据房源ID查询所有图片
     * 
     * @param roomId 房源ID
     * @return 图片列表
     */
    List<RoomImage> selectByRoomId(@Param("roomId") Long roomId);
    
    /**
     * 根据房源ID查询封面图片
     * 
     * @param roomId 房源ID
     * @return 封面图片
     */
    RoomImage selectCoverByRoomId(@Param("roomId") Long roomId);
    
    /**
     * 插入图片
     * 
     * @param roomImage 图片信息
     * @return 影响行数
     */
    int insert(RoomImage roomImage);
    
    /**
     * 批量插入图片
     * 
     * @param images 图片列表
     * @return 影响行数
     */
    int insertBatch(@Param("images") List<RoomImage> images);
    
    /**
     * 更新图片信息
     * 
     * @param roomImage 图片信息
     * @return 影响行数
     */
    int update(RoomImage roomImage);
    
    /**
     * 设置封面图片（先清除原封面，再设置新封面）
     * 
     * @param roomId 房源ID
     * @param imageId 新封面图片ID
     * @return 影响行数
     */
    int setCoverImage(@Param("roomId") Long roomId, @Param("imageId") Long imageId);
    
    /**
     * 清除房源的所有封面图片标记
     * 
     * @param roomId 房源ID
     * @return 影响行数
     */
    int clearCoverImages(@Param("roomId") Long roomId);
    
    /**
     * 更新图片排序
     * 
     * @param imageId 图片ID
     * @param sortOrder 新排序
     * @return 影响行数
     */
    int updateSortOrder(@Param("imageId") Long imageId, @Param("sortOrder") Integer sortOrder);
    
    /**
     * 逻辑删除图片
     * 
     * @param id 图片ID
     * @return 影响行数
     */
    int deleteById(@Param("id") Long id);
    
    /**
     * 批量逻辑删除图片
     * 
     * @param ids 图片ID列表
     * @return 影响行数
     */
    int deleteBatch(@Param("ids") List<Long> ids);
    
    /**
     * 根据房源ID删除所有图片
     * 
     * @param roomId 房源ID
     * @return 影响行数
     */
    int deleteByRoomId(@Param("roomId") Long roomId);
    
    /**
     * 获取房源图片数量
     * 
     * @param roomId 房源ID
     * @return 图片数量
     */
    Long countByRoomId(@Param("roomId") Long roomId);
    
    /**
     * 获取房源下一个排序号
     * 
     * @param roomId 房源ID
     * @return 下一个排序号
     */
    Integer getNextSortOrder(@Param("roomId") Long roomId);
}
