package com.labbooking.ssm.controller;

import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.SysUserMapper;
import com.labbooking.ssm.util.PasswordEncoderUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
public class DevController {

    @Resource
    private SysUserMapper sysUserMapper;

    // 临时重置接口：访问 /dev/reset-admin?token=labbooking 即可将 admin 密码重置为 admin123
    @GetMapping("/dev/reset-admin")
    @ResponseBody
    public String resetAdmin(@RequestParam(name = "token", required = false) String token) {
        if (!"labbooking".equals(token)) {
            return "forbidden";
        }
        SysUser user = sysUserMapper.selectByUsername("admin");
        if (user == null) {
            user = new SysUser();
            user.setUsername("admin");
            user.setPassword(PasswordEncoderUtil.encode("admin123"));
            user.setStatus(1);
            sysUserMapper.insert(user);
        } else {
            user.setPassword(PasswordEncoderUtil.encode("admin123"));
            user.setStatus(1);
            sysUserMapper.update(user);
        }
        return "ok";
    }
}









