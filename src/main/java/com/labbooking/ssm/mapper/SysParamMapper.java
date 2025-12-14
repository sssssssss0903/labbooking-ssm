package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.SysParam;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SysParamMapper {
    SysParam selectByKey(@Param("paramKey") String key);
    int upsert(@Param("paramKey") String key, @Param("paramValue") String value, @Param("remark") String remark);
    List<SysParam> selectAll();
}



