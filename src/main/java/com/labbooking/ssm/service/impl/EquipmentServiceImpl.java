package com.labbooking.ssm.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabEquipment;
import com.labbooking.ssm.mapper.LabEquipmentMapper;
import com.labbooking.ssm.mapper.LabBookingMapper;
import com.labbooking.ssm.service.EquipmentService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class EquipmentServiceImpl implements EquipmentService {

    @Resource
    private LabEquipmentMapper labEquipmentMapper;
    
    @Resource
    private LabBookingMapper labBookingMapper;

    @Override
    public PageInfo<LabEquipment> list(String q, String type, Long labId, String status, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<LabEquipment> list = labEquipmentMapper.queryList(q, type, labId, status);
        return new PageInfo<>(list);
    }

    @Override
    public LabEquipment getById(Long id) {
        return labEquipmentMapper.selectById(id);
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        LabEquipment equipment = labEquipmentMapper.selectById(id);
        if (equipment == null) {
            throw new IllegalArgumentException("设备不存在");
        }
        
        // 检查是否有进行中或未完成的预约（PENDING/APPROVED）
        int activeBookings = labBookingMapper.countConflict(
            id, 
            LocalDateTime.now().minusYears(10), 
            LocalDateTime.now().plusYears(10), 
            null
        );
        
        if (activeBookings > 0) {
            throw new IllegalStateException("设备存在进行中或待审批的预约，不能删除。请先将设备状态改为 DISABLED（停用）");
        }
        
        // 执行删除
        labEquipmentMapper.delete(id);
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, String status) {
        LabEquipment equipment = labEquipmentMapper.selectById(id);
        if (equipment == null) {
            throw new IllegalArgumentException("设备不存在");
        }
        
        // 验证状态值
        if (!isValidStatus(status)) {
            throw new IllegalArgumentException("无效的设备状态：" + status);
        }
        
        equipment.setStatus(status);
        equipment.setUpdateTime(LocalDateTime.now());
        labEquipmentMapper.update(equipment);
    }
    
    private boolean isValidStatus(String status) {
        return "AVAILABLE".equals(status) || 
               "MAINTENANCE".equals(status) || 
               "DISABLED".equals(status) ||
               "RESERVED".equals(status) ||
               "IN_USE".equals(status);
    }
}



