package com.labbooking.ssm.service;

import com.labbooking.ssm.domain.SysUser;

public interface AuthService {
    SysUser login(String username, String rawPassword);
    
    /**
     * 注册新用户（默认为学生角色）
     * @param username 用户名（4-20字符，唯一）
     * @param password 密码（至少6位）
     * @param realName 真实姓名
     * @param email 邮箱
     * @param phone 手机号
     * @param department 院系/单位
     * @throws IllegalArgumentException 用户名已存在或参数不合法
     */
    void register(String username, String password, String realName, 
                  String email, String phone, String department);
}



