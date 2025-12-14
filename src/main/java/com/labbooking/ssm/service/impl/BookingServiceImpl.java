package com.labbooking.ssm.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabBooking;
import com.labbooking.ssm.domain.LabEquipment;
import com.labbooking.ssm.domain.LabUsageLog;
import com.labbooking.ssm.mapper.LabBookingMapper;
import com.labbooking.ssm.mapper.LabEquipmentMapper;
import com.labbooking.ssm.mapper.LabUsageLogMapper;
import com.labbooking.ssm.service.BookingService;
import com.labbooking.ssm.service.ParamService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class BookingServiceImpl implements BookingService {

    @Resource
    private LabBookingMapper labBookingMapper;
    @Resource
    private LabEquipmentMapper labEquipmentMapper;
    @Resource
    private LabUsageLogMapper labUsageLogMapper;
    @Resource
    private ParamService paramService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public LabBooking submit(Long userId, Long equipmentId, LocalDateTime start, LocalDateTime end, String purpose) {
        // 1. 基础参数校验
        if (userId == null || equipmentId == null || start == null || end == null) {
            throw new IllegalArgumentException("预约参数不完整");
        }
        
        LocalDateTime now = LocalDateTime.now();
        
        // 2. 时间有效性校验
        if (start.isBefore(now)) {
            throw new IllegalArgumentException("预约开始时间不能早于当前时间");
        }
        
        if (!end.isAfter(start)) {
            throw new IllegalArgumentException("预约结束时间必须晚于开始时间");
        }
        
        // 3. 预约时长限制（例如：不超过4小时）
        int maxDurationHours = paramService.getInt("booking.maxDurationHours", 4);
        long durationHours = java.time.Duration.between(start, end).toHours();
        if (durationHours > maxDurationHours) {
            throw new IllegalArgumentException("单次预约时长不能超过 " + maxDurationHours + " 小时");
        }
        
        // 4. 提前预约天数限制
        int maxAdvanceDays = paramService.getInt("booking.maxAdvanceDays", 14);
        LocalDateTime maxAdvanceDate = now.plusDays(maxAdvanceDays);
        if (start.isAfter(maxAdvanceDate)) {
            throw new IllegalArgumentException("预约超出允许的最远日期（最多提前 " + maxAdvanceDays + " 天）");
        }
        
        // 5. 检查设备是否存在和可用
        LabEquipment eq = labEquipmentMapper.selectById(equipmentId);
        if (eq == null) {
            throw new IllegalArgumentException("设备不存在");
        }
        if (!"AVAILABLE".equalsIgnoreCase(eq.getStatus())) {
            throw new IllegalStateException("设备当前不可预约（状态：" + eq.getStatus() + "）");
        }
        
        // 6. 时间冲突检查（排除 REJECTED 和 CANCELLED 的预约）
        int conflicts = labBookingMapper.countConflict(equipmentId, start, end, null);
        if (conflicts > 0) {
            throw new IllegalStateException("所选时间段与已存在预约冲突，请选择其他时间段");
        }
        
        // 7. 创建预约记录
        LabBooking booking = new LabBooking();
        booking.setUserId(userId);
        booking.setEquipmentId(equipmentId);
        booking.setStartTime(start);
        booking.setEndTime(end);
        booking.setPurpose(purpose);
        booking.setStatus("PENDING");
        booking.setApplyTime(now);
        booking.setCreateTime(now);
        booking.setUpdateTime(now);
        
        labBookingMapper.insert(booking);
        return booking;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean approve(Long bookingId, Long approverId, boolean pass, String comment) {
        // 1. 检查预约是否存在且为待审批状态
        LabBooking booking = labBookingMapper.selectById(bookingId);
        if (booking == null || !"PENDING".equals(booking.getStatus())) {
            return false;
        }
        
        // 2. 如果是通过审批，需要再次进行时间冲突检查（防止并发审批导致冲突）
        if (pass) {
            int conflicts = labBookingMapper.countConflict(
                booking.getEquipmentId(), 
                booking.getStartTime(), 
                booking.getEndTime(), 
                bookingId
            );
            if (conflicts > 0) {
                throw new IllegalStateException("审批失败：与其他已通过的预约时间冲突");
            }
        }
        
        // 3. 更新审批状态
        String newStatus = pass ? "APPROVED" : "REJECTED";
        String rejectReason = pass ? null : comment;
        int rows = labBookingMapper.approve(bookingId, approverId, LocalDateTime.now(), newStatus, rejectReason);
        
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean finish(Long bookingId) {
        LabBooking booking = labBookingMapper.selectById(bookingId);
        if (booking == null) {
            return false;
        }
        if (!"APPROVED".equals(booking.getStatus())) {
            return false;
        }
        // 允许管理员在预约结束时间后标记为完成
        if (booking.getEndTime() == null || booking.getEndTime().isAfter(LocalDateTime.now())) {
            return false;
        }
        
        LocalDateTime now = LocalDateTime.now();
        boolean ok = labBookingMapper.updateStatus(bookingId, "FINISHED") > 0;
        if (ok) {
            // 自动生成使用记录
            LabUsageLog log = new LabUsageLog();
            log.setBookingId(booking.getId());
            log.setActualStartTime(booking.getStartTime());
            log.setActualEndTime(booking.getEndTime());
            log.setRemark("系统自动完成");
            log.setCreateTime(now);
            log.setUpdateTime(now);
            labUsageLogMapper.insert(log);
        }
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int finishBatchEnded() {
        LocalDateTime now = LocalDateTime.now();
        List<LabBooking> ended = labBookingMapper.listEndedApproved(now);
        int affected = labBookingMapper.finishIfEnded(now);
        if (!ended.isEmpty()) {
            for (LabBooking b : ended) {
                LabUsageLog log = new LabUsageLog();
                log.setBookingId(b.getId());
                log.setActualStartTime(b.getStartTime());
                log.setActualEndTime(b.getEndTime());
                log.setRemark("系统批量自动完成");
                log.setCreateTime(now);
                log.setUpdateTime(now);
                labUsageLogMapper.insert(log);
            }
        }
        return affected;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean cancel(Long bookingId, Long userId) {
        // 1. 检查预约是否存在
        LabBooking booking = labBookingMapper.selectById(bookingId);
        if (booking == null) {
            return false;
        }
        
        // 2. 检查是否为本人的预约
        if (!booking.getUserId().equals(userId)) {
            return false;
        }
        
        LocalDateTime now = LocalDateTime.now();
        
        // 3. 待审批状态可以直接取消
        if ("PENDING".equals(booking.getStatus())) {
            booking.setCancelTime(now);
            booking.setUpdateTime(now);
            return labBookingMapper.updateStatus(bookingId, "CANCELLED") > 0;
        }
        
        // 4. 已通过的预约，检查是否在开始时间之前
        if ("APPROVED".equals(booking.getStatus())) {
            if (booking.getStartTime() == null || !now.isBefore(booking.getStartTime())) {
                return false; // 已经开始或已过期，不能取消
            }
            
            // 5. 检查是否在取消时间限制内（例如：开始前30分钟内不可取消）
            int cancelMinutesBeforeStart = paramService.getInt("booking.cancelMinutesBeforeStart", 30);
            LocalDateTime cancelDeadline = booking.getStartTime().minusMinutes(cancelMinutesBeforeStart);
            if (now.isAfter(cancelDeadline)) {
                throw new IllegalStateException("距离预约开始时间不足 " + cancelMinutesBeforeStart + " 分钟，无法取消");
            }
            
            booking.setCancelTime(now);
            booking.setUpdateTime(now);
            return labBookingMapper.updateStatus(bookingId, "CANCELLED") > 0;
        }
        
        // 其他状态不允许取消
        return false;
    }

    @Override
    public PageInfo<LabBooking> myBookings(Long userId, String status, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<LabBooking> list = labBookingMapper.listByUser(userId, status);
        return new PageInfo<>(list);
    }

    @Override
    public PageInfo<LabBooking> pendingList(int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<LabBooking> list = labBookingMapper.listPending();
        return new PageInfo<>(list);
    }

    @Override
    public PageInfo<LabBooking> pendingListFiltered(Long managerId, Long labId, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<LabBooking> list = labBookingMapper.listPendingFiltered(managerId, labId);
        return new PageInfo<>(list);
    }

    @Override
    public LabBooking getById(Long id) {
        return labBookingMapper.selectById(id);
    }
}


