package com.hms.service.impl;

import com.hms.entity.Room;
import com.hms.entity.RoomImage;
import com.hms.mapper.RoomImageMapper;
import com.hms.mapper.RoomMapper;
import com.hms.service.RoomService;
import com.hms.util.Constants;
import com.hms.vo.PageResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 房源Service实现类
 */
@Service
@Transactional
public class RoomServiceImpl implements RoomService {

    private static final Logger logger = LoggerFactory.getLogger(RoomServiceImpl.class);

    @Autowired
    private RoomMapper roomMapper;

    @Autowired
    private RoomImageMapper roomImageMapper;

    @Override
    @Transactional(readOnly = true)
    public Room getRoomById(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        return roomMapper.selectById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Room getRoomWithImages(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        return roomMapper.selectByIdWithImages(id);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<Room> getRoomList(Integer pageNum, Integer pageSize,
            String city, String district, String roomType,
            BigDecimal minPrice, BigDecimal maxPrice,
            Integer maxGuests, Integer status, String keyword) {
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

        logger.debug("查询房源列表: pageNum={}, pageSize={}, city={}, district={}, roomType={}, keyword={}",
                pageNum, pageSize, city, district, roomType, keyword);

        // 查询总数
        Long total = roomMapper.countRooms(city, district, roomType, minPrice, maxPrice, maxGuests, status, keyword);

        // 查询数据
        List<Room> rooms = roomMapper.selectAll(city, district, roomType, minPrice, maxPrice, maxGuests, status,
                keyword);

        // 封装分页结果
        return PageResult.of(pageNum, pageSize, total, rooms);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<Room> getAvailableRooms(Integer pageNum, Integer pageSize,
            LocalDate checkInDate, LocalDate checkOutDate,
            String city, String district, String roomType,
            BigDecimal minPrice, BigDecimal maxPrice,
            Integer maxGuests, String keyword) {
        // 参数校验
        if (pageNum == null || pageNum < 1) {
            pageNum = Constants.Page.DEFAULT_PAGE_NUM;
        }
        if (pageSize == null || pageSize < 1) {
            pageSize = Constants.Page.DEFAULT_PAGE_SIZE;
        }
        if (pageSize > Constants.Page.MAX_PAGE_SIZE) {
            pageSize = Constants.Page.MAX_PAGE_SIZE;
        }

        if (checkInDate == null || checkOutDate == null) {
            throw new IllegalArgumentException("入住和退房日期不能为空");
        }
        if (!checkOutDate.isAfter(checkInDate)) {
            throw new IllegalArgumentException("退房日期必须晚于入住日期");
        }

        logger.debug("查询可用房源: checkIn={}, checkOut={}, city={}, keyword={}",
                checkInDate, checkOutDate, city, keyword);

        // 查询可用房源
        List<Room> rooms = roomMapper.selectAvailableRooms(checkInDate, checkOutDate,
                city, district, roomType,
                minPrice, maxPrice, maxGuests, keyword);

        // 这里简化处理，实际应该有专门的count方法
        Long total = (long) rooms.size();

        return PageResult.of(pageNum, pageSize, total, rooms);
    }

    @Override
    public Room createRoom(Room room) {
        if (room == null) {
            throw new IllegalArgumentException("房源信息不能为空");
        }

        // 基本验证
        if (room.getRoomName() == null || room.getRoomName().trim().isEmpty()) {
            throw new IllegalArgumentException("房源名称不能为空");
        }
        if (room.getRoomType() == null || room.getRoomType().trim().isEmpty()) {
            throw new IllegalArgumentException("房型不能为空");
        }
        if (room.getAddress() == null || room.getAddress().trim().isEmpty()) {
            throw new IllegalArgumentException("地址不能为空");
        }
        if (room.getCity() == null || room.getCity().trim().isEmpty()) {
            throw new IllegalArgumentException("城市不能为空");
        }
        if (room.getPricePerNight() == null || room.getPricePerNight().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("价格必须大于0");
        }
        if (room.getMaxGuests() == null || room.getMaxGuests() <= 0) {
            throw new IllegalArgumentException("最大入住人数必须大于0");
        }

        logger.info("创建房源: {}", room.getRoomName());

        // 设置默认值
        if (room.getStatus() == null) {
            room.setStatus(Constants.RoomStatus.ONLINE);
        }
        room.setDeleted(Constants.DeleteFlag.NOT_DELETED);

        // 保存房源
        int result = roomMapper.insert(room);
        if (result <= 0) {
            throw new RuntimeException("创建房源失败");
        }

        logger.info("房源创建成功: {} (ID: {})", room.getRoomName(), room.getId());
        return room;
    }

    @Override
    @Transactional
    public Room updateRoom(Room room) {
        if (room == null || room.getId() == null) {
            throw new IllegalArgumentException("房源信息不完整");
        }

        logger.info("更新房源信息: ID={}", room.getId());

        // 检查房源是否存在
        Room existingRoom = roomMapper.selectById(room.getId());
        if (existingRoom == null) {
            throw new RuntimeException("房源不存在");
        }

        // 更新房源基本信息
        int result = roomMapper.update(room);
        if (result <= 0) {
            throw new RuntimeException("更新房源信息失败");
        }

        // 处理图片更新
        if (room.getImages() != null) {
            updateRoomImages(room.getId(), room.getImages());
        }

        logger.info("房源信息更新成功: ID={}", room.getId());
        return roomMapper.selectByIdWithImages(room.getId());
    }

    /**
     * 更新房源图片
     */
    private void updateRoomImages(Long roomId, List<RoomImage> newImages) {
        logger.info("更新房源图片: roomId={}, imageCount={}", roomId, newImages.size());

        // 删除原有图片
        roomImageMapper.deleteByRoomId(roomId);

        // 添加新图片
        if (!newImages.isEmpty()) {
            for (int i = 0; i < newImages.size(); i++) {
                RoomImage image = newImages.get(i);
                image.setRoomId(roomId);
                image.setSortOrder(i + 1);
                image.setDeleted(Constants.DeleteFlag.NOT_DELETED);

                // 如果没有指定封面，第一张图片作为封面
                if (image.getIsCover() == null) {
                    image.setIsCover(i == 0 ? 1 : 0);
                }

                roomImageMapper.insert(image);
            }
        }

        logger.info("房源图片更新完成: roomId={}", roomId);
    }

    @Override
    public boolean updateRoomStatus(Long id, Integer status) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        if (status == null) {
            throw new IllegalArgumentException("状态不能为空");
        }

        logger.info("更新房源状态: ID={}, status={}", id, status);

        int result = roomMapper.updateStatus(id, status);
        boolean success = result > 0;

        if (success) {
            logger.info("房源状态更新成功: ID={}", id);
        } else {
            logger.warn("房源状态更新失败: ID={}", id);
        }

        return success;
    }

    @Override
    public boolean deleteRoom(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }

        logger.info("删除房源: ID={}", id);

        // 同时删除房源图片
        roomImageMapper.deleteByRoomId(id);

        int result = roomMapper.deleteById(id);
        boolean success = result > 0;

        if (success) {
            logger.info("房源删除成功: ID={}", id);
        } else {
            logger.warn("房源删除失败: ID={}", id);
        }

        return success;
    }

    @Override
    public int deleteRooms(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            throw new IllegalArgumentException("房源ID列表不能为空");
        }

        logger.info("批量删除房源: count={}", ids.size());

        // 批量删除房源图片
        for (Long id : ids) {
            roomImageMapper.deleteByRoomId(id);
        }

        int result = roomMapper.deleteBatch(ids);

        logger.info("批量删除房源完成: 删除数量={}", result);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isRoomAvailable(Long roomId, LocalDate checkInDate, LocalDate checkOutDate, Long excludeOrderId) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        if (checkInDate == null || checkOutDate == null) {
            throw new IllegalArgumentException("入住和退房日期不能为空");
        }
        if (!checkOutDate.isAfter(checkInDate)) {
            throw new IllegalArgumentException("退房日期必须晚于入住日期");
        }

        return roomMapper.isRoomAvailable(roomId, checkInDate, checkOutDate, excludeOrderId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getAllCities() {
        return roomMapper.selectAllCities();
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getDistrictsByCity(String city) {
        if (city == null || city.trim().isEmpty()) {
            throw new IllegalArgumentException("城市不能为空");
        }
        return roomMapper.selectDistrictsByCity(city);
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getAllRoomTypes() {
        return roomMapper.selectAllRoomTypes();
    }

    @Override
    public RoomImage addRoomImage(Long roomId, String imageUrl, String imageName, boolean isCover) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            throw new IllegalArgumentException("图片URL不能为空");
        }

        logger.info("添加房源图片: roomId={}, imageUrl={}, isCover={}", roomId, imageUrl, isCover);

        // 检查房源是否存在
        Room room = roomMapper.selectById(roomId);
        if (room == null) {
            throw new RuntimeException("房源不存在");
        }

        // 如果是封面图，先清除其他封面图
        if (isCover) {
            roomImageMapper.clearCoverImages(roomId);
        }

        // 获取下一个排序号
        Integer sortOrder = roomImageMapper.getNextSortOrder(roomId);

        // 创建图片对象
        RoomImage roomImage = new RoomImage();
        roomImage.setRoomId(roomId);
        roomImage.setImageUrl(imageUrl);
        roomImage.setImageName(imageName);
        roomImage.setIsCover(isCover ? 1 : 0);
        roomImage.setSortOrder(sortOrder);
        roomImage.setDeleted(Constants.DeleteFlag.NOT_DELETED);

        // 保存图片
        int result = roomImageMapper.insert(roomImage);
        if (result <= 0) {
            throw new RuntimeException("添加房源图片失败");
        }

        logger.info("房源图片添加成功: ID={}", roomImage.getId());
        return roomImage;
    }

    @Override
    public int addRoomImages(Long roomId, List<RoomImage> images) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        if (images == null || images.isEmpty()) {
            throw new IllegalArgumentException("图片列表不能为空");
        }

        logger.info("批量添加房源图片: roomId={}, count={}", roomId, images.size());

        // 检查房源是否存在
        Room room = roomMapper.selectById(roomId);
        if (room == null) {
            throw new RuntimeException("房源不存在");
        }

        // 设置房源ID和默认值
        for (RoomImage image : images) {
            image.setRoomId(roomId);
            if (image.getDeleted() == null) {
                image.setDeleted(Constants.DeleteFlag.NOT_DELETED);
            }
        }

        // 批量保存
        int result = roomImageMapper.insertBatch(images);

        logger.info("批量添加房源图片完成: 添加数量={}", result);
        return result;
    }

    @Override
    public boolean setCoverImage(Long roomId, Long imageId) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        if (imageId == null || imageId <= 0) {
            throw new IllegalArgumentException("图片ID不能为空");
        }

        logger.info("设置封面图片: roomId={}, imageId={}", roomId, imageId);

        // 先清除原封面
        roomImageMapper.clearCoverImages(roomId);

        // 设置新封面
        int result = roomImageMapper.setCoverImage(roomId, imageId);
        boolean success = result > 0;

        if (success) {
            logger.info("封面图片设置成功: roomId={}, imageId={}", roomId, imageId);
        } else {
            logger.warn("封面图片设置失败: roomId={}, imageId={}", roomId, imageId);
        }

        return success;
    }

    @Override
    public boolean deleteRoomImage(Long imageId) {
        if (imageId == null || imageId <= 0) {
            throw new IllegalArgumentException("图片ID不能为空");
        }

        logger.info("删除房源图片: ID={}", imageId);

        int result = roomImageMapper.deleteById(imageId);
        boolean success = result > 0;

        if (success) {
            logger.info("房源图片删除成功: ID={}", imageId);
        } else {
            logger.warn("房源图片删除失败: ID={}", imageId);
        }

        return success;
    }

    @Override
    @Transactional(readOnly = true)
    public List<RoomImage> getRoomImages(Long roomId) {
        if (roomId == null || roomId <= 0) {
            throw new IllegalArgumentException("房源ID不能为空");
        }
        return roomImageMapper.selectByRoomId(roomId);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getRoomStatistics() {
        logger.debug("获取房源统计信息");

        Map<String, Object> statistics = new HashMap<>();

        // 总房源数
        Long totalRooms = roomMapper.countRooms(null, null, null, null, null, null, null, null);
        statistics.put("totalRooms", totalRooms);

        // 上架房源数
        Long onlineRooms = roomMapper.countRooms(null, null, null, null, null, null, Constants.RoomStatus.ONLINE, null);
        statistics.put("onlineRooms", onlineRooms);

        // 下架房源数
        Long offlineRooms = roomMapper.countRooms(null, null, null, null, null, null, Constants.RoomStatus.OFFLINE,
                null);
        statistics.put("offlineRooms", offlineRooms);

        // 维护中房源数
        Long maintenanceRooms = roomMapper.countRooms(null, null, null, null, null, null,
                Constants.RoomStatus.MAINTENANCE, null);
        statistics.put("maintenanceRooms", maintenanceRooms);

        // 城市数量
        List<String> cities = roomMapper.selectAllCities();
        statistics.put("cityCount", cities.size());

        // 房型数量
        List<String> roomTypes = roomMapper.selectAllRoomTypes();
        statistics.put("roomTypeCount", roomTypes.size());

        return statistics;
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalRoomCount() {
        logger.debug("获取房源总数");
        return roomMapper.countRooms(null, null, null, null, null, null, null, null);
    }

    @Override
    @Transactional(readOnly = true)
    public long getOnlineRoomCount() {
        logger.debug("获取上架房源数");
        return roomMapper.countRooms(null, null, null, null, null, null, Constants.RoomStatus.ONLINE, null);
    }

    @Override
    @Transactional(readOnly = true)
    public long getNewRoomCountToday() {
        logger.debug("获取今日新增房源数");
        return roomMapper.countNewRoomsToday();
    }
}
