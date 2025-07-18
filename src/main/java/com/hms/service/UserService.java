package com.hms.service;

import com.hms.dto.LoginDTO;
import com.hms.dto.RegisterDTO;
import com.hms.entity.User;
import com.hms.vo.PageResult;

import java.util.List;

/**
 * 用户Service接口
 */
public interface UserService {

    /**
     * 用户登录
     * 
     * @param loginDTO 登录信息
     * @return 用户信息（登录成功）或null（登录失败）
     */
    User login(LoginDTO loginDTO);

    /**
     * 用户注册
     * 
     * @param registerDTO 注册信息
     * @return 注册成功的用户信息
     * @throws RuntimeException 注册失败时抛出异常
     */
    User register(RegisterDTO registerDTO);

    /**
     * 根据ID查询用户
     * 
     * @param id 用户ID
     * @return 用户信息
     */
    User getUserById(Long id);

    /**
     * 根据用户名查询用户
     * 
     * @param username 用户名
     * @return 用户信息
     */
    User getUserByUsername(String username);

    /**
     * 分页查询用户列表
     * 
     * @param pageNum  页码
     * @param pageSize 页面大小
     * @param userType 用户类型（可选）
     * @param status   用户状态（可选）
     * @param keyword  搜索关键词（可选）
     * @return 分页结果
     */
    PageResult<User> getUserList(Integer pageNum, Integer pageSize,
            Integer userType, Integer status, String keyword);

    /**
     * 创建用户
     * 
     * @param user 用户信息
     * @return 创建成功的用户信息
     */
    User createUser(User user);

    /**
     * 更新用户信息
     * 
     * @param user 用户信息
     * @return 更新后的用户信息
     */
    User updateUser(User user);

    /**
     * 更新用户状态
     * 
     * @param id     用户ID
     * @param status 新状态
     * @return 是否更新成功
     */
    boolean updateUserStatus(Long id, Integer status);

    /**
     * 修改密码
     * 
     * @param userId      用户ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @return 是否修改成功
     */
    boolean changePassword(Long userId, String oldPassword, String newPassword);

    /**
     * 重置密码（管理员操作）
     * 
     * @param userId      用户ID
     * @param newPassword 新密码
     * @return 是否重置成功
     */
    boolean resetPassword(Long userId, String newPassword);

    /**
     * 删除用户
     * 
     * @param id 用户ID
     * @return 是否删除成功
     */
    boolean deleteUser(Long id);

    /**
     * 批量删除用户
     * 
     * @param ids 用户ID列表
     * @return 删除成功的数量
     */
    int deleteUsers(List<Long> ids);

    /**
     * 检查用户名是否存在
     * 
     * @param username  用户名
     * @param excludeId 排除的用户ID（用于更新时检查）
     * @return 是否存在
     */
    boolean isUsernameExists(String username, Long excludeId);

    /**
     * 检查邮箱是否存在
     * 
     * @param email     邮箱
     * @param excludeId 排除的用户ID（用于更新时检查）
     * @return 是否存在
     */
    boolean isEmailExists(String email, Long excludeId);

    /**
     * 检查手机号是否存在
     * 
     * @param phone     手机号
     * @param excludeId 排除的用户ID（用于更新时检查）
     * @return 是否存在
     */
    boolean isPhoneExists(String phone, Long excludeId);

    /**
     * 验证用户密码
     * 
     * @param userId   用户ID
     * @param password 密码
     * @return 是否验证成功
     */
    boolean verifyPassword(Long userId, String password);

    /**
     * 获取用户统计信息
     *
     * @return 统计信息Map
     */
    java.util.Map<String, Object> getUserStatistics();

    /**
     * 获取用户总数
     *
     * @return 用户总数
     */
    long getTotalUserCount();

    /**
     * 获取活跃用户数
     *
     * @return 活跃用户数
     */
    long getActiveUserCount();

    /**
     * 获取今日新增用户数
     *
     * @return 今日新增用户数
     */
    long getNewUserCountToday();
}
