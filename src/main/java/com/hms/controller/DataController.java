package com.hms.controller;

import com.hms.util.DataInitializer;
import com.hms.vo.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 数据初始化控制器
 */
@Controller
@RequestMapping("/data")
public class DataController {
    
    private static final Logger logger = LoggerFactory.getLogger(DataController.class);
    
    @Autowired
    private DataInitializer dataInitializer;
    
    /**
     * 初始化房源数据
     */
    @GetMapping("/init-rooms")
    @ResponseBody
    public Result<String> initRooms() {
        try {
            logger.info("开始初始化房源数据");
            dataInitializer.initRoomData();
            logger.info("房源数据初始化完成");
            return Result.success("房源数据初始化成功");
        } catch (Exception e) {
            logger.error("房源数据初始化失败: {}", e.getMessage(), e);
            return Result.error("房源数据初始化失败: " + e.getMessage());
        }
    }
    
    /**
     * 初始化房源图片数据
     */
    @GetMapping("/init-images")
    @ResponseBody
    public Result<String> initImages() {
        try {
            logger.info("开始初始化房源图片数据");
            dataInitializer.initRoomImageData();
            logger.info("房源图片数据初始化完成");
            return Result.success("房源图片数据初始化成功");
        } catch (Exception e) {
            logger.error("房源图片数据初始化失败: {}", e.getMessage(), e);
            return Result.error("房源图片数据初始化失败: " + e.getMessage());
        }
    }
    
    /**
     * 初始化所有数据
     */
    @GetMapping("/init-all")
    @ResponseBody
    public Result<String> initAll() {
        try {
            logger.info("开始初始化所有数据");
            
            // 初始化房源数据
            dataInitializer.initRoomData();
            logger.info("房源数据初始化完成");
            
            // 初始化房源图片数据
            dataInitializer.initRoomImageData();
            logger.info("房源图片数据初始化完成");
            
            logger.info("所有数据初始化完成");
            return Result.success("所有数据初始化成功");
        } catch (Exception e) {
            logger.error("数据初始化失败: {}", e.getMessage(), e);
            return Result.error("数据初始化失败: " + e.getMessage());
        }
    }
}
