package com.hms.service;

import com.hms.entity.Room;
import com.hms.entity.RoomImage;
import com.hms.vo.PageResult;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 房源Service接口
 */
public interface RoomService {

    /**
     * 根据ID查询房源
     * 
     * @param id 房源ID
     * @return 房源信息
     */
    Room getRoomById(Long id);

    /**
     * 根据ID查询房源（包含图片）
     * 
     * @param id 房源ID
     * @return 房源信息（包含图片列表）
     */
    Room getRoomWithImages(Long id);

    /**
     * 分页查询房源列表
     * 
     * @param pageNum   页码
     * @param pageSize  页面大小
     * @param city      城市（可选）
     * @param district  区域（可选）
     * @param roomType  房型（可选）
     * @param minPrice  最低价格（可选）
     * @param maxPrice  最高价格（可选）
     * @param maxGuests 最大入住人数（可选）
     * @param status    状态（可选）
     * @param keyword   搜索关键词（可选）
     * @return 分页结果
     */
    PageResult<Room> getRoomList(Integer pageNum, Integer pageSize,
            String city, String district, String roomType,
            BigDecimal minPrice, BigDecimal maxPrice,
            Integer maxGuests, Integer status, String keyword);

    /**
     * 查询可用房源
     * 
     * @param pageNum      页码
     * @param pageSize     页面大小
     * @param checkInDate  入住日期
     * @param checkOutDate 退房日期
     * @param city         城市（可选）
     * @param district     区域（可选）
     * @param roomType     房型（可选）
     * @param minPrice     最低价格（可选）
     * @param maxPrice     最高价格（可选）
     * @param maxGuests    最大入住人数（可选）
     * @param keyword      搜索关键词（可选）
     * @return 可用房源分页结果
     */
    PageResult<Room> getAvailableRooms(Integer pageNum, Integer pageSize,
            LocalDate checkInDate, LocalDate checkOutDate,
            String city, String district, String roomType,
            BigDecimal minPrice, BigDecimal maxPrice,
            Integer maxGuests, String keyword);

    /**
     * 创建房源
     * 
     * @param room 房源信息
     * @return 创建成功的房源信息
     */
    Room createRoom(Room room);

    /**
     * 更新房源信息
     * 
     * @param room 房源信息
     * @return 更新后的房源信息
     */
    Room updateRoom(Room room);

    /**
     * 更新房源状态
     * 
     * @param id     房源ID
     * @param status 新状态
     * @return 是否更新成功
     */
    boolean updateRoomStatus(Long id, Integer status);

    /**
     * 删除房源
     * 
     * @param id 房源ID
     * @return 是否删除成功
     */
    boolean deleteRoom(Long id);

    /**
     * 批量删除房源
     * 
     * @param ids 房源ID列表
     * @return 删除成功的数量
     */
    int deleteRooms(List<Long> ids);

    /**
     * 检查房源在指定日期范围内是否可用
     * 
     * @param roomId         房源ID
     * @param checkInDate    入住日期
     * @param checkOutDate   退房日期
     * @param excludeOrderId 排除的订单ID（用于更新订单时检查）
     * @return 是否可用
     */
    boolean isRoomAvailable(Long roomId, LocalDate checkInDate, LocalDate checkOutDate, Long excludeOrderId);

    /**
     * 获取所有城市列表
     * 
     * @return 城市列表
     */
    List<String> getAllCities();

    /**
     * 根据城市获取区域列表
     * 
     * @param city 城市
     * @return 区域列表
     */
    List<String> getDistrictsByCity(String city);

    /**
     * 获取所有房型列表
     * 
     * @return 房型列表
     */
    List<String> getAllRoomTypes();

    /**
     * 添加房源图片
     * 
     * @param roomId    房源ID
     * @param imageUrl  图片URL
     * @param imageName 图片名称
     * @param isCover   是否为封面图
     * @return 添加成功的图片信息
     */
    RoomImage addRoomImage(Long roomId, String imageUrl, String imageName, boolean isCover);

    /**
     * 批量添加房源图片
     * 
     * @param roomId 房源ID
     * @param images 图片列表
     * @return 添加成功的数量
     */
    int addRoomImages(Long roomId, List<RoomImage> images);

    /**
     * 设置封面图片
     * 
     * @param roomId  房源ID
     * @param imageId 图片ID
     * @return 是否设置成功
     */
    boolean setCoverImage(Long roomId, Long imageId);

    /**
     * 删除房源图片
     * 
     * @param imageId 图片ID
     * @return 是否删除成功
     */
    boolean deleteRoomImage(Long imageId);

    /**
     * 获取房源图片列表
     * 
     * @param roomId 房源ID
     * @return 图片列表
     */
    List<RoomImage> getRoomImages(Long roomId);

    /**
     * 获取房源统计信息
     *
     * @return 统计信息Map
     */
    Map<String, Object> getRoomStatistics();

    /**
     * 获取房源总数
     *
     * @return 房源总数
     */
    long getTotalRoomCount();

    /**
     * 获取上架房源数
     *
     * @return 上架房源数
     */
    long getOnlineRoomCount();

    /**
     * 获取今日新增房源数
     *
     * @return 今日新增房源数
     */
    long getNewRoomCountToday();
}
