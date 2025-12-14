package com.labbooking.ssm.controller;

import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabBooking;
import com.labbooking.ssm.domain.LabInfo;
import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.service.BookingService;
import com.labbooking.ssm.util.AuthzUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/booking")
public class BookingController {

    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Resource
    private BookingService bookingService;
    @Resource
    private com.labbooking.ssm.mapper.LabInfoMapper labInfoMapper;

    @PostMapping("/submit")
    public String submit(@RequestParam("equipmentId") Long equipmentId,
                         @RequestParam("start") String start,
                         @RequestParam("end") String end,
                         @RequestParam(value = "purpose", required = false) String purpose,
                         HttpServletRequest request,
                         Model model) {
        HttpSession session = request.getSession(false);
        SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
        if (user == null) {
            model.addAttribute("error", "请先登录");
            return "redirect:/login";
        }
        try {
            LocalDateTime st = LocalDateTime.parse(start, DTF);
            LocalDateTime et = LocalDateTime.parse(end, DTF);
            bookingService.submit(user.getId(), equipmentId, st, et, purpose);
            // 使用Flash属性传递成功消息
            request.getSession().setAttribute("bookingSuccessMsg", "预约已提交，待审批");
            return "redirect:/booking/my";
        } catch (java.time.format.DateTimeParseException e) {
            request.getSession().setAttribute("bookingErrorMsg", "时间格式错误，请使用 yyyy-MM-dd HH:mm 格式");
            return "redirect:/equipment/" + equipmentId;
        } catch (Exception ex) {
            request.getSession().setAttribute("bookingErrorMsg", ex.getMessage());
            return "redirect:/equipment/" + equipmentId;
        }
    }

    @GetMapping("/my")
    public String my(@RequestParam(value = "status", required = false) String status,
                     @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                     @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                     HttpServletRequest request,
                     Model model) {
        SysUser user = (SysUser) request.getSession(false).getAttribute("LOGIN_USER");
        PageInfo<LabBooking> page = bookingService.myBookings(user.getId(), status, pageNum, pageSize);
        model.addAttribute("page", page);
        model.addAttribute("status", status);
        // 读取Flash消息
        HttpSession session = request.getSession(false);
        if (session != null) {
            String successMsg = (String) session.getAttribute("bookingSuccessMsg");
            String errorMsg = (String) session.getAttribute("bookingErrorMsg");
            if (successMsg != null) {
                model.addAttribute("msg", successMsg);
                session.removeAttribute("bookingSuccessMsg");
            }
            if (errorMsg != null) {
                model.addAttribute("error", errorMsg);
                session.removeAttribute("bookingErrorMsg");
            }
        }
        return "booking_my";
    }

    // 待审批列表（Lab Admin）
    @GetMapping("/pending")
    public String pending(@RequestParam(value = "labId", required = false) Long labId,
                          @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
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
        // 读取Flash消息
        String successMsg = (String) session.getAttribute("bookingSuccessMsg");
        String errorMsg = (String) session.getAttribute("bookingErrorMsg");
        if (successMsg != null) {
            model.addAttribute("msg", successMsg);
            session.removeAttribute("bookingSuccessMsg");
        }
        if (errorMsg != null) {
            model.addAttribute("error", errorMsg);
            session.removeAttribute("bookingErrorMsg");
        }
        SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
        if (isLabAdmin && !isSysAdmin) {
            // 只显示自己负责的实验室，支持按 labId 过滤
            PageInfo<LabBooking> page = bookingService.pendingListFiltered(user.getId(), labId, pageNum, pageSize);
            model.addAttribute("page", page);
            model.addAttribute("labId", labId);
            // 提供下拉可选实验室
            List<LabInfo> labs = labInfoMapper.listByManagerId(user.getId());
            model.addAttribute("labs", labs);
        } else {
            // 系统管理员可查看全部（可选按 labId 过滤）
            PageInfo<LabBooking> page = bookingService.pendingListFiltered(null, labId, pageNum, pageSize);
            model.addAttribute("page", page);
            model.addAttribute("labId", labId);
        }
        return "booking_pending";
    }

    // 审批（Lab Admin）
    @PostMapping("/{id}/approve")
    public String approve(@PathVariable("id") Long id,
                          @RequestParam("pass") boolean pass,
                          @RequestParam(value = "comment", required = false) String comment,
                          HttpServletRequest request,
                          Model model) {
        HttpSession session = request.getSession(false);
        SysUser approver = (SysUser) session.getAttribute("LOGIN_USER");
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        
        // 参数校验：如果是拒绝，必须填写拒绝原因
        if (!pass && (comment == null || comment.trim().isEmpty())) {
            session.setAttribute("bookingErrorMsg", "拒绝预约时必须填写拒绝原因");
            return "redirect:/booking/pending";
        }
        
        try {
            boolean ok = bookingService.approve(id, approver.getId(), pass, comment);
            if (!ok) {
                session.setAttribute("bookingErrorMsg", "审批失败：状态已变更或预约不存在");
                return "redirect:/booking/pending";
            }
            session.setAttribute("bookingSuccessMsg", pass ? "审批通过" : "审批已拒绝");
            return "redirect:/booking/pending";
        } catch (Exception e) {
            session.setAttribute("bookingErrorMsg", e.getMessage());
            return "redirect:/booking/pending";
        }
    }

    // 完成（Lab Admin）
    @PostMapping("/{id}/finish")
    public String finish(@PathVariable("id") Long id,
                         HttpServletRequest request,
                         Model model) {
        HttpSession session = request.getSession(false);
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        boolean ok = bookingService.finish(id);
        if (!ok) {
            session.setAttribute("bookingErrorMsg", "完成失败：预约未到期或状态不允许");
        } else {
            session.setAttribute("bookingSuccessMsg", "预约已完成");
        }
        return "redirect:/booking/pending";
    }

    // 取消（预约人）
    @PostMapping("/{id}/cancel")
    public String cancel(@PathVariable("id") Long id,
                         HttpServletRequest request,
                         Model model) {
        HttpSession session = request.getSession(false);
        com.labbooking.ssm.domain.SysUser user = (com.labbooking.ssm.domain.SysUser) session.getAttribute("LOGIN_USER");
        boolean ok = bookingService.cancel(id, user.getId());
        if (!ok) {
            session.setAttribute("bookingErrorMsg", "取消失败：仅可取消待审批或已通过但未开始的本人预约");
            return "redirect:/booking/my";
        }
        session.setAttribute("bookingSuccessMsg", "预约已取消");
        return "redirect:/booking/my";
    }
    // 批量完成（Lab Admin）
    @PostMapping("/finish-batch")
    public String finishBatch(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (!AuthzUtil.hasRole(session, "ROLE_LAB_ADMIN") && !AuthzUtil.hasRole(session, "ROLE_SYS_ADMIN")) {
            model.addAttribute("error", "无权限操作");
            return "error";
        }
        int count = bookingService.finishBatchEnded();
        session.setAttribute("bookingSuccessMsg", "已批量完成 " + count + " 个到期预约");
        return "redirect:/booking/pending";
    }
}


