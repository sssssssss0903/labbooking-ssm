package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.LabInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LabInfoMapper {
    List<LabInfo> listByManagerId(@Param("managerId") Long managerId);
    List<LabInfo> selectAll();
    LabInfo selectById(@Param("id") Long id);
    int insert(LabInfo lab);
    int update(LabInfo lab);
}


