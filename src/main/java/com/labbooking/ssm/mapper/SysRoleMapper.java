package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.SysRole;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SysRoleMapper {
    List<String> selectRoleCodesByUserId(@Param("userId") Long userId);
    Long selectIdByCode(@Param("roleCode") String roleCode);
    List<SysRole> selectAll();
}


