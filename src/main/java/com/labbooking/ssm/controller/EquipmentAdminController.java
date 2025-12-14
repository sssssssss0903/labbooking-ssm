package com.labbooking.ssm.controller;

import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabEquipment;
import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.service.EquipmentService;
import com.labbooking.ssm.util.AuthzUtil;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller
@RequestMapping("/admin/equipment")
public class EquipmentAdminController {

    @Resource
    private EquipmentService equipmentService;
    @Value("${upload.baseDir}")
    private String uploadBaseDir;

    @GetMapping
    public String list(@RequestParam(value = "q", required = false) String q,
                       @RequestParam(value = "type", required = false) String type,
                       @RequestParam(value = "labId", required = false) Long labId,
                       @RequestParam(value = "status", required = false) String status,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                       HttpServletRequest request,
                       Model model) {
        if (!AuthzUtil.hasRole(request.getSession(false), "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        boolean isSysAdmin = AuthzUtil.hasRole(request.getSession(false), "ROLE_SYS_ADMIN");
        if (isSysAdmin) {
            PageInfo<LabEquipment> page = equipmentService.list(q, type, labId, status, pageNum, pageSize);
            model.addAttribute("page", page);
        } else {
            // 仅显示自己负责实验室设备
            com.github.pagehelper.PageHelper.startPage(pageNum, pageSize);
            SysUser user = (SysUser) request.getSession(false).getAttribute("LOGIN_USER");
            java.util.List<LabEquipment> list = ((com.labbooking.ssm.mapper.LabEquipmentMapper)
                    org.springframework.web.context.support.WebApplicationContextUtils
                            .getRequiredWebApplicationContext(request.getServletContext())
                            .getBean("labEquipmentMapper"))
                    .adminQueryList(q, type, labId, status, user.getId());
            PageInfo<LabEquipment> page = new PageInfo<>(list);
            model.addAttribute("page", page);
        }
        model.addAttribute("q", q);
        model.addAttribute("type", type);
        model.addAttribute("labId", labId);
        model.addAttribute("status", status);
        return "equipment_admin_list";
        }

    @GetMapping("/form")
    public String form(@RequestParam(value = "id", required = false) Long id,
                       HttpServletRequest request,
                       Model model) {
        HttpSession session = request.getSession(false);
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限访问");
            return "error";
        }
        
        // 查询设备信息
        LabEquipment equipment = id == null ? new LabEquipment() : equipmentService.getById(id);
        model.addAttribute("equipment", equipment);
        
        // 查询可用的实验室列表
        com.labbooking.ssm.mapper.LabInfoMapper labInfoMapper = (com.labbooking.ssm.mapper.LabInfoMapper)
                org.springframework.web.context.support.WebApplicationContextUtils
                        .getRequiredWebApplicationContext(request.getServletContext())
                        .getBean("labInfoMapper");
        
        boolean isSysAdmin = AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN");
        java.util.List<com.labbooking.ssm.domain.LabInfo> labs;
        
        if (isSysAdmin) {
            // 系统管理员：显示所有实验室
            labs = labInfoMapper.selectAll();
        } else {
            // 实验室管理员：仅显示自己负责的实验室
            SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
            labs = labInfoMapper.listByManagerId(user.getId());
        }
        
        model.addAttribute("labs", labs);
        
        return "equipment_admin_form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute LabEquipment equipment,
                       @RequestParam(value = "image", required = false) MultipartFile image,
                       HttpServletRequest request,
                       Model model) throws IOException {
        HttpSession session = request.getSession(false);
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        if (image != null && !image.isEmpty()) {
            String baseDir = uploadBaseDir != null ? uploadBaseDir : "uploads";
            File dir = new File(baseDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String ext = FilenameUtils.getExtension(image.getOriginalFilename());
            String contentType = image.getContentType() == null ? "" : image.getContentType().toLowerCase();
            String lowerExt = ext == null ? "" : ext.toLowerCase();
            java.util.Set<String> white = new java.util.HashSet<>(java.util.Arrays.asList("jpg","jpeg","png","gif"));
            if (!white.contains(lowerExt) || !contentType.startsWith("image/")) {
                model.addAttribute("error", "仅支持图片扩展名：jpg/jpeg/png/gif");
                model.addAttribute("equipment", equipment);
                return "equipment_admin_form";
            }
            String filename = UUID.randomUUID().toString().replace("-", "") + (ext != null && !ext.isEmpty() ? ("." + ext) : "");
            File dest = new File(dir, filename);
            image.transferTo(dest);
            // 保存为可通过 /uploads/ 访问的相对路径
            String webPath = "/uploads/" + filename;
            equipment.setImagePath(webPath);
        }
        // Lab Admin 权限校验：仅可操作自己实验室
        boolean isSysAdmin = AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN");
        if (!isSysAdmin) {
            Long uid = ((SysUser) session.getAttribute("LOGIN_USER")).getId();
            com.labbooking.ssm.mapper.LabInfoMapper labInfoMapper = (com.labbooking.ssm.mapper.LabInfoMapper)
                    org.springframework.web.context.support.WebApplicationContextUtils
                            .getRequiredWebApplicationContext(request.getServletContext())
                            .getBean("labInfoMapper");
            java.util.List<com.labbooking.ssm.domain.LabInfo> labs = labInfoMapper.listByManagerId(uid);
            java.util.Set<Long> allowedLabIds = new java.util.HashSet<>();
            for (com.labbooking.ssm.domain.LabInfo l : labs) allowedLabIds.add(l.getId());
            if (equipment.getId() != null) {
                LabEquipment exist = equipmentService.getById(equipment.getId());
                if (exist == null || !allowedLabIds.contains(exist.getLabId())) {
                    model.addAttribute("error", "无权限编辑该设备（非所属实验室）");
                    return "error";
                }
                if (equipment.getLabId() != null && !allowedLabIds.contains(equipment.getLabId())) {
                    model.addAttribute("error", "不可将设备转移到非所属实验室");
                    model.addAttribute("equipment", equipment);
                    return "equipment_admin_form";
                }
            } else {
                if (equipment.getLabId() == null || !allowedLabIds.contains(equipment.getLabId())) {
                    model.addAttribute("error", "仅可创建自己负责实验室的设备");
                    model.addAttribute("equipment", equipment);
                    return "equipment_admin_form";
                }
            }
        }
        if (equipment.getId() == null) {
            // 默认状态
            if (equipment.getStatus() == null) {
                equipment.setStatus("AVAILABLE");
            }
            // 使用 Service 的 Mapper：这里直接调用 Mapper 的能力通过 EquipmentService 不暴露，简化：复用 update/insert由 Service 提供
            // 直接通过 Service.getById判断新增/更新，由于当前 Service 未暴露save，这里临时通过 Mapper 方法（可重构）
            com.labbooking.ssm.mapper.LabEquipmentMapper mapper = (com.labbooking.ssm.mapper.LabEquipmentMapper)
                    org.springframework.web.context.support.WebApplicationContextUtils
                            .getRequiredWebApplicationContext(request.getServletContext())
                            .getBean("labEquipmentMapper");
            mapper.insert(equipment);
        } else {
            com.labbooking.ssm.mapper.LabEquipmentMapper mapper = (com.labbooking.ssm.mapper.LabEquipmentMapper)
                    org.springframework.web.context.support.WebApplicationContextUtils
                            .getRequiredWebApplicationContext(request.getServletContext())
                            .getBean("labEquipmentMapper");
            mapper.update(equipment);
        }
        return "redirect:/admin/equipment";
    }
    
    @PostMapping("/delete")
    public String delete(@RequestParam("id") Long id,
                        HttpServletRequest request,
                        Model model) {
        HttpSession session = request.getSession(false);
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        
        try {
            equipmentService.delete(id);
            session.setAttribute("equipmentSuccessMsg", "设备已删除");
        } catch (IllegalStateException e) {
            session.setAttribute("equipmentErrorMsg", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("equipmentErrorMsg", "删除失败：" + e.getMessage());
        }
        
        return "redirect:/admin/equipment";
    }
    
    @PostMapping("/status")
    public String updateStatus(@RequestParam("id") Long id,
                              @RequestParam("status") String status,
                              HttpServletRequest request,
                              Model model) {
        HttpSession session = request.getSession(false);
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        
        try {
            equipmentService.updateStatus(id, status);
            session.setAttribute("equipmentSuccessMsg", "设备状态已更新");
        } catch (Exception e) {
            session.setAttribute("equipmentErrorMsg", "更新失败：" + e.getMessage());
        }
        
        return "redirect:/admin/equipment";
    }
}



