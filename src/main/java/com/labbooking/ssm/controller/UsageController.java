package com.labbooking.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabUsageLog;
import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.LabUsageLogMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/usage")
public class UsageController {

    @Resource
    private LabUsageLogMapper labUsageLogMapper;

    @GetMapping("/my")
    public String my(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                     @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                     HttpServletRequest request,
                     Model model) {
        SysUser user = (SysUser) request.getSession(false).getAttribute("LOGIN_USER");
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<LabUsageLog> page = new PageInfo<>(labUsageLogMapper.listByUserId(user.getId()));
        model.addAttribute("page", page);
        return "usage_my";
    }
}


