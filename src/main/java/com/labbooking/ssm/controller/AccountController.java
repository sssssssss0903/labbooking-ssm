package com.labbooking.ssm.controller;

import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.SysUserMapper;
import com.labbooking.ssm.util.PasswordEncoderUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/account")
public class AccountController {

    @Resource
    private SysUserMapper sysUserMapper;

    @GetMapping("/profile")
    public String profile(HttpServletRequest request, Model model) {
        SysUser user = (SysUser) request.getSession(false).getAttribute("LOGIN_USER");
        model.addAttribute("user", user);
        return "account_profile";
    }

    @GetMapping("/password")
    public String passwordPage() {
        return "account_password";
    }

    @PostMapping("/password")
    public String changePassword(@RequestParam("oldPwd") String oldPwd,
                                 @RequestParam("newPwd") String newPwd,
                                 HttpServletRequest request,
                                 Model model) {
        // 参数校验
        if (oldPwd == null || oldPwd.trim().isEmpty()) {
            model.addAttribute("error", "原密码不能为空");
            return "account_password";
        }
        
        if (newPwd == null || newPwd.trim().isEmpty()) {
            model.addAttribute("error", "新密码不能为空");
            return "account_password";
        }
        
        if (newPwd.length() < 6) {
            model.addAttribute("error", "新密码长度至少 6 位");
            return "account_password";
        }
        
        HttpSession session = request.getSession(false);
        SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
        
        if (!PasswordEncoderUtil.matches(oldPwd, user.getPassword())) {
            model.addAttribute("error", "原密码不正确");
            return "account_password";
        }
        
        String encoded = PasswordEncoderUtil.encode(newPwd);
        user.setPassword(encoded);
        sysUserMapper.update(user);
        
        // 更新会话中的用户对象
        session.setAttribute("LOGIN_USER", user);
        
        // 密码修改成功，设置成功消息并重定向到设备列表页
        session.setAttribute("passwordChangeSuccess", "密码修改成功！");
        return "redirect:/equipment";
    }
}



