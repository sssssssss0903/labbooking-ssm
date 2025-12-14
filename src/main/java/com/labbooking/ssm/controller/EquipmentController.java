package com.labbooking.ssm.controller;

import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabEquipment;
import com.labbooking.ssm.service.EquipmentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;

@Controller
public class EquipmentController {

    @Resource
    private EquipmentService equipmentService;

    @RequestMapping("/")
    public String index() {
        return "redirect:/equipment";
    }

    @GetMapping("/equipment")
    public String list(@RequestParam(value = "q", required = false) String q,
                       @RequestParam(value = "type", required = false) String type,
                       @RequestParam(value = "labId", required = false) Long labId,
                       @RequestParam(value = "status", required = false) String status,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                       Model model) {
        PageInfo<LabEquipment> page = equipmentService.list(q, type, labId, status, pageNum, pageSize);
        model.addAttribute("page", page);
        model.addAttribute("q", q);
        model.addAttribute("type", type);
        model.addAttribute("labId", labId);
        model.addAttribute("status", status);
        return "equipment_list";
    }

    @GetMapping("/equipment/{id}")
    public String detail(@PathVariable("id") Long id, 
                        javax.servlet.http.HttpServletRequest request,
                        Model model) {
        LabEquipment equipment = equipmentService.getById(id);
        model.addAttribute("equipment", equipment);
        // 读取Flash消息
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null) {
            String errorMsg = (String) session.getAttribute("bookingErrorMsg");
            String successMsg = (String) session.getAttribute("bookingSuccessMsg");
            if (errorMsg != null) {
                model.addAttribute("error", errorMsg);
                session.removeAttribute("bookingErrorMsg");
            }
            if (successMsg != null) {
                model.addAttribute("msg", successMsg);
                session.removeAttribute("bookingSuccessMsg");
            }
        }
        return "equipment_detail";
    }
}



