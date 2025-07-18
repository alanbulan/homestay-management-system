package com.hms.controller;

import com.hms.config.LoginInterceptor;
import com.hms.entity.Room;
import com.hms.entity.RoomImage;
import com.hms.entity.User;
import com.hms.service.RoomService;
import com.hms.util.Constants;
import com.hms.vo.PageResult;
import com.hms.vo.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 房源Controller
 */
@Controller
@RequestMapping("/room")
public class RoomController {

    private static final Logger logger = LoggerFactory.getLogger(RoomController.class);

    @Autowired
    private RoomService roomService;

    /**
     * 房源列表页面
     */
    @GetMapping("/list")
    public String listPage(Model model) {
        // 获取筛选选项数据
        List<String> cities = roomService.getAllCities();
        List<String> roomTypes = roomService.getAllRoomTypes();

        model.addAttribute("cities", cities);
        model.addAttribute("roomTypes", roomTypes);

        return "room/list";
    }

    /**
     * 分页查询房源列表
     */
    @GetMapping("/search")
    @ResponseBody
    public Result<PageResult<Room>> searchRooms(@RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "12") Integer pageSize,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String district,
            @RequestParam(required = false) String roomType,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) Integer maxGuests,
            @RequestParam(required = false) String keyword) {
        try {
            logger.debug("搜索房源: city={}, roomType={}, keyword={}", city, roomType, keyword);

            PageResult<Room> result = roomService.getRoomList(pageNum, pageSize, city, district, roomType,
                    minPrice, maxPrice, maxGuests, Constants.RoomStatus.ONLINE, keyword);
            return Result.success(result);

        } catch (Exception e) {
            logger.error("搜索房源失败: {}", e.getMessage(), e);
            return Result.error("搜索失败");
        }
    }

    /**
     * 查询可用房源
     */
    @GetMapping("/available")
    @ResponseBody
    public Result<PageResult<Room>> getAvailableRooms(@RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "12") Integer pageSize,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate checkInDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate checkOutDate,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String district,
            @RequestParam(required = false) String roomType,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) Integer maxGuests,
            @RequestParam(required = false) String keyword) {
        try {
            logger.debug("查询可用房源: checkIn={}, checkOut={}, city={}", checkInDate, checkOutDate, city);

            PageResult<Room> result = roomService.getAvailableRooms(pageNum, pageSize, checkInDate, checkOutDate,
                    city, district, roomType, minPrice, maxPrice, maxGuests, keyword);
            return Result.success(result);

        } catch (Exception e) {
            logger.error("查询可用房源失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 房源详情页面
     */
    @GetMapping("/detail/{id}")
    public String detailPage(@PathVariable Long id, Model model) {
        try {
            Room room = roomService.getRoomWithImages(id);
            if (room == null) {
                model.addAttribute("error", "房源不存在");
                return "error/404";
            }

            model.addAttribute("room", room);
            return "room/detail";

        } catch (Exception e) {
            logger.error("获取房源详情失败: {}", e.getMessage(), e);
            model.addAttribute("error", "获取房源详情失败");
            return "error/500";
        }
    }

    /**
     * 获取房源详情（API）
     */
    @GetMapping("/detail/{id}/api")
    @ResponseBody
    public Result<Room> getRoomDetail(@PathVariable Long id) {
        try {
            Room room = roomService.getRoomWithImages(id);
            if (room == null) {
                return Result.notFound("房源不存在");
            }

            return Result.success(room);

        } catch (Exception e) {
            logger.error("获取房源详情失败: {}", e.getMessage(), e);
            return Result.error("获取房源详情失败");
        }
    }

    /**
     * 检查房源可用性
     */
    @GetMapping("/checkAvailability")
    @ResponseBody
    public Result<Boolean> checkRoomAvailability(@RequestParam Long roomId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate checkInDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate checkOutDate) {
        try {
            boolean available = roomService.isRoomAvailable(roomId, checkInDate, checkOutDate, null);
            return Result.success(available);

        } catch (Exception e) {
            logger.error("检查房源可用性失败: {}", e.getMessage(), e);
            return Result.error("检查失败");
        }
    }

    /**
     * 获取城市列表
     */
    @GetMapping("/cities")
    @ResponseBody
    public Result<List<String>> getCities() {
        try {
            List<String> cities = roomService.getAllCities();
            return Result.success(cities);

        } catch (Exception e) {
            logger.error("获取城市列表失败: {}", e.getMessage(), e);
            return Result.error("获取城市列表失败");
        }
    }

    /**
     * 根据城市获取区域列表
     */
    @GetMapping("/districts")
    @ResponseBody
    public Result<List<String>> getDistricts(@RequestParam String city) {
        try {
            List<String> districts = roomService.getDistrictsByCity(city);
            return Result.success(districts);

        } catch (Exception e) {
            logger.error("获取区域列表失败: {}", e.getMessage(), e);
            return Result.error("获取区域列表失败");
        }
    }

    /**
     * 获取房型列表
     */
    @GetMapping("/types")
    @ResponseBody
    public Result<List<String>> getRoomTypes() {
        try {
            List<String> roomTypes = roomService.getAllRoomTypes();
            return Result.success(roomTypes);

        } catch (Exception e) {
            logger.error("获取房型列表失败: {}", e.getMessage(), e);
            return Result.error("获取房型列表失败");
        }
    }

    // ==================== 管理员功能 ====================

    /**
     * 房源管理页面（管理员）
     */
    @GetMapping("/manage")
    public String managePage(HttpServletRequest request, Model model) {
        if (!LoginInterceptor.isCurrentUserAdmin(request)) {
            return "redirect:/403";
        }

        // 获取筛选选项数据
        List<String> cities = roomService.getAllCities();
        List<String> roomTypes = roomService.getAllRoomTypes();

        model.addAttribute("cities", cities);
        model.addAttribute("roomTypes", roomTypes);

        return "admin/room-manage";
    }

    /**
     * 分页查询房源列表（管理员）
     */
    @GetMapping("/manage/list")
    @ResponseBody
    public Result<PageResult<Room>> getRoomListForAdmin(@RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String district,
            @RequestParam(required = false) String roomType,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) Integer maxGuests,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            HttpServletRequest request) {
        try {
            logger.info("管理员房源列表请求: pageNum={}, pageSize={}", pageNum, pageSize);

            User currentUser = LoginInterceptor.getCurrentUser(request);
            logger.info("当前用户: {}", currentUser != null ? currentUser.getUsername() : "null");
            if (currentUser != null) {
                logger.info("用户类型: {}, 是否管理员: {}", currentUser.getUserType(), currentUser.isAdmin());
            }

            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                logger.warn("权限不足，拒绝访问房源管理列表");
                return Result.forbidden("权限不足");
            }

            logger.info("权限验证通过，开始查询房源列表");
            PageResult<Room> result = roomService.getRoomList(pageNum, pageSize, city, district, roomType,
                    minPrice, maxPrice, maxGuests, status, keyword);
            logger.info("房源列表查询完成，总数: {}", result.getTotal());
            return Result.success(result);

        } catch (Exception e) {
            logger.error("查询房源列表失败: {}", e.getMessage(), e);
            return Result.error("查询失败");
        }
    }

    /**
     * 创建房源（管理员）
     */
    @PostMapping("/create")
    @ResponseBody
    public Result<Room> createRoom(@RequestBody Room room, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            Room createdRoom = roomService.createRoom(room);

            logger.info("管理员创建房源成功: {}", createdRoom.getRoomName());
            return Result.success("房源创建成功", createdRoom);

        } catch (Exception e) {
            logger.error("创建房源失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 更新房源（管理员）
     */
    @PostMapping("/update")
    @ResponseBody
    public Result<Room> updateRoom(@RequestBody Room room, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            Room updatedRoom = roomService.updateRoom(room);

            logger.info("管理员更新房源成功: {}", updatedRoom.getRoomName());
            return Result.success("房源更新成功", updatedRoom);

        } catch (Exception e) {
            logger.error("更新房源失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 更新房源状态（管理员）
     */
    @PostMapping("/updateStatus")
    @ResponseBody
    public Result<Void> updateRoomStatus(@RequestParam Long roomId,
            @RequestParam Integer status,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = roomService.updateRoomStatus(roomId, status);
            if (success) {
                logger.info("管理员更新房源状态成功: roomId={}, status={}", roomId, status);
                return Result.success();
            } else {
                return Result.error("状态更新失败");
            }

        } catch (Exception e) {
            logger.error("更新房源状态失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 删除房源（管理员）
     */
    @PostMapping("/delete")
    @ResponseBody
    public Result<Void> deleteRoom(@RequestParam Long roomId, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = roomService.deleteRoom(roomId);
            if (success) {
                logger.info("管理员删除房源成功: roomId={}", roomId);
                return Result.success();
            } else {
                return Result.error("房源删除失败");
            }

        } catch (Exception e) {
            logger.error("删除房源失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取房源图片列表
     */
    @GetMapping("/{roomId}/images")
    @ResponseBody
    public Result<List<RoomImage>> getRoomImages(@PathVariable Long roomId) {
        try {
            List<RoomImage> images = roomService.getRoomImages(roomId);
            return Result.success(images);

        } catch (Exception e) {
            logger.error("获取房源图片失败: {}", e.getMessage(), e);
            return Result.error("获取图片失败");
        }
    }

    /**
     * 设置封面图片（管理员）
     */
    @PostMapping("/setCover")
    @ResponseBody
    public Result<Void> setCoverImage(@RequestParam Long roomId,
            @RequestParam Long imageId,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = roomService.setCoverImage(roomId, imageId);
            if (success) {
                return Result.success();
            } else {
                return Result.error("封面设置失败");
            }

        } catch (Exception e) {
            logger.error("设置封面图片失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 删除房源图片（管理员）
     */
    @PostMapping("/deleteImage")
    @ResponseBody
    public Result<Void> deleteRoomImage(@RequestParam Long imageId, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = roomService.deleteRoomImage(imageId);
            if (success) {
                return Result.success();
            } else {
                return Result.error("图片删除失败");
            }

        } catch (Exception e) {
            logger.error("删除房源图片失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取房源统计信息（管理员）
     */
    @GetMapping("/statistics")
    @ResponseBody
    public Result<Map<String, Object>> getRoomStatistics(HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            Map<String, Object> statistics = roomService.getRoomStatistics();
            return Result.success(statistics);

        } catch (Exception e) {
            logger.error("获取房源统计信息失败: {}", e.getMessage(), e);
            return Result.error("获取统计信息失败");
        }
    }
}
