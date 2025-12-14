package com.labbooking.ssm.controller;

import com.labbooking.ssm.domain.LabInfo;
import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.LabInfoMapper;
import com.labbooking.ssm.mapper.SysUserMapper;
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
@RequestMapping("/admin/labs")
public class SysAdminLabController {

    @Resource
    private LabInfoMapper labInfoMapper;
    @Resource
    private SysUserMapper sysUserMapper;

    @GetMapping
    public String list(HttpServletRequest request, Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        List<LabInfo> labs = labInfoMapper.selectAll();
        model.addAttribute("labs", labs);
        return "admin_lab_list";
    }

    @GetMapping("/form")
    public String form(@RequestParam(value = "id", required = false) Long id,
                       HttpServletRequest request,
                       Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        LabInfo lab = id == null ? new LabInfo() : labInfoMapper.selectById(id);
        model.addAttribute("lab", lab);

        // 获取所有管理员用户
        List<SysUser> adminUsers = sysUserMapper.selectByRole("ROLE_LAB_ADMIN");
        adminUsers.addAll(sysUserMapper.selectByRole("ROLE_SYS_ADMIN"));
        model.addAttribute("adminUsers", adminUsers);

        return "admin_lab_form";
    }

    @PostMapping("/save")
    public String save(LabInfo lab,
                       HttpServletRequest request,
                       Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        if (lab.getId() == null) {
            if (lab.getStatus() == null) lab.setStatus("NORMAL");
            labInfoMapper.insert(lab);
        } else {
            labInfoMapper.update(lab);
        }
        return "redirect:/admin/labs";
    }
}



