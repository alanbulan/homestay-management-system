package com.hms.util;

/**
 * 系统常量类
 */
public class Constants {
    
    /**
     * 用户类型常量
     */
    public static class UserType {
        /** 普通用户 */
        public static final int NORMAL_USER = 0;
        /** 管理员 */
        public static final int ADMIN = 1;
    }
    
    /**
     * 用户状态常量
     */
    public static class UserStatus {
        /** 禁用 */
        public static final int DISABLED = 0;
        /** 正常 */
        public static final int ACTIVE = 1;
    }
    
    /**
     * 房源状态常量
     */
    public static class RoomStatus {
        /** 下架 */
        public static final int OFFLINE = 0;
        /** 上架 */
        public static final int ONLINE = 1;
        /** 维护中 */
        public static final int MAINTENANCE = 2;
    }
    
    /**
     * 订单状态常量
     */
    public static class OrderStatus {
        /** 待确认 */
        public static final int PENDING = 0;
        /** 已确认 */
        public static final int CONFIRMED = 1;
        /** 已入住 */
        public static final int CHECKED_IN = 2;
        /** 已完成 */
        public static final int COMPLETED = 3;
        /** 已取消 */
        public static final int CANCELLED = 4;
        
        /**
         * 获取状态描述
         */
        public static String getDescription(Integer status) {
            if (status == null) return "未知";
            switch (status) {
                case PENDING: return "待确认";
                case CONFIRMED: return "已确认";
                case CHECKED_IN: return "已入住";
                case COMPLETED: return "已完成";
                case CANCELLED: return "已取消";
                default: return "未知";
            }
        }
    }
    
    /**
     * 支付状态常量
     */
    public static class PaymentStatus {
        /** 未支付 */
        public static final int UNPAID = 0;
        /** 已支付 */
        public static final int PAID = 1;
        /** 已退款 */
        public static final int REFUNDED = 2;
        
        /**
         * 获取状态描述
         */
        public static String getDescription(Integer status) {
            if (status == null) return "未知";
            switch (status) {
                case UNPAID: return "未支付";
                case PAID: return "已支付";
                case REFUNDED: return "已退款";
                default: return "未知";
            }
        }
    }
    
    /**
     * 图片类型常量
     */
    public static class ImageType {
        /** 非封面图 */
        public static final int NOT_COVER = 0;
        /** 封面图 */
        public static final int COVER = 1;
    }
    
    /**
     * 逻辑删除常量
     */
    public static class DeleteFlag {
        /** 未删除 */
        public static final int NOT_DELETED = 0;
        /** 已删除 */
        public static final int DELETED = 1;
    }
    
    /**
     * 响应状态码常量
     */
    public static class ResponseCode {
        /** 成功 */
        public static final int SUCCESS = 200;
        /** 参数错误 */
        public static final int BAD_REQUEST = 400;
        /** 未授权 */
        public static final int UNAUTHORIZED = 401;
        /** 禁止访问 */
        public static final int FORBIDDEN = 403;
        /** 资源不存在 */
        public static final int NOT_FOUND = 404;
        /** 方法不允许 */
        public static final int METHOD_NOT_ALLOWED = 405;
        /** 服务器错误 */
        public static final int INTERNAL_SERVER_ERROR = 500;
    }
    
    /**
     * 分页常量
     */
    public static class Page {
        /** 默认页码 */
        public static final int DEFAULT_PAGE_NUM = 1;
        /** 默认页面大小 */
        public static final int DEFAULT_PAGE_SIZE = 10;
        /** 最大页面大小 */
        public static final int MAX_PAGE_SIZE = 100;
    }
    
    /**
     * 缓存常量
     */
    public static class Cache {
        /** 用户缓存前缀 */
        public static final String USER_PREFIX = "user:";
        /** 房源缓存前缀 */
        public static final String ROOM_PREFIX = "room:";
        /** 订单缓存前缀 */
        public static final String ORDER_PREFIX = "order:";
        /** 验证码缓存前缀 */
        public static final String CAPTCHA_PREFIX = "captcha:";
        
        /** 默认缓存时间（秒） */
        public static final int DEFAULT_EXPIRE_TIME = 3600;
        /** 短期缓存时间（秒） */
        public static final int SHORT_EXPIRE_TIME = 300;
        /** 长期缓存时间（秒） */
        public static final int LONG_EXPIRE_TIME = 86400;
    }
    
    /**
     * 文件上传常量
     */
    public static class Upload {
        /** 最大文件大小（字节） */
        public static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
        /** 允许的图片格式 */
        public static final String[] ALLOWED_IMAGE_TYPES = {"jpg", "jpeg", "png", "gif", "bmp"};
        /** 上传路径 */
        public static final String UPLOAD_PATH = "/upload/";
        /** 图片上传路径 */
        public static final String IMAGE_UPLOAD_PATH = "/upload/images/";
    }
    
    /**
     * 正则表达式常量
     */
    public static class Regex {
        /** 手机号正则 */
        public static final String PHONE = "^1[3-9]\\d{9}$";
        /** 邮箱正则 */
        public static final String EMAIL = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        /** 用户名正则（3-20位字母数字下划线） */
        public static final String USERNAME = "^[a-zA-Z0-9_]{3,20}$";
        /** 密码正则（6-20位） */
        public static final String PASSWORD = "^.{6,20}$";
    }
    
    /**
     * 默认值常量
     */
    public static class Default {
        /** 默认头像 */
        public static final String AVATAR = "/static/images/default-avatar.png";
        /** 默认房源图片 */
        public static final String ROOM_IMAGE = "/static/images/default-room.jpg";
        /** 默认入住时间 */
        public static final String CHECK_IN_TIME = "14:00:00";
        /** 默认退房时间 */
        public static final String CHECK_OUT_TIME = "12:00:00";
    }
    
    /**
     * 系统配置常量
     */
    public static class System {
        /** 系统名称 */
        public static final String NAME = "民宿管理系统";
        /** 系统版本 */
        public static final String VERSION = "1.0.0";
        /** 系统描述 */
        public static final String DESCRIPTION = "基于SSM框架的民宿在线预订系统";
        /** 开发者 */
        public static final String DEVELOPER = "HMS Team";
    }
}
