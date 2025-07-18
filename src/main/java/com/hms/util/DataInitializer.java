package com.hms.util;

import com.hms.entity.Room;
import com.hms.entity.RoomImage;
import com.hms.entity.Orders;
import com.hms.mapper.RoomMapper;
import com.hms.mapper.RoomImageMapper;
import com.hms.mapper.OrdersMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 数据初始化工具类
 */
@Component
public class DataInitializer {

    @Autowired
    private RoomMapper roomMapper;

    @Autowired
    private RoomImageMapper roomImageMapper;

    @Autowired
    private OrdersMapper ordersMapper;

    /**
     * 初始化房源数据
     */
    public void initRoomData() {
        List<Room> rooms = new ArrayList<>();

        // 北京三里屯时尚公寓
        Room room1 = new Room();
        room1.setId(1L);
        room1.setRoomName("北京三里屯时尚公寓");
        room1.setRoomType("Single");
        room1.setDescription("位于北京三里屯核心区域的现代化单人公寓，交通便利，周边购物娱乐设施齐全。房间装修精美，配备齐全的生活设施，适合商务出行和短期居住。");
        room1.setAddress("北京市朝阳区三里屯路19号");
        room1.setCity("Beijing");
        room1.setDistrict("朝阳区");
        room1.setPricePerNight(new BigDecimal("288.00"));
        room1.setMaxGuests(2);
        room1.setArea(new BigDecimal("35.5"));
        room1.setFloor(12);
        room1.setFacilities("[\"WiFi\", \"空调\", \"电视\", \"冰箱\", \"洗衣机\", \"热水器\", \"独立卫浴\", \"24小时热水\"]");
        room1.setCheckInTime(LocalTime.of(14, 0));
        room1.setCheckOutTime(LocalTime.of(12, 0));
        room1.setStatus(Constants.RoomStatus.ONLINE);
        room1.setCreateTime(LocalDateTime.now());
        room1.setUpdateTime(LocalDateTime.now());
        room1.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room1);

        // 上海外滩景观豪华套房
        Room room2 = new Room();
        room2.setId(2L);
        room2.setRoomName("上海外滩景观豪华套房");
        room2.setRoomType("Suite");
        room2.setDescription("坐落于上海外滩附近的豪华套房，可俯瞰黄浦江美景。房间面积宽敞，装修豪华，配备高端家具和电器，为您提供五星级的住宿体验。");
        room2.setAddress("上海市黄浦区中山东一路18号");
        room2.setCity("Shanghai");
        room2.setDistrict("黄浦区");
        room2.setPricePerNight(new BigDecimal("688.00"));
        room2.setMaxGuests(4);
        room2.setArea(new BigDecimal("85.0"));
        room2.setFloor(28);
        room2.setFacilities(
                "[\"WiFi\", \"空调\", \"55寸智能电视\", \"迷你吧\", \"胶囊咖啡机\", \"洗衣机\", \"烘干机\", \"按摩浴缸\", \"江景阳台\", \"24小时礼宾服务\"]");
        room2.setCheckInTime(LocalTime.of(15, 0));
        room2.setCheckOutTime(LocalTime.of(12, 0));
        room2.setStatus(Constants.RoomStatus.ONLINE);
        room2.setCreateTime(LocalDateTime.now());
        room2.setUpdateTime(LocalDateTime.now());
        room2.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room2);

        // 杭州西湖边温馨双人房
        Room room3 = new Room();
        room3.setId(3L);
        room3.setRoomName("杭州西湖边温馨双人房");
        room3.setRoomType("Double");
        room3.setDescription("紧邻西湖的温馨双人房，步行5分钟即可到达西湖景区。房间采用中式装修风格，古朴典雅，让您在游览西湖美景的同时享受舒适的住宿环境。");
        room3.setAddress("浙江省杭州市西湖区南山路128号");
        room3.setCity("Hangzhou");
        room3.setDistrict("西湖区");
        room3.setPricePerNight(new BigDecimal("368.00"));
        room3.setMaxGuests(2);
        room3.setArea(new BigDecimal("42.0"));
        room3.setFloor(3);
        room3.setFacilities("[\"WiFi\", \"空调\", \"液晶电视\", \"电热水壶\", \"吹风机\", \"独立卫浴\", \"湖景窗户\", \"茶具套装\"]");
        room3.setCheckInTime(LocalTime.of(14, 0));
        room3.setCheckOutTime(LocalTime.of(11, 0));
        room3.setStatus(Constants.RoomStatus.ONLINE);
        room3.setCreateTime(LocalDateTime.now());
        room3.setUpdateTime(LocalDateTime.now());
        room3.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room3);

        // 成都宽窄巷子特色民宿
        Room room4 = new Room();
        room4.setId(4L);
        room4.setRoomName("成都宽窄巷子特色民宿");
        room4.setRoomType("Double");
        room4.setDescription("位于成都著名的宽窄巷子附近，充满川西民居特色的精品民宿。房间融合传统与现代元素，让您在品味成都文化的同时享受舒适住宿。");
        room4.setAddress("四川省成都市青羊区宽窄巷子东街56号");
        room4.setCity("Chengdu");
        room4.setDistrict("青羊区");
        room4.setPricePerNight(new BigDecimal("258.00"));
        room4.setMaxGuests(3);
        room4.setArea(new BigDecimal("38.0"));
        room4.setFloor(2);
        room4.setFacilities("[\"WiFi\", \"空调\", \"智能电视\", \"茶具\", \"竹制家具\", \"独立卫浴\", \"庭院景观\", \"川剧脸谱装饰\"]");
        room4.setCheckInTime(LocalTime.of(14, 0));
        room4.setCheckOutTime(LocalTime.of(12, 0));
        room4.setStatus(Constants.RoomStatus.ONLINE);
        room4.setCreateTime(LocalDateTime.now());
        room4.setUpdateTime(LocalDateTime.now());
        room4.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room4);

        // 深圳南山科技园商务公寓
        Room room5 = new Room();
        room5.setId(5L);
        room5.setRoomName("深圳南山科技园商务公寓");
        room5.setRoomType("Single");
        room5.setDescription("位于深圳南山科技园核心区域的现代商务公寓，周边高科技企业云集，交通便利。房间设计简约现代，配备高速网络，适合商务人士入住。");
        room5.setAddress("广东省深圳市南山区科技园南区深南大道9988号");
        room5.setCity("Shenzhen");
        room5.setDistrict("南山区");
        room5.setPricePerNight(new BigDecimal("328.00"));
        room5.setMaxGuests(1);
        room5.setArea(new BigDecimal("28.0"));
        room5.setFloor(18);
        room5.setFacilities("[\"高速WiFi\", \"中央空调\", \"智能家居\", \"办公桌椅\", \"打印机\", \"咖啡机\", \"健身房\", \"商务中心\"]");
        room5.setCheckInTime(LocalTime.of(14, 0));
        room5.setCheckOutTime(LocalTime.of(12, 0));
        room5.setStatus(Constants.RoomStatus.ONLINE);
        room5.setCreateTime(LocalDateTime.now());
        room5.setUpdateTime(LocalDateTime.now());
        room5.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room5);

        // 西安大雁塔文化主题套房
        Room room6 = new Room();
        room6.setId(6L);
        room6.setRoomName("西安大雁塔文化主题套房");
        room6.setRoomType("Suite");
        room6.setDescription("坐落在西安大雁塔附近的文化主题套房，房间装饰融入唐朝文化元素。宽敞舒适，古韵十足，让您在古都西安感受千年历史文化的魅力。");
        room6.setAddress("陕西省西安市雁塔区雁塔路北段99号");
        room6.setCity("Xian");
        room6.setDistrict("雁塔区");
        room6.setPricePerNight(new BigDecimal("458.00"));
        room6.setMaxGuests(4);
        room6.setArea(new BigDecimal("68.0"));
        room6.setFloor(8);
        room6.setFacilities("[\"WiFi\", \"空调\", \"古典家具\", \"茶艺桌\", \"书法用品\", \"独立客厅\", \"观景阳台\", \"文化书籍\"]");
        room6.setCheckInTime(LocalTime.of(15, 0));
        room6.setCheckOutTime(LocalTime.of(12, 0));
        room6.setStatus(Constants.RoomStatus.ONLINE);
        room6.setCreateTime(LocalDateTime.now());
        room6.setUpdateTime(LocalDateTime.now());
        room6.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room6);

        // 青岛海边度假别墅
        Room room7 = new Room();
        room7.setId(7L);
        room7.setRoomName("青岛海边度假别墅");
        room7.setRoomType("Suite");
        room7.setDescription("面朝大海的独栋度假别墅，拥有私人海滩和花园。房间宽敞明亮，海景一览无余，配备完整的厨房和生活设施，是家庭度假的理想选择。");
        room7.setAddress("山东省青岛市市南区海滨路168号");
        room7.setCity("Qingdao");
        room7.setDistrict("市南区");
        room7.setPricePerNight(new BigDecimal("888.00"));
        room7.setMaxGuests(6);
        room7.setArea(new BigDecimal("120.0"));
        room7.setFloor(1);
        room7.setFacilities("[\"WiFi\", \"中央空调\", \"海景露台\", \"私人花园\", \"烧烤设备\", \"全套厨具\", \"洗衣房\", \"停车位\", \"海滩椅\"]");
        room7.setCheckInTime(LocalTime.of(16, 0));
        room7.setCheckOutTime(LocalTime.of(11, 0));
        room7.setStatus(Constants.RoomStatus.ONLINE);
        room7.setCreateTime(LocalDateTime.now());
        room7.setUpdateTime(LocalDateTime.now());
        room7.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room7);

        // 厦门鼓浪屿艺术民宿
        Room room8 = new Room();
        room8.setId(8L);
        room8.setRoomName("厦门鼓浪屿艺术民宿");
        room8.setRoomType("Double");
        room8.setDescription("位于厦门鼓浪屿的艺术主题民宿，房间充满文艺气息，装饰着当地艺术家的作品。安静舒适，是体验鼓浪屿慢生活的绝佳选择。");
        room8.setAddress("福建省厦门市思明区鼓浪屿龙头路25号");
        room8.setCity("Xiamen");
        room8.setDistrict("思明区");
        room8.setPricePerNight(new BigDecimal("398.00"));
        room8.setMaxGuests(2);
        room8.setArea(new BigDecimal("45.0"));
        room8.setFloor(2);
        room8.setFacilities("[\"WiFi\", \"空调\", \"艺术装饰\", \"钢琴\", \"阅读角\", \"独立卫浴\", \"海岛风情\", \"咖啡角\"]");
        room8.setCheckInTime(LocalTime.of(14, 0));
        room8.setCheckOutTime(LocalTime.of(12, 0));
        room8.setStatus(Constants.RoomStatus.ONLINE);
        room8.setCreateTime(LocalDateTime.now());
        room8.setUpdateTime(LocalDateTime.now());
        room8.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        rooms.add(room8);

        // 插入房源数据
        for (Room room : rooms) {
            roomMapper.insert(room);
        }
    }

    /**
     * 初始化房源图片数据
     */
    public void initRoomImageData() {
        List<RoomImage> images = new ArrayList<>();

        // 北京三里屯时尚公寓图片
        images.add(createRoomImage(1L, 1L, "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267", "北京公寓客厅",
                true, 1));
        images.add(createRoomImage(2L, 1L, "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2", "北京公寓卧室", false,
                2));
        images.add(createRoomImage(3L, 1L, "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136", "北京公寓厨房", false,
                3));

        // 上海外滩景观豪华套房图片
        images.add(createRoomImage(4L, 2L, "https://images.unsplash.com/photo-1571896349842-33c89424de2d", "上海套房外滩景观",
                true, 1));
        images.add(createRoomImage(5L, 2L, "https://images.unsplash.com/photo-1586023492125-27b2c045efd7", "上海套房豪华客厅",
                false, 2));
        images.add(createRoomImage(6L, 2L, "https://images.unsplash.com/photo-1560448075-bb485b067938", "上海套房主卧室",
                false, 3));
        images.add(createRoomImage(7L, 2L, "https://images.unsplash.com/photo-1552321554-5fefe8c9ef14", "上海套房浴室", false,
                4));

        // 杭州西湖边温馨双人房图片
        images.add(createRoomImage(8L, 3L, "https://images.unsplash.com/photo-1578662996442-48f60103fc96", "杭州民宿西湖景观",
                true, 1));
        images.add(createRoomImage(9L, 3L, "https://images.unsplash.com/photo-1586023492125-27b2c045efd7", "杭州民宿中式客房",
                false, 2));
        images.add(createRoomImage(10L, 3L, "https://images.unsplash.com/photo-1571896349842-33c89424de2d", "杭州民宿茶室",
                false, 3));

        // 成都宽窄巷子特色民宿图片
        images.add(createRoomImage(11L, 4L, "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2", "成都民宿川西庭院",
                true, 1));
        images.add(createRoomImage(12L, 4L, "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267", "成都民宿特色客房",
                false, 2));
        images.add(createRoomImage(13L, 4L, "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136", "成都民宿竹制家具",
                false, 3));

        // 插入图片数据
        for (RoomImage image : images) {
            roomImageMapper.insert(image);
        }
    }

    private RoomImage createRoomImage(Long id, Long roomId, String imageUrl, String imageName, boolean isCover,
            int sortOrder) {
        RoomImage image = new RoomImage();
        image.setId(id);
        image.setRoomId(roomId);
        image.setImageUrl(imageUrl);
        image.setImageName(imageName);
        image.setIsCover(isCover ? 1 : 0);
        image.setSortOrder(sortOrder);
        image.setCreateTime(LocalDateTime.now());
        image.setDeleted(Constants.DeleteFlag.NOT_DELETED);
        return image;
    }
}
