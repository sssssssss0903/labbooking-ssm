package com.labbooking.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.SysRoleMapper;
import com.labbooking.ssm.mapper.SysUserMapper;
import com.labbooking.ssm.mapper.SysUserRoleMapper;
import com.labbooking.ssm.util.AuthzUtil;
import com.labbooking.ssm.util.PasswordEncoderUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/admin/users")
public class SysAdminUserController {

    @Resource
    private SysUserMapper sysUserMapper;
    @Resource
    private SysRoleMapper sysRoleMapper;
    @Resource
    private SysUserRoleMapper sysUserRoleMapper;

    @GetMapping
    public String list(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                       HttpServletRequest request,
                       Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<SysUser> page = new PageInfo<>(sysUserMapper.listAll());
        model.addAttribute("page", page);
        return "admin_user_list";
    }

    @GetMapping("/form")
    public String form(Model model, HttpServletRequest request) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        // 加载所有可用角色
        model.addAttribute("roles", sysRoleMapper.selectAll());
        return "admin_user_form";
    }

    @PostMapping("/create")
    public String create(@RequestParam("username") String username,
                         @RequestParam("password") String password,
                         @RequestParam(value = "realName", required = false) String realName,
                         @RequestParam(value = "email", required = false) String email,
                         @RequestParam(value = "phone", required = false) String phone,
                         @RequestParam(value = "department", required = false) String department,
                         @RequestParam(value = "roles", required = false) String[] roleArray,
                         HttpServletRequest request,
                         Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        
        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            model.addAttribute("error", "用户名不能为空");
            model.addAttribute("roles", sysRoleMapper.selectAll());
            return "admin_user_form";
        }
        
        if (password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "密码不能为空");
            model.addAttribute("roles", sysRoleMapper.selectAll());
            return "admin_user_form";
        }
        
        // 检查用户名是否已存在
        SysUser existing = sysUserMapper.selectByUsername(username.trim());
        if (existing != null) {
            model.addAttribute("error", "用户名已存在");
            model.addAttribute("roles", sysRoleMapper.selectAll());
            return "admin_user_form";
        }
        
        // 创建用户
        SysUser u = new SysUser();
        u.setUsername(username.trim());
        u.setPassword(PasswordEncoderUtil.encode(password));
        u.setRealName(realName);
        u.setEmail(email);
        u.setPhone(phone);
        u.setDepartment(department);
        u.setStatus(1);
        sysUserMapper.insert(u);
        
        // 绑定角色
        if (roleArray != null && roleArray.length > 0) {
            for (String roleCode : roleArray) {
                if (roleCode != null && !roleCode.trim().isEmpty()) {
                    Long rid = sysRoleMapper.selectIdByCode(roleCode.trim());
                    if (rid != null) {
                        sysUserRoleMapper.insert(u.getId(), rid);
                    }
                }
            }
        }
        
        return "redirect:/admin/users";
    }

    @PostMapping("/{id}/status")
    public String updateStatus(@PathVariable("id") Long id,
                               @RequestParam("enable") boolean enable,
                               HttpServletRequest request,
                               Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        sysUserMapper.updateStatus(id, enable ? 1 : 0);
        return "redirect:/admin/users";
    }

    @GetMapping("/{id}/password")
    public String passwordForm(@PathVariable("id") Long id,
                               HttpServletRequest request,
                               Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        
        SysUser user = sysUserMapper.selectById(id);
        if (user == null) {
            model.addAttribute("error", "用户不存在");
            return "error";
        }
        
        model.addAttribute("user", user);
        return "admin_user_password";
    }

    @PostMapping("/{id}/password")
    public String updatePassword(@PathVariable("id") Long id,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 HttpServletRequest request,
                                 Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        
        SysUser user = sysUserMapper.selectById(id);
        if (user == null) {
            model.addAttribute("error", "用户不存在");
            return "error";
        }
        
        // 验证密码
        if (newPassword == null || newPassword.trim().isEmpty()) {
            model.addAttribute("error", "新密码不能为空");
            model.addAttribute("user", user);
            return "admin_user_password";
        }
        
        if (newPassword.length() < 6) {
            model.addAttribute("error", "密码长度至少为6位");
            model.addAttribute("user", user);
            return "admin_user_password";
        }
        
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "两次输入的密码不一致");
            model.addAttribute("user", user);
            return "admin_user_password";
        }
        
        // 更新密码
        sysUserMapper.updatePassword(id, PasswordEncoderUtil.encode(newPassword));
        
        model.addAttribute("success", "密码修改成功");
        model.addAttribute("user", user);
        return "admin_user_password";
    }
}



