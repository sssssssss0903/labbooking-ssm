package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.SysUser;
import org.apache.ibatis.annotations.Param;

public interface SysUserMapper {
    SysUser selectByUsername(@Param("username") String username);
    SysUser selectById(@Param("id") Long id);
    int insert(SysUser user);
    int update(SysUser user);
    java.util.List<SysUser> listAll();
    java.util.List<SysUser> selectByRole(@Param("roleCode") String roleCode);
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
    int updatePassword(@Param("id") Long id, @Param("password") String password);
}



