package com.labbooking.ssm.service;

import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabEquipment;

public interface EquipmentService {
    PageInfo<LabEquipment> list(String q, String type, Long labId, String status, int pageNum, int pageSize);
    LabEquipment getById(Long id);
    
    /**
     * 删除设备
     * @param id 设备ID
     * @throws IllegalStateException 如果设备有进行中或未完成的预约
     */
    void delete(Long id);
    
    /**
     * 更新设备状态
     * @param id 设备ID
     * @param status 新状态（AVAILABLE/MAINTENANCE/DISABLED）
     */
    void updateStatus(Long id, String status);
}



