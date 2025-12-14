package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.LabMaintenance;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LabMaintenanceMapper {
    int insert(LabMaintenance m);
    int updateStatus(@Param("id") Long id,
                     @Param("status") String status,
                     @Param("completeTime") java.time.LocalDateTime completeTime,
                     @Param("handlerId") Long handlerId);
    List<LabMaintenance> listByEquipment(@Param("equipmentId") Long equipmentId);
    List<LabMaintenance> listByReportUser(@Param("userId") Long userId);
    List<LabMaintenance> listAll();
}



