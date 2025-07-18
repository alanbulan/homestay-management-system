package com.hms.controller;

import com.hms.config.LoginInterceptor;
import com.hms.dto.LoginDTO;
import com.hms.dto.RegisterDTO;
import com.hms.entity.User;
import com.hms.service.UserService;
import com.hms.util.Constants;
import com.hms.util.PasswordUtil;
import com.hms.vo.PageResult;
import com.hms.vo.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * 用户Controller
 */
@Controller
@RequestMapping("/user")
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    /**
     * 登录页面
     */
    @GetMapping("/login")
    public String loginPage() {
        return "user/login";
    }

    /**
     * 用户登录
     */
    @PostMapping("/login")
    @ResponseBody
    public Result<User> login(@RequestBody LoginDTO loginDTO, HttpServletRequest request) {
        try {
            logger.info("用户登录请求: {}", loginDTO.getUsername());

            User user = userService.login(loginDTO);
            if (user == null) {
                return Result.error("用户名或密码错误");
            }

            // 设置用户会话
            LoginInterceptor.setCurrentUser(request, user);

            logger.info("用户登录成功: {}", user.getUsername());
            return Result.success("登录成功", user);

        } catch (Exception e) {
            logger.error("用户登录失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 注册页面
     */
    @GetMapping("/register")
    public String registerPage() {
        return "user/register";
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    @ResponseBody
    public Result<User> register(@RequestBody RegisterDTO registerDTO, HttpServletRequest request) {
        try {
            logger.info("用户注册请求: {}", registerDTO.getUsername());

            User user = userService.register(registerDTO);

            // 注册成功后自动登录
            LoginInterceptor.setCurrentUser(request, user);

            logger.info("用户注册成功: {}", user.getUsername());
            return Result.success("注册成功", user);

        } catch (Exception e) {
            logger.error("用户注册失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 用户登出
     */
    @RequestMapping(value = "/logout", method = { RequestMethod.GET, RequestMethod.POST })
    @ResponseBody
    public Result<Void> logout(HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser != null) {
                logger.info("用户登出: {}", currentUser.getUsername());
            }

            LoginInterceptor.logout(request);
            return Result.success();

        } catch (Exception e) {
            logger.error("用户登出失败: {}", e.getMessage(), e);
            return Result.error("登出失败");
        }
    }

    /**
     * 获取当前用户信息
     */
    @GetMapping("/current")
    @ResponseBody
    public Result<User> getCurrentUser(HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            // 重新从数据库获取最新信息
            User user = userService.getUserById(currentUser.getId());
            if (user == null) {
                return Result.error("用户不存在");
            }

            return Result.success(user);

        } catch (Exception e) {
            logger.error("获取当前用户信息失败: {}", e.getMessage(), e);
            return Result.error("获取用户信息失败");
        }
    }

    /**
     * 个人中心页面
     */
    @GetMapping("/profile")
    public String profilePage(HttpServletRequest request, Model model) {
        User currentUser = LoginInterceptor.getCurrentUser(request);
        if (currentUser != null) {
            User user = userService.getUserById(currentUser.getId());
            model.addAttribute("user", user);
        }
        return "user/profile";
    }

    /**
     * 更新个人信息
     */
    @PostMapping("/profile")
    @ResponseBody
    public Result<User> updateProfile(@RequestBody User user, HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            // 只允许更新自己的信息
            user.setId(currentUser.getId());
            // 不允许通过此接口修改用户名、密码、用户类型
            user.setUsername(null);
            user.setPassword(null);
            user.setUserType(null);

            User updatedUser = userService.updateUser(user);

            // 更新会话中的用户信息
            LoginInterceptor.setCurrentUser(request, updatedUser);

            logger.info("用户更新个人信息成功: {}", updatedUser.getUsername());
            return Result.success("更新成功", updatedUser);

        } catch (Exception e) {
            logger.error("更新个人信息失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 修改密码
     */
    @PostMapping("/changePassword")
    @ResponseBody
    public Result<Void> changePassword(@RequestParam String oldPassword,
            @RequestParam String newPassword,
            HttpServletRequest request) {
        try {
            User currentUser = LoginInterceptor.getCurrentUser(request);
            if (currentUser == null) {
                return Result.unauthorized("未登录");
            }

            boolean success = userService.changePassword(currentUser.getId(), oldPassword, newPassword);
            if (success) {
                logger.info("用户修改密码成功: {}", currentUser.getUsername());
                return Result.success();
            } else {
                return Result.error("密码修改失败");
            }

        } catch (Exception e) {
            logger.error("修改密码失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 检查用户名是否存在
     */
    @GetMapping("/checkUsername")
    @ResponseBody
    public Result<Boolean> checkUsername(@RequestParam String username,
            @RequestParam(required = false) Long excludeId) {
        try {
            boolean exists = userService.isUsernameExists(username, excludeId);
            return Result.success(exists);

        } catch (Exception e) {
            logger.error("检查用户名失败: {}", e.getMessage(), e);
            return Result.error("检查失败");
        }
    }

    /**
     * 检查邮箱是否存在
     */
    @GetMapping("/checkEmail")
    @ResponseBody
    public Result<Boolean> checkEmail(@RequestParam String email,
            @RequestParam(required = false) Long excludeId) {
        try {
            boolean exists = userService.isEmailExists(email, excludeId);
            return Result.success(exists);

        } catch (Exception e) {
            logger.error("检查邮箱失败: {}", e.getMessage(), e);
            return Result.error("检查失败");
        }
    }

    /**
     * 用户管理页面（管理员）
     */
    @GetMapping("/manage")
    public String managePage(HttpServletRequest request) {
        if (!LoginInterceptor.isCurrentUserAdmin(request)) {
            return "redirect:/403";
        }
        return "admin/user-manage";
    }

    /**
     * 分页查询用户列表（管理员）
     */
    @GetMapping("/list")
    @ResponseBody
    public Result<PageResult<User>> getUserList(@RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Integer userType,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            PageResult<User> result = userService.getUserList(pageNum, pageSize, userType, status, keyword);
            return Result.success(result);

        } catch (Exception e) {
            logger.error("查询用户列表失败: {}", e.getMessage(), e);
            return Result.error("查询失败");
        }
    }

    /**
     * 更新用户状态（管理员）
     */
    @PostMapping("/updateStatus")
    @ResponseBody
    public Result<Void> updateUserStatus(@RequestParam Long userId,
            @RequestParam Integer status,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = userService.updateUserStatus(userId, status);
            if (success) {
                logger.info("管理员更新用户状态成功: userId={}, status={}", userId, status);
                return Result.success();
            } else {
                return Result.error("状态更新失败");
            }

        } catch (Exception e) {
            logger.error("更新用户状态失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 重置用户密码（管理员）
     */
    @PostMapping("/resetPassword")
    @ResponseBody
    public Result<Void> resetPassword(@RequestParam Long userId,
            @RequestParam String newPassword,
            HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = userService.resetPassword(userId, newPassword);
            if (success) {
                logger.info("管理员重置用户密码成功: userId={}", userId);
                return Result.success();
            } else {
                return Result.error("密码重置失败");
            }

        } catch (Exception e) {
            logger.error("重置用户密码失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 创建用户（管理员）
     */
    @PostMapping("/create")
    @ResponseBody
    public Result<User> createUser(@RequestBody User user, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            User createdUser = userService.createUser(user);
            logger.info("管理员创建用户成功: {}", createdUser.getUsername());
            return Result.success("用户创建成功", createdUser);

        } catch (Exception e) {
            logger.error("创建用户失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取用户详情（管理员）
     */
    @GetMapping("/{id}")
    @ResponseBody
    public Result<User> getUserById(@PathVariable Long id, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            User user = userService.getUserById(id);
            if (user == null) {
                return Result.notFound("用户不存在");
            }

            return Result.success(user);

        } catch (Exception e) {
            logger.error("获取用户详情失败: {}", e.getMessage(), e);
            return Result.error("获取用户详情失败");
        }
    }

    /**
     * 更新用户信息（管理员）
     */
    @PostMapping("/update")
    @ResponseBody
    public Result<User> updateUserByAdmin(@RequestBody User user, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            // 如果密码不为空，需要加密
            if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
                user.setPassword(PasswordUtil.encrypt(user.getPassword()));
            }

            User updatedUser = userService.updateUser(user);
            logger.info("管理员更新用户成功: {}", updatedUser.getUsername());
            return Result.success("用户更新成功", updatedUser);

        } catch (Exception e) {
            logger.error("更新用户失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 删除用户（管理员）
     */
    @DeleteMapping("/{id}")
    @ResponseBody
    public Result<String> deleteUser(@PathVariable Long id, HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            boolean success = userService.deleteUser(id);
            if (success) {
                logger.info("管理员删除用户成功: userId={}", id);
                return Result.success("用户删除成功");
            } else {
                return Result.error("用户删除失败");
            }

        } catch (Exception e) {
            logger.error("删除用户失败: {}", e.getMessage(), e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取用户统计信息（管理员）
     */
    @GetMapping("/statistics")
    @ResponseBody
    public Result<Map<String, Object>> getUserStatistics(HttpServletRequest request) {
        try {
            if (!LoginInterceptor.isCurrentUserAdmin(request)) {
                return Result.forbidden("权限不足");
            }

            Map<String, Object> statistics = userService.getUserStatistics();
            return Result.success(statistics);

        } catch (Exception e) {
            logger.error("获取用户统计信息失败: {}", e.getMessage(), e);
            return Result.error("获取统计信息失败");
        }
    }
}
