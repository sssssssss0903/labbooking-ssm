package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.LabEquipment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LabEquipmentMapper {
    LabEquipment selectById(@Param("id") Long id);
    List<LabEquipment> queryList(@Param("q") String q,
                                 @Param("type") String type,
                                 @Param("labId") Long labId,
                                 @Param("status") String status);
    List<LabEquipment> adminQueryList(@Param("q") String q,
                                      @Param("type") String type,
                                      @Param("labId") Long labId,
                                      @Param("status") String status,
                                      @Param("managerId") Long managerId);
    int insert(LabEquipment equipment);
    int update(LabEquipment equipment);
    int delete(@Param("id") Long id);
}


