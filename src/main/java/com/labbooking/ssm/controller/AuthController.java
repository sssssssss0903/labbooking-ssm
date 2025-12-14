package com.labbooking.ssm.controller;

import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.service.AuthService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class AuthController {
    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    @Resource
    private AuthService authService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam("username") String username,
                          @RequestParam("password") String password,
                          HttpServletRequest request,
                          Model model) {
        SysUser user = authService.login(username, password);
        if (user == null) {
            model.addAttribute("error", "用户名或密码错误，或账号已禁用");
            return "login";
        }
        
        HttpSession session = request.getSession(true);
        session.setAttribute("LOGIN_USER", user);
        session.setAttribute("LOGIN_ROLES", user.getRoleCodes());
        
        // 根据角色跳转到不同页面
        boolean isAdmin = user.getRoleCodes() != null && 
            (user.getRoleCodes().contains("ROLE_LAB_ADMIN") || user.getRoleCodes().contains("ROLE_SYS_ADMIN"));
        
        if (isAdmin) {
            // 管理员跳转到管理后台
            return "redirect:/admin/equipment";
        } else {
            // 学生跳转到设备列表
        return "redirect:/equipment";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String doRegister(@RequestParam("username") String username,
                            @RequestParam("password") String password,
                            @RequestParam("passwordConfirm") String passwordConfirm,
                            @RequestParam(value = "realName", required = false) String realName,
                            @RequestParam(value = "email", required = false) String email,
                            @RequestParam(value = "phone", required = false) String phone,
                            @RequestParam(value = "department", required = false) String department,
                            Model model) {
        // 参数校验
        if (username == null || username.trim().isEmpty()) {
            model.addAttribute("error", "用户名不能为空");
            return "register";
        }
        username = username.trim();
        
        // 用户名长度检查
        if (username.length() < 4 || username.length() > 20) {
            model.addAttribute("error", "用户名长度必须在 4-20 个字符之间");
            return "register";
        }
        
        // 密码检查
        if (password == null || password.length() < 6) {
            model.addAttribute("error", "密码长度至少 6 位");
            return "register";
        }
        
        // 确认密码检查
        if (!password.equals(passwordConfirm)) {
            model.addAttribute("error", "两次输入的密码不一致");
            return "register";
        }
        
        // 调用 Service 创建用户
        try {
            authService.register(username, password, realName, email, phone, department);
            model.addAttribute("msg", "注册成功，请登录");
            return "login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        } catch (Exception e) {
            log.error("注册失败", e);
            model.addAttribute("error", "注册失败：" + e.getMessage());
            return "register";
        }
    }
}


