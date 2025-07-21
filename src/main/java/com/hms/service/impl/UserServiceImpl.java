package com.hms.service.impl;

import com.hms.dto.LoginDTO;
import com.hms.dto.RegisterDTO;
import com.hms.entity.User;
import com.hms.mapper.UserMapper;
import com.hms.service.UserService;
import com.hms.util.Constants;
import com.hms.util.PasswordUtil;
import com.hms.vo.PageResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户Service实现类
 */
@Service
@Transactional
public class UserServiceImpl implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(LoginDTO loginDTO) {
        if (loginDTO == null || !loginDTO.isValid()) {
            throw new IllegalArgumentException("登录信息不完整");
        }

        logger.info("用户登录尝试: {}", loginDTO.getUsername());

        // 根据用户名查询用户
        User user = userMapper.selectByUsername(loginDTO.getUsername());
        if (user == null) {
            logger.warn("用户不存在: {}", loginDTO.getUsername());
            return null;
        }

        // 检查用户状态
        if (!user.isActive()) {
            logger.warn("用户账户已被禁用: {}", loginDTO.getUsername());
            throw new RuntimeException("账户已被禁用，请联系管理员");
        }

        // 验证密码
        if (!verifyPassword(user.getId(), loginDTO.getPassword())) {
            logger.warn("用户密码错误: {}", loginDTO.getUsername());
            return null;
        }

        logger.info("用户登录成功: {}", loginDTO.getUsername());
        return user;
    }

    @Override
    public User register(RegisterDTO registerDTO) {
        if (registerDTO == null || !registerDTO.isValid()) {
            String error = registerDTO != null ? registerDTO.getValidationError() : "注册信息不能为空";
            throw new IllegalArgumentException(error);
        }

        logger.info("用户注册: {}", registerDTO.getUsername());

        // 检查用户名是否已存在
        if (isUsernameExists(registerDTO.getUsername(), null)) {
            throw new RuntimeException("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (isEmailExists(registerDTO.getEmail(), null)) {
            throw new RuntimeException("邮箱已被注册");
        }

        // 检查手机号是否已存在（如果提供了手机号）
        if (registerDTO.getPhone() != null && !registerDTO.getPhone().trim().isEmpty() &&
                isPhoneExists(registerDTO.getPhone(), null)) {
            throw new RuntimeException("手机号已被注册");
        }

        // 创建用户对象
        User user = new User();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(PasswordUtil.encrypt(registerDTO.getPassword()));
        user.setEmail(registerDTO.getEmail());
        user.setPhone(registerDTO.getPhone());
        user.setRealName(registerDTO.getRealName());
        user.setUserType(Constants.UserType.NORMAL_USER);
        user.setStatus(Constants.UserStatus.ACTIVE);
        user.setDeleted(Constants.DeleteFlag.NOT_DELETED);

        // 保存用户
        int result = userMapper.insert(user);
        if (result <= 0) {
            throw new RuntimeException("注册失败，请稍后重试");
        }

        logger.info("用户注册成功: {} (ID: {})", user.getUsername(), user.getId());
        return user;
    }

    @Override
    @Transactional(readOnly = true)
    public User getUserById(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        return userMapper.selectById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public User getUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        return userMapper.selectByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<User> getUserList(Integer pageNum, Integer pageSize,
            Integer userType, Integer status, String keyword) {
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

        logger.debug("查询用户列表: pageNum={}, pageSize={}, userType={}, status={}, keyword={}",
                pageNum, pageSize, userType, status, keyword);

        // 查询总数
        Long total = userMapper.countUsers(userType, status, keyword);

        // 计算分页参数
        int offset = (pageNum - 1) * pageSize;

        // 查询数据（使用分页）
        List<User> users = userMapper.selectAll(userType, status, keyword, offset, pageSize);

        // 封装分页结果
        return PageResult.of(pageNum, pageSize, total, users);
    }

    @Override
    public User createUser(User user) {
        if (user == null) {
            throw new IllegalArgumentException("用户信息不能为空");
        }

        // 基本验证
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }

        logger.info("创建用户: {}", user.getUsername());

        // 检查用户名是否已存在
        if (isUsernameExists(user.getUsername(), null)) {
            throw new RuntimeException("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty() && isEmailExists(user.getEmail(), null)) {
            throw new RuntimeException("邮箱已被使用");
        }

        // 检查手机号是否已存在
        if (user.getPhone() != null && !user.getPhone().trim().isEmpty() && isPhoneExists(user.getPhone(), null)) {
            throw new RuntimeException("手机号已被使用");
        }

        // 加密密码
        user.setPassword(PasswordUtil.encrypt(user.getPassword()));

        // 设置默认值
        if (user.getUserType() == null) {
            user.setUserType(Constants.UserType.NORMAL_USER);
        }
        if (user.getStatus() == null) {
            user.setStatus(Constants.UserStatus.ACTIVE);
        }
        user.setDeleted(Constants.DeleteFlag.NOT_DELETED);

        // 保存用户
        int result = userMapper.insert(user);
        if (result <= 0) {
            throw new RuntimeException("创建用户失败");
        }

        logger.info("用户创建成功: {} (ID: {})", user.getUsername(), user.getId());
        return user;
    }

    @Override
    public User updateUser(User user) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("用户信息不完整");
        }

        logger.info("更新用户信息: ID={}", user.getId());

        // 检查用户是否存在
        User existingUser = userMapper.selectById(user.getId());
        if (existingUser == null) {
            throw new RuntimeException("用户不存在");
        }

        // 检查邮箱是否已被其他用户使用
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty() &&
                isEmailExists(user.getEmail(), user.getId())) {
            throw new RuntimeException("邮箱已被其他用户使用");
        }

        // 检查手机号是否已被其他用户使用
        if (user.getPhone() != null && !user.getPhone().trim().isEmpty() &&
                isPhoneExists(user.getPhone(), user.getId())) {
            throw new RuntimeException("手机号已被其他用户使用");
        }

        // 更新用户信息（不更新密码和用户名）
        int result = userMapper.update(user);
        if (result <= 0) {
            throw new RuntimeException("更新用户信息失败");
        }

        logger.info("用户信息更新成功: ID={}", user.getId());
        return userMapper.selectById(user.getId());
    }

    @Override
    public boolean updateUserStatus(Long id, Integer status) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (status == null) {
            throw new IllegalArgumentException("状态不能为空");
        }

        logger.info("更新用户状态: ID={}, status={}", id, status);

        int result = userMapper.updateStatus(id, status);
        boolean success = result > 0;

        if (success) {
            logger.info("用户状态更新成功: ID={}", id);
        } else {
            logger.warn("用户状态更新失败: ID={}", id);
        }

        return success;
    }

    @Override
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("原密码不能为空");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("新密码不能为空");
        }

        logger.info("用户修改密码: ID={}", userId);

        // 验证原密码
        if (!verifyPassword(userId, oldPassword)) {
            throw new RuntimeException("原密码错误");
        }

        // 更新密码
        String encryptedPassword = PasswordUtil.encrypt(newPassword);
        int result = userMapper.updatePassword(userId, encryptedPassword);
        boolean success = result > 0;

        if (success) {
            logger.info("密码修改成功: ID={}", userId);
        } else {
            logger.warn("密码修改失败: ID={}", userId);
        }

        return success;
    }

    @Override
    public boolean resetPassword(Long userId, String newPassword) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("新密码不能为空");
        }

        logger.info("重置用户密码: ID={}", userId);

        // 加密新密码
        String encryptedPassword = PasswordUtil.encrypt(newPassword);
        int result = userMapper.updatePassword(userId, encryptedPassword);
        boolean success = result > 0;

        if (success) {
            logger.info("密码重置成功: ID={}", userId);
        } else {
            logger.warn("密码重置失败: ID={}", userId);
        }

        return success;
    }

    @Override
    public boolean deleteUser(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("用户ID不能为空");
        }

        logger.info("删除用户: ID={}", id);

        int result = userMapper.deleteById(id);
        boolean success = result > 0;

        if (success) {
            logger.info("用户删除成功: ID={}", id);
        } else {
            logger.warn("用户删除失败: ID={}", id);
        }

        return success;
    }

    @Override
    public int deleteUsers(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            throw new IllegalArgumentException("用户ID列表不能为空");
        }

        logger.info("批量删除用户: count={}", ids.size());

        int result = userMapper.deleteBatch(ids);

        logger.info("批量删除用户完成: 删除数量={}", result);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isUsernameExists(String username, Long excludeId) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return userMapper.existsByUsername(username, excludeId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailExists(String email, Long excludeId) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return userMapper.existsByEmail(email, excludeId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isPhoneExists(String phone, Long excludeId) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return userMapper.existsByPhone(phone, excludeId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean verifyPassword(Long userId, String password) {
        if (userId == null || userId <= 0 || password == null || password.trim().isEmpty()) {
            return false;
        }

        User user = userMapper.selectById(userId);
        if (user == null || user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            return false;
        }

        // 尝试新的加密方式验证
        if (PasswordUtil.verify(password, user.getPassword())) {
            return true;
        }

        // 兼容旧的MD5加密方式
        return PasswordUtil.verifyMd5(password, user.getPassword());
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getUserStatistics() {
        logger.debug("获取用户统计信息");

        Map<String, Object> statistics = new HashMap<>();

        // 总用户数
        Long totalUsers = userMapper.countUsers(null, null, null);
        statistics.put("totalUsers", totalUsers);

        // 普通用户数
        Long normalUsers = userMapper.countUsers(Constants.UserType.NORMAL_USER, null, null);
        statistics.put("normalUsers", normalUsers);

        // 管理员数
        Long adminUsers = userMapper.countUsers(Constants.UserType.ADMIN, null, null);
        statistics.put("adminUsers", adminUsers);

        // 活跃用户数
        Long activeUsers = userMapper.countUsers(null, Constants.UserStatus.ACTIVE, null);
        statistics.put("activeUsers", activeUsers);

        // 禁用用户数
        Long disabledUsers = userMapper.countUsers(null, Constants.UserStatus.DISABLED, null);
        statistics.put("disabledUsers", disabledUsers);

        return statistics;
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalUserCount() {
        logger.debug("获取用户总数");
        return userMapper.countUsers(null, null, null);
    }

    @Override
    @Transactional(readOnly = true)
    public long getActiveUserCount() {
        logger.debug("获取活跃用户数");
        return userMapper.countUsers(null, Constants.UserStatus.ACTIVE, null);
    }

    @Override
    @Transactional(readOnly = true)
    public long getNewUserCountToday() {
        logger.debug("获取今日新增用户数");
        return userMapper.countNewUsersToday();
    }
}
