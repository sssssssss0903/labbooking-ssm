package com.labbooking.ssm.mapper;

import org.apache.ibatis.annotations.Param;

public interface SysUserRoleMapper {
    int deleteByUserId(@Param("userId") Long userId);
    int insert(@Param("userId") Long userId, @Param("roleId") Long roleId);
}



