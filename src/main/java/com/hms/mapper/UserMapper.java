package com.hms.mapper;

import com.hms.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户Mapper接口
 */
public interface UserMapper {

    /**
     * 根据ID查询用户
     * 
     * @param id 用户ID
     * @return 用户信息
     */
    User selectById(@Param("id") Long id);

    /**
     * 根据用户名查询用户
     * 
     * @param username 用户名
     * @return 用户信息
     */
    User selectByUsername(@Param("username") String username);

    /**
     * 根据邮箱查询用户
     * 
     * @param email 邮箱
     * @return 用户信息
     */
    User selectByEmail(@Param("email") String email);

    /**
     * 根据手机号查询用户
     * 
     * @param phone 手机号
     * @return 用户信息
     */
    User selectByPhone(@Param("phone") String phone);

    /**
     * 查询所有用户（分页）
     * 
     * @param userType 用户类型（可选）
     * @param status   用户状态（可选）
     * @param keyword  搜索关键词（可选）
     * @return 用户列表
     */
    List<User> selectAll(@Param("userType") Integer userType,
            @Param("status") Integer status,
            @Param("keyword") String keyword);

    /**
     * 统计用户数量
     * 
     * @param userType 用户类型（可选）
     * @param status   用户状态（可选）
     * @param keyword  搜索关键词（可选）
     * @return 用户数量
     */
    Long countUsers(@Param("userType") Integer userType,
            @Param("status") Integer status,
            @Param("keyword") String keyword);

    /**
     * 插入用户
     * 
     * @param user 用户信息
     * @return 影响行数
     */
    int insert(User user);

    /**
     * 更新用户信息
     * 
     * @param user 用户信息
     * @return 影响行数
     */
    int update(User user);

    /**
     * 更新用户状态
     * 
     * @param id     用户ID
     * @param status 新状态
     * @return 影响行数
     */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    /**
     * 更新用户密码
     * 
     * @param id       用户ID
     * @param password 新密码
     * @return 影响行数
     */
    int updatePassword(@Param("id") Long id, @Param("password") String password);

    /**
     * 逻辑删除用户
     * 
     * @param id 用户ID
     * @return 影响行数
     */
    int deleteById(@Param("id") Long id);

    /**
     * 批量逻辑删除用户
     * 
     * @param ids 用户ID列表
     * @return 影响行数
     */
    int deleteBatch(@Param("ids") List<Long> ids);

    /**
     * 检查用户名是否存在
     * 
     * @param username  用户名
     * @param excludeId 排除的用户ID（用于更新时检查）
     * @return 是否存在
     */
    boolean existsByUsername(@Param("username") String username, @Param("excludeId") Long excludeId);

    /**
     * 检查邮箱是否存在
     * 
     * @param email     邮箱
     * @param excludeId 排除的用户ID（用于更新时检查）
     * @return 是否存在
     */
    boolean existsByEmail(@Param("email") String email, @Param("excludeId") Long excludeId);

    /**
     * 检查手机号是否存在
     *
     * @param phone     手机号
     * @param excludeId 排除的用户ID（用于更新时检查）
     * @return 是否存在
     */
    boolean existsByPhone(@Param("phone") String phone, @Param("excludeId") Long excludeId);

    /**
     * 统计今日新增用户数
     *
     * @return 今日新增用户数
     */
    long countNewUsersToday();
}
