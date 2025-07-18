/*
 Navicat Premium Dump SQL - Fixed Chinese Encoding

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : homestay_db

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : UTF-8

 Date: 16/07/2025 14:12:31
 Fixed: Chinese character encoding issues
*/

-- 设置字符集和编码
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET character_set_connection=utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `room_id` bigint NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `nights` int NOT NULL,
  `guests` int NOT NULL DEFAULT 1,
  `total_price` decimal(10, 2) NOT NULL,
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `special_requests` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `order_status` tinyint NOT NULL DEFAULT 0,
  `payment_status` tinyint NOT NULL DEFAULT 0,
  `payment_time` datetime NULL DEFAULT NULL,
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `cancel_time` datetime NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_room_id`(`room_id` ASC) USING BTREE,
  INDEX `idx_check_in_date`(`check_in_date` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 'HMS20250716134602618', 2, 1, '2025-07-20', '2025-07-22', 2, 1, 576.00, '张三', '13800138001', 'zhangsan@example.com', '希望房间安静一些', 1, 1, '2025-06-30 13:46:02', NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (2, 'HMS20250716134602856', 3, 2, '2025-07-25', '2025-07-28', 3, 2, 2064.00, '李四', '13800138002', 'lisi@example.com', '需要婴儿床', 1, 1, '2025-07-01 13:46:02', NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (3, 'HMS20250716134602706', 4, 3, '2025-08-01', '2025-08-03', 2, 2, 736.00, '王五', '13800138003', 'wangwu@example.com', '蜜月旅行，希望有浪漫布置', 0, 0, NULL, NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (4, 'HMS20250716134602745', 5, 4, '2025-07-18', '2025-07-20', 2, 3, 516.00, '赵六', '13800138004', 'zhaoliu@example.com', '带小孩，需要安全设施', 2, 1, '2025-06-16 13:46:02', NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (5, 'HMS20250716134602553', 2, 5, '2025-07-22', '2025-07-24', 2, 1, 656.00, '张三', '13800138001', 'zhangsan@example.com', '商务出差，需要发票', 3, 1, '2025-07-01 13:46:02', NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (6, 'HMS20250716134602335', 3, 6, '2025-08-10', '2025-08-13', 3, 4, 1374.00, '李四', '13800138002', 'lisi@example.com', '家庭旅游，希望提供旅游建议', 1, 1, '2025-06-27 13:46:02', NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (7, 'HMS20250716134602825', 4, 7, '2025-08-15', '2025-08-18', 3, 6, 2664.00, '王五', '13800138003', 'wangwu@example.com', '家庭聚会，需要烧烤设备', 0, 0, NULL, NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (8, 'HMS20250716134602173', 5, 8, '2025-07-30', '2025-08-02', 3, 2, 1194.00, '赵六', '13800138004', 'zhaoliu@example.com', '情侣旅行，希望安排浪漫晚餐', 1, 1, '2025-07-14 13:46:02', NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (9, 'HMS20250716134602375', 2, 2, '2025-09-01', '2025-09-03', 2, 2, 1376.00, '张三', '13800138001', 'zhangsan@example.com', '公司团建活动', 4, 0, NULL, '客户临时取消行程', '2025-07-14 13:46:02', '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);
INSERT INTO `orders` VALUES (10, 'HMS20250716134602672', 3, 1, '2025-08-05', '2025-08-07', 2, 1, 576.00, '李四', '13800138002', 'lisi@example.com', '出差住宿', 1, 1, '2025-07-11 13:46:02', NULL, NULL, '2025-07-16 13:46:02', '2025-07-16 13:46:02', 0);

-- ----------------------------
-- Table structure for room
-- ----------------------------
DROP TABLE IF EXISTS `room`;
CREATE TABLE `room`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `room_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price_per_night` decimal(10, 2) NOT NULL,
  `max_guests` int NOT NULL DEFAULT 1,
  `area` decimal(5, 2) NULL DEFAULT NULL,
  `floor` int NULL DEFAULT NULL,
  `facilities` json NULL,
  `check_in_time` time NOT NULL DEFAULT '14:00:00',
  `check_out_time` time NOT NULL DEFAULT '12:00:00',
  `status` tinyint NOT NULL DEFAULT 1,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_city`(`city` ASC) USING BTREE,
  INDEX `idx_room_type`(`room_type` ASC) USING BTREE,
  INDEX `idx_price`(`price_per_night` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room (Fixed Chinese Encoding)
-- ----------------------------
INSERT INTO `room` VALUES (1, '北京三里屯时尚公寓', '单人房', '位于北京三里屯核心区域的现代化单人公寓，交通便利，周边购物娱乐设施齐全。房间装修精美，配备齐全的生活设施，适合商务出行和短期居住。', '北京市朝阳区三里屯路19号', '北京', '朝阳区', 288.00, 2, 35.50, 12, '[\"WiFi\", \"空调\", \"电视\", \"冰箱\", \"洗衣机\", \"热水器\", \"独立卫浴\", \"24小时热水\"]', '14:00:00', '12:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

INSERT INTO `room` VALUES (2, '上海外滩景观豪华套房', '套房', '坐落于上海外滩附近的豪华套房，可俯瞰黄浦江美景。房间面积宽敞，装修豪华，配备高端家具和电器，为您提供五星级的住宿体验。', '上海市黄浦区中山东一路18号', '上海', '黄浦区', 688.00, 4, 85.00, 28, '[\"WiFi\", \"空调\", \"55寸智能电视\", \"迷你吧\", \"胶囊咖啡机\", \"洗衣机\", \"烘干机\", \"按摩浴缸\", \"江景阳台\", \"24小时礼宾服务\"]', '15:00:00', '12:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

INSERT INTO `room` VALUES (3, '杭州西湖边温馨双人房', '双人房', '紧邻西湖的温馨双人房，步行5分钟即可到达西湖景区。房间采用中式装修风格，古朴典雅，让您在游览西湖美景的同时享受舒适的住宿环境。', '浙江省杭州市西湖区南山路128号', '杭州', '西湖区', 368.00, 2, 42.00, 3, '[\"WiFi\", \"空调\", \"液晶电视\", \"电热水壶\", \"吹风机\", \"独立卫浴\", \"湖景窗户\", \"茶具套装\"]', '14:00:00', '11:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

INSERT INTO `room` VALUES (4, '成都宽窄巷子特色民宿', '双人房', '位于成都著名的宽窄巷子附近，充满川西民居特色的精品民宿。房间融合传统与现代元素，让您在品味成都文化的同时享受舒适住宿。', '四川省成都市青羊区宽窄巷子东街56号', '成都', '青羊区', 258.00, 3, 38.00, 2, '[\"WiFi\", \"空调\", \"智能电视\", \"茶具\", \"竹制家具\", \"独立卫浴\", \"庭院景观\", \"川剧脸谱装饰\"]', '14:00:00', '12:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

INSERT INTO `room` VALUES (5, '深圳南山科技园商务公寓', '单人房', '位于深圳南山科技园核心区域的现代商务公寓，周边高科技企业云集，交通便利。房间设计简约现代，配备高速网络，适合商务人士入住。', '广东省深圳市南山区科技园南区深南大道9988号', '深圳', '南山区', 328.00, 1, 28.00, 18, '[\"高速WiFi\", \"中央空调\", \"智能家居\", \"办公桌椅\", \"打印机\", \"咖啡机\", \"健身房\", \"商务中心\"]', '14:00:00', '12:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

INSERT INTO `room` VALUES (6, '西安大雁塔文化主题套房', '套房', '坐落在西安大雁塔附近的文化主题套房，房间装饰融入唐朝文化元素。宽敞舒适，古韵十足，让您在古都西安感受千年历史文化的魅力。', '陕西省西安市雁塔区雁塔路北段99号', '西安', '雁塔区', 458.00, 4, 68.00, 8, '[\"WiFi\", \"空调\", \"古典家具\", \"茶艺桌\", \"书法用品\", \"独立客厅\", \"观景阳台\", \"文化书籍\"]', '15:00:00', '12:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

INSERT INTO `room` VALUES (7, '青岛海边度假别墅', '套房', '面朝大海的独栋度假别墅，拥有私人海滩和花园。房间宽敞明亮，海景一览无余，配备完整的厨房和生活设施，是家庭度假的理想选择。', '山东省青岛市市南区海滨路168号', '青岛', '市南区', 888.00, 6, 120.00, 1, '[\"WiFi\", \"中央空调\", \"海景露台\", \"私人花园\", \"烧烤设备\", \"全套厨具\", \"洗衣房\", \"停车位\", \"海滩椅\"]', '16:00:00', '11:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

INSERT INTO `room` VALUES (8, '厦门鼓浪屿艺术民宿', '双人房', '位于厦门鼓浪屿的艺术主题民宿，房间充满文艺气息，装饰着当地艺术家的作品。安静舒适，是体验鼓浪屿慢生活的绝佳选择。', '福建省厦门市思明区鼓浪屿龙头路25号', '厦门', '思明区', 398.00, 2, 45.00, 2, '[\"WiFi\", \"空调\", \"艺术装饰\", \"钢琴\", \"阅读角\", \"独立卫浴\", \"海岛风情\", \"咖啡角\"]', '14:00:00', '12:00:00', 1, '2025-07-16 13:43:20', '2025-07-16 14:08:47', 0);

-- ----------------------------
-- Table structure for room_image
-- ----------------------------
DROP TABLE IF EXISTS `room_image`;
CREATE TABLE `room_image`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` bigint NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_cover` tinyint NOT NULL DEFAULT 0,
  `sort_order` int NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_room_id`(`room_id` ASC) USING BTREE,
  INDEX `idx_is_cover`(`is_cover` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_image (Fixed Chinese Encoding)
-- ----------------------------
INSERT INTO `room_image` VALUES (1, 1, 'https://img1.baidu.com/it/u=1101064358,2822229706&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '北京公寓客厅', 1, 1, '2025-07-16 13:44:54', 0);
INSERT INTO `room_image` VALUES (2, 1, 'https://img0.baidu.com/it/u=4121072634,1628094248&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=666', '北京公寓卧室', 0, 2, '2025-07-16 13:44:55', 0);
INSERT INTO `room_image` VALUES (3, 1, 'https://img2.baidu.com/it/u=2574939372,2849093611&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1067', '北京公寓厨房', 0, 3, '2025-07-16 13:44:55', 0);

INSERT INTO `room_image` VALUES (4, 2, 'https://img2.baidu.com/it/u=972709143,169548665&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '上海套房外滩景观', 1, 1, '2025-07-16 13:44:55', 0);
INSERT INTO `room_image` VALUES (5, 2, 'https://img1.baidu.com/it/u=1379951117,526639101&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '上海套房豪华客厅', 0, 2, '2025-07-16 13:44:55', 0);
INSERT INTO `room_image` VALUES (6, 2, 'https://img2.baidu.com/it/u=2506635561,4075800327&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=653', '上海套房主卧室', 0, 3, '2025-07-16 13:44:55', 0);
INSERT INTO `room_image` VALUES (7, 2, 'https://img2.baidu.com/it/u=1376411157,239571855&fm=253&fmt=auto&app=138&f=JPEG?w=751&h=500', '上海套房浴室', 0, 4, '2025-07-16 13:44:55', 0);

INSERT INTO `room_image` VALUES (8, 3, 'https://img1.baidu.com/it/u=597706195,2152522000&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=800', '杭州民宿西湖景观', 1, 1, '2025-07-16 13:44:55', 0);
INSERT INTO `room_image` VALUES (9, 3, 'https://img1.baidu.com/it/u=1136244950,4238991629&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1067', '杭州民宿中式客房', 0, 2, '2025-07-16 13:44:55', 0);
INSERT INTO `room_image` VALUES (10, 3, 'https://img2.baidu.com/it/u=2539501641,3143105067&fm=253&fmt=auto&app=138&f=JPEG?w=905&h=800', '杭州民宿茶室', 0, 3, '2025-07-16 13:44:55', 0);

INSERT INTO `room_image` VALUES (11, 4, 'https://img2.baidu.com/it/u=2816215282,4007819041&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '成都民宿川西庭院', 1, 1, '2025-07-16 13:44:55', 0);
INSERT INTO `room_image` VALUES (12, 4, 'https://img1.baidu.com/it/u=1325965250,2123840109&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=653', '成都民宿特色客房', 0, 2, '2025-07-16 13:44:56', 0);
INSERT INTO `room_image` VALUES (13, 4, 'https://img2.baidu.com/it/u=1890963495,4111709237&fm=253&fmt=auto&app=138&f=JPEG?w=686&h=500', '成都民宿竹制家具', 0, 3, '2025-07-16 13:44:56', 0);

INSERT INTO `room_image` VALUES (14, 5, 'https://img0.baidu.com/it/u=1947300028,3118855913&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '深圳公寓现代客厅', 1, 1, '2025-07-16 13:44:56', 0);
INSERT INTO `room_image` VALUES (15, 5, 'https://img2.baidu.com/it/u=3990718179,337090639&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '深圳公寓办公区域', 0, 2, '2025-07-16 13:44:56', 0);
INSERT INTO `room_image` VALUES (16, 5, 'https://img0.baidu.com/it/u=940142540,1451607430&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '深圳公寓智能设备', 0, 3, '2025-07-16 13:44:56', 0);

INSERT INTO `room_image` VALUES (17, 6, 'https://img2.baidu.com/it/u=332742588,2472332722&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=889', '西安套房唐风客厅', 1, 1, '2025-07-16 13:44:56', 0);
INSERT INTO `room_image` VALUES (18, 6, 'https://img2.baidu.com/it/u=2680018303,3292389231&fm=253&fmt=auto&app=138&f=JPEG?w=1106&h=800', '西安套房古典卧室', 0, 2, '2025-07-16 13:44:56', 0);
INSERT INTO `room_image` VALUES (19, 6, 'https://img2.baidu.com/it/u=1413370710,3783495968&fm=253&fmt=auto&app=138&f=JPEG?w=1067&h=800', '西安套房茶艺空间', 0, 3, '2025-07-16 13:44:56', 0);
INSERT INTO `room_image` VALUES (20, 6, 'https://img1.baidu.com/it/u=3733772471,1470542021&fm=253&fmt=auto&app=138&f=JPEG?w=1169&h=653', '西安套房观景阳台', 0, 4, '2025-07-16 13:44:56', 0);

INSERT INTO `room_image` VALUES (21, 7, 'https://img2.baidu.com/it/u=3166295607,1164990525&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=625', '青岛别墅海景全貌', 1, 1, '2025-07-16 13:44:57', 0);
INSERT INTO `room_image` VALUES (22, 7, 'https://img1.baidu.com/it/u=3113389534,172669040&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500', '青岛别墅私人海滩', 0, 2, '2025-07-16 13:44:57', 0);
INSERT INTO `room_image` VALUES (23, 7, 'https://img0.baidu.com/it/u=2322584807,2314393227&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1068', '青岛别墅花园露台', 0, 3, '2025-07-16 13:44:57', 0);
INSERT INTO `room_image` VALUES (24, 7, 'https://img1.baidu.com/it/u=1637029352,4126255158&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667', '青岛别墅豪华客厅', 0, 4, '2025-07-16 13:44:57', 0);
INSERT INTO `room_image` VALUES (25, 7, 'https://img0.baidu.com/it/u=2540805070,3201986129&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=663', '青岛别墅主卧海景', 0, 5, '2025-07-16 13:44:57', 0);

INSERT INTO `room_image` VALUES (26, 8, 'https://img0.baidu.com/it/u=608031986,3004009081&fm=253&fmt=auto&app=138&f=JPEG?w=515&h=500', '厦门民宿艺术客厅', 1, 1, '2025-07-16 13:44:57', 0);
INSERT INTO `room_image` VALUES (27, 8, 'https://img0.baidu.com/it/u=3583950650,1061241237&fm=253&fmt=auto&app=138&f=JPEG?w=515&h=500', '厦门民宿钢琴角落', 0, 2, '2025-07-16 13:44:57', 0);
INSERT INTO `room_image` VALUES (28, 8, 'https://img1.baidu.com/it/u=199684291,750081387&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=800', '厦门民宿阅读空间', 0, 3, '2025-07-16 13:44:57', 0);
INSERT INTO `room_image` VALUES (29, 8, 'https://img2.baidu.com/it/u=646218417,1082539699&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500', '厦门民宿海岛风情', 0, 4, '2025-07-16 13:44:57', 0);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_type` tinyint NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 1,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user (Fixed Chinese Encoding)
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 'admin@hms.com', '13800138000', '系统管理员', NULL, 1, 1, '2025-07-16 13:39:13', '2025-07-16 13:39:13', 0);
INSERT INTO `user` VALUES (2, 'zhangsan', 'e10adc3949ba59abbe56e057f20f883e', 'zhangsan@example.com', '13800138001', '张三', NULL, 0, 1, '2025-07-16 13:39:24', '2025-07-16 13:39:24', 0);
INSERT INTO `user` VALUES (3, 'lisi', 'e10adc3949ba59abbe56e057f20f883e', 'lisi@example.com', '13800138002', '李四', NULL, 0, 1, '2025-07-16 13:39:24', '2025-07-16 13:39:24', 0);
INSERT INTO `user` VALUES (4, 'wangwu', 'e10adc3949ba59abbe56e057f20f883e', 'wangwu@example.com', '13800138003', '王五', NULL, 0, 1, '2025-07-16 13:39:24', '2025-07-16 13:39:24', 0);
INSERT INTO `user` VALUES (5, 'zhaoliu', 'e10adc3949ba59abbe56e057f20f883e', 'zhaoliu@example.com', '13800138004', '赵六', NULL, 0, 1, '2025-07-16 13:39:24', '2025-07-16 13:39:24', 0);

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- 数据库字符集说明
-- ----------------------------
-- 此SQL文件已修复中文乱码问题：
-- 1. 使用 utf8mb4 字符集和 utf8mb4_unicode_ci 排序规则
-- 2. 在文件开头设置正确的字符集连接参数
-- 3. 所有中文数据已验证编码正确
-- 4. 支持完整的Unicode字符集，包括emoji等特殊字符
--
-- 使用说明：
-- 1. 确保MySQL服务器支持utf8mb4字符集
-- 2. 导入前请确认客户端连接字符集为utf8mb4
-- 3. 建议在MySQL配置文件中设置默认字符集为utf8mb4
