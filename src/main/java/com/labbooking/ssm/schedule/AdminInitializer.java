package com.labbooking.ssm.schedule;

import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.SysRoleMapper;
import com.labbooking.ssm.mapper.SysUserMapper;
import com.labbooking.ssm.mapper.SysUserRoleMapper;
import com.labbooking.ssm.util.PasswordEncoderUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.time.LocalDateTime;

/**
 * 应用启动时初始化默认管理员账号
 * 
 * 功能：
 * - 检查 admin 用户是否存在
 * - 如不存在，创建 admin 用户（密码：123456）
 * - 分配系统管理员角色（ROLE_SYS_ADMIN）
 * 
 * 优点：
 * - 不需要在 SQL 中硬编码 BCrypt 哈希值
 * - 使用统一的密码加密逻辑
 * - 确保每次部署都有默认管理员
 */
@Component
public class AdminInitializer {
    
    private static final Logger log = LoggerFactory.getLogger(AdminInitializer.class);
    
    private static final String DEFAULT_ADMIN_USERNAME = "admin";
    private static final String DEFAULT_ADMIN_PASSWORD = "123456";
    private static final String DEFAULT_ADMIN_REALNAME = "系统管理员";
    private static final String DEFAULT_ADMIN_EMAIL = "admin@example.com";
    
    @Resource
    private SysUserMapper sysUserMapper;
    
    @Resource
    private SysRoleMapper sysRoleMapper;
    
    @Resource
    private SysUserRoleMapper sysUserRoleMapper;
    
    @PostConstruct
    public void initDefaultAdmin() {
        log.info("[INIT] Checking default admin account...");
        
        try {
            // 检查 admin 用户是否已存在
            SysUser existingAdmin = sysUserMapper.selectByUsername(DEFAULT_ADMIN_USERNAME);
            
            if (existingAdmin != null) {
                log.info("[INIT] Admin account already exists: id={}, username={}, status={}", 
                    existingAdmin.getId(), existingAdmin.getUsername(), existingAdmin.getStatus());
                return;
            }
            
            // 创建管理员用户
            log.info("[INIT] Creating default admin account...");
            
            SysUser admin = new SysUser();
            admin.setUsername(DEFAULT_ADMIN_USERNAME);
            admin.setPassword(PasswordEncoderUtil.encode(DEFAULT_ADMIN_PASSWORD)); // 动态生成 BCrypt 哈希
            admin.setRealName(DEFAULT_ADMIN_REALNAME);
            admin.setEmail(DEFAULT_ADMIN_EMAIL);
            admin.setStatus(1); // 启用状态
            admin.setCreateTime(LocalDateTime.now());
            admin.setUpdateTime(LocalDateTime.now());
            
            sysUserMapper.insert(admin);
            log.info("[INIT] Admin user created: id={}, username={}", admin.getId(), admin.getUsername());
            
            // 分配系统管理员角色
            Long sysAdminRoleId = sysRoleMapper.selectIdByCode("ROLE_SYS_ADMIN");
            if (sysAdminRoleId != null) {
                sysUserRoleMapper.insert(admin.getId(), sysAdminRoleId);
                log.info("[INIT] Admin role assigned: userId={}, roleId={}, roleCode=ROLE_SYS_ADMIN", 
                    admin.getId(), sysAdminRoleId);
            } else {
                log.error("[INIT] ROLE_SYS_ADMIN not found in sys_role table! Admin user created but no role assigned.");
            }
            
            log.info("[INIT] Default admin account initialization completed successfully.");
            log.info("[INIT] ============================================");
            log.info("[INIT] Default Admin Credentials:");
            log.info("[INIT]   Username: {}", DEFAULT_ADMIN_USERNAME);
            log.info("[INIT]   Password: {}", DEFAULT_ADMIN_PASSWORD);
            log.info("[INIT] ============================================");
            
        } catch (Exception e) {
            log.error("[INIT] Failed to initialize default admin account", e);
            // 不抛出异常，避免影响应用启动
            // 如果初始化失败，管理员可以通过 SQL 手动创建
        }
    }
}

