package com.labbooking.ssm.controller;

import com.labbooking.ssm.domain.SysParam;
import com.labbooking.ssm.service.ParamService;
import com.labbooking.ssm.util.AuthzUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/admin/params")
public class SysParamController {

    @Resource
    private ParamService paramService;

    @GetMapping
    public String list(HttpServletRequest request, Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        List<SysParam> params = paramService.listAll();
        model.addAttribute("params", params);
        model.addAttribute("defaultMinutes", paramService.getInt("booking.defaultMinutes", 60));
        model.addAttribute("maxAdvanceDays", paramService.getInt("booking.maxAdvanceDays", 14));
        return "admin_param_list";
    }

    @PostMapping("/save")
    public String save(@RequestParam("defaultMinutes") int defaultMinutes,
                       @RequestParam("maxAdvanceDays") int maxAdvanceDays,
                       HttpServletRequest request,
                       Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        paramService.set("booking.defaultMinutes", String.valueOf(defaultMinutes), "默认预约时长（分钟）");
        paramService.set("booking.maxAdvanceDays", String.valueOf(maxAdvanceDays), "最大可提前预约天数");
        return "redirect:/admin/params";
    }
}



