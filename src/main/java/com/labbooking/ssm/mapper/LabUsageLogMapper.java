package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.LabUsageLog;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LabUsageLogMapper {
    int insert(LabUsageLog log);
    List<LabUsageLog> listByUserId(@Param("userId") Long userId);
}



