package com.labbooking.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabEquipment;
import com.labbooking.ssm.domain.LabMaintenance;
import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.LabEquipmentMapper;
import com.labbooking.ssm.mapper.LabMaintenanceMapper;
import com.labbooking.ssm.util.AuthzUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/maintenance")
public class MaintenanceController {

    @Resource
    private LabMaintenanceMapper labMaintenanceMapper;
    @Resource
    private LabEquipmentMapper labEquipmentMapper;

    // 按设备查看维护记录（管理员）
    @GetMapping("/{equipmentId}")
    public String listByEquipment(@PathVariable("equipmentId") Long equipmentId,
                                  HttpServletRequest request,
                                  Model model) {
        HttpSession session = request.getSession(false);
        boolean isLabAdmin = AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN");
        boolean isSysAdmin = AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN");
        if (!isLabAdmin && !isSysAdmin) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        // 读取Flash消息
        String successMsg = (String) session.getAttribute("maintenanceSuccessMsg");
        if (successMsg != null) {
            model.addAttribute("msg", successMsg);
            session.removeAttribute("maintenanceSuccessMsg");
        }
        List<LabMaintenance> list = labMaintenanceMapper.listByEquipment(equipmentId);
        LabEquipment equipment = labEquipmentMapper.selectById(equipmentId);
        model.addAttribute("list", list);
        model.addAttribute("equipmentId", equipmentId);
        model.addAttribute("equipment", equipment);
        return "maintenance_list";
    }

    // 我的报修记录（普通用户）
    @GetMapping("/my")
    public String my(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                     @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                     HttpServletRequest request,
                     Model model) {
        HttpSession session = request.getSession(false);
        SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
        // 读取Flash消息
        String successMsg = (String) session.getAttribute("maintenanceSuccessMsg");
        String errorMsg = (String) session.getAttribute("maintenanceErrorMsg");
        if (successMsg != null) {
            model.addAttribute("msg", successMsg);
            session.removeAttribute("maintenanceSuccessMsg");
        }
        if (errorMsg != null) {
            model.addAttribute("error", errorMsg);
            session.removeAttribute("maintenanceErrorMsg");
        }
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<LabMaintenance> page = new PageInfo<>(labMaintenanceMapper.listByReportUser(user.getId()));
        model.addAttribute("page", page);
        return "maintenance_my";
    }

    // 所有维护记录（管理员）
    @GetMapping("/all")
    public String all(@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                      @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                      HttpServletRequest request,
                      Model model) {
        HttpSession session = request.getSession(false);
        boolean isLabAdmin = AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN");
        boolean isSysAdmin = AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN");
        if (!isLabAdmin && !isSysAdmin) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<LabMaintenance> page = new PageInfo<>(labMaintenanceMapper.listAll());
        model.addAttribute("page", page);
        return "maintenance_all";
    }

    @PostMapping("/report")
    public String report(@RequestParam("equipmentId") Long equipmentId,
                         @RequestParam("description") String description,
                         HttpServletRequest request,
                         Model model) {
        HttpSession session = request.getSession(false);
        SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
        if (user == null) {
            model.addAttribute("error", "请先登录");
            return "error";
        }
        
        // 参数校验
        if (equipmentId == null) {
            session.setAttribute("maintenanceErrorMsg", "设备ID不能为空");
            return "redirect:/equipment";
        }
        
        if (description == null || description.trim().isEmpty()) {
            session.setAttribute("maintenanceErrorMsg", "问题描述不能为空");
            return "redirect:/equipment/" + equipmentId;
        }
        
        if (description.trim().length() < 5) {
            session.setAttribute("maintenanceErrorMsg", "问题描述至少 5 个字符");
            return "redirect:/equipment/" + equipmentId;
        }
        
        LabMaintenance m = new LabMaintenance();
        m.setEquipmentId(equipmentId);
        m.setReportUserId(user.getId());
        m.setDescription(description.trim());
        m.setStatus("REPORTED");
        m.setCreateTime(LocalDateTime.now());
        m.setUpdateTime(LocalDateTime.now());
        labMaintenanceMapper.insert(m);
        
        // 设置设备状态为 MAINTENANCE
        LabEquipment e = labEquipmentMapper.selectById(equipmentId);
        if (e != null) {
            e.setStatus("MAINTENANCE");
            e.setUpdateTime(LocalDateTime.now());
            labEquipmentMapper.update(e);
        }
        
        session.setAttribute("maintenanceSuccessMsg", "报修已提交，设备状态已更新为维护中");
        return "redirect:/maintenance/my";
    }

    @PostMapping("/{id}/done")
    public String done(@PathVariable("id") Long id,
                       @RequestParam("equipmentId") Long equipmentId,
                       @RequestParam(value = "result", required = false) String result,
                       HttpServletRequest request,
                       Model model) {
        HttpSession session = request.getSession(false);
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        
        SysUser handler = (SysUser) session.getAttribute("LOGIN_USER");
        LocalDateTime completeTime = LocalDateTime.now();
        
        // 更新维护记录状态
        labMaintenanceMapper.updateStatus(id, "DONE", completeTime, handler.getId());
        
        // 恢复设备为 AVAILABLE
        LabEquipment e = labEquipmentMapper.selectById(equipmentId);
        if (e != null) {
            e.setStatus("AVAILABLE");
            e.setUpdateTime(completeTime);
            labEquipmentMapper.update(e);
        }
        
        session.setAttribute("maintenanceSuccessMsg", "维护已完成，设备状态已恢复为可用");
        return "redirect:/maintenance/" + equipmentId;
    }
}



