package com.hms.mapper;

import com.hms.entity.Room;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 房源Mapper接口
 */
public interface RoomMapper {

        /**
         * 根据ID查询房源
         * 
         * @param id 房源ID
         * @return 房源信息
         */
        Room selectById(@Param("id") Long id);

        /**
         * 根据ID查询房源（包含图片）
         * 
         * @param id 房源ID
         * @return 房源信息（包含图片列表）
         */
        Room selectByIdWithImages(@Param("id") Long id);

        /**
         * 查询所有房源（分页）
         *
         * @param city      城市（可选）
         * @param district  区域（可选）
         * @param roomType  房型（可选）
         * @param minPrice  最低价格（可选）
         * @param maxPrice  最高价格（可选）
         * @param maxGuests 最大入住人数（可选）
         * @param status    状态（可选）
         * @param keyword   搜索关键词（可选）
         * @param offset    偏移量
         * @param limit     限制数量
         * @return 房源列表
         */
        List<Room> selectAll(@Param("city") String city,
                        @Param("district") String district,
                        @Param("roomType") String roomType,
                        @Param("minPrice") BigDecimal minPrice,
                        @Param("maxPrice") BigDecimal maxPrice,
                        @Param("maxGuests") Integer maxGuests,
                        @Param("status") Integer status,
                        @Param("keyword") String keyword,
                        @Param("offset") Integer offset,
                        @Param("limit") Integer limit);

        /**
         * 查询可用房源（排除指定日期范围内已预订的房源）
         * 
         * @param checkInDate  入住日期
         * @param checkOutDate 退房日期
         * @param city         城市（可选）
         * @param district     区域（可选）
         * @param roomType     房型（可选）
         * @param minPrice     最低价格（可选）
         * @param maxPrice     最高价格（可选）
         * @param maxGuests    最大入住人数（可选）
         * @param keyword      搜索关键词（可选）
         * @return 可用房源列表
         */
        List<Room> selectAvailableRooms(@Param("checkInDate") LocalDate checkInDate,
                        @Param("checkOutDate") LocalDate checkOutDate,
                        @Param("city") String city,
                        @Param("district") String district,
                        @Param("roomType") String roomType,
                        @Param("minPrice") BigDecimal minPrice,
                        @Param("maxPrice") BigDecimal maxPrice,
                        @Param("maxGuests") Integer maxGuests,
                        @Param("keyword") String keyword);

        /**
         * 统计房源数量
         * 
         * @param city      城市（可选）
         * @param district  区域（可选）
         * @param roomType  房型（可选）
         * @param minPrice  最低价格（可选）
         * @param maxPrice  最高价格（可选）
         * @param maxGuests 最大入住人数（可选）
         * @param status    状态（可选）
         * @param keyword   搜索关键词（可选）
         * @return 房源数量
         */
        Long countRooms(@Param("city") String city,
                        @Param("district") String district,
                        @Param("roomType") String roomType,
                        @Param("minPrice") BigDecimal minPrice,
                        @Param("maxPrice") BigDecimal maxPrice,
                        @Param("maxGuests") Integer maxGuests,
                        @Param("status") Integer status,
                        @Param("keyword") String keyword);

        /**
         * 获取所有城市列表
         * 
         * @return 城市列表
         */
        List<String> selectAllCities();

        /**
         * 根据城市获取区域列表
         * 
         * @param city 城市
         * @return 区域列表
         */
        List<String> selectDistrictsByCity(@Param("city") String city);

        /**
         * 获取所有房型列表
         * 
         * @return 房型列表
         */
        List<String> selectAllRoomTypes();

        /**
         * 插入房源
         * 
         * @param room 房源信息
         * @return 影响行数
         */
        int insert(Room room);

        /**
         * 更新房源信息
         * 
         * @param room 房源信息
         * @return 影响行数
         */
        int update(Room room);

        /**
         * 更新房源状态
         * 
         * @param id     房源ID
         * @param status 新状态
         * @return 影响行数
         */
        int updateStatus(@Param("id") Long id, @Param("status") Integer status);

        /**
         * 逻辑删除房源
         * 
         * @param id 房源ID
         * @return 影响行数
         */
        int deleteById(@Param("id") Long id);

        /**
         * 批量逻辑删除房源
         * 
         * @param ids 房源ID列表
         * @return 影响行数
         */
        int deleteBatch(@Param("ids") List<Long> ids);

        /**
         * 检查房源在指定日期范围内是否可用
         *
         * @param roomId         房源ID
         * @param checkInDate    入住日期
         * @param checkOutDate   退房日期
         * @param excludeOrderId 排除的订单ID（用于更新订单时检查）
         * @return 是否可用
         */
        boolean isRoomAvailable(@Param("roomId") Long roomId,
                        @Param("checkInDate") LocalDate checkInDate,
                        @Param("checkOutDate") LocalDate checkOutDate,
                        @Param("excludeOrderId") Long excludeOrderId);

        /**
         * 统计今日新增房源数
         *
         * @return 今日新增房源数
         */
        long countNewRoomsToday();
}
