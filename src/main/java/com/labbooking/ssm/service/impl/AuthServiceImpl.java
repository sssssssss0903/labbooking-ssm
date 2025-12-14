package com.labbooking.ssm.service.impl;

import com.labbooking.ssm.domain.SysUser;
import com.labbooking.ssm.mapper.SysRoleMapper;
import com.labbooking.ssm.mapper.SysUserMapper;
import com.labbooking.ssm.mapper.SysUserRoleMapper;
import com.labbooking.ssm.service.AuthService;
import com.labbooking.ssm.util.PasswordEncoderUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class AuthServiceImpl implements AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthServiceImpl.class);

    @Resource
    private SysUserMapper sysUserMapper;
    @Resource
    private SysRoleMapper sysRoleMapper;
    @Resource
    private SysUserRoleMapper sysUserRoleMapper;

    /**
     * 登录认证（Authentication）：
     * 1) 参数规范化（trim）
     * 2) 查询用户
     * 3) BCrypt 校验密码
     * 4) 校验账号状态
     * 5) 加载角色列表（用于后续授权/拦截器判断）
     *
     * 关键调试日志：
     * - 记录 username 是否被 trim、是否包含非 ASCII/不可见字符
     * - 打印数据库密码 hash 的“指纹”（长度/前缀/尾部/是否包含空白）
     * - 输出密码匹配结果 match=true/false
     */

    @Override
    public SysUser login(String username, String rawPassword) {
    
        // ===== 0) 参数检查 =====
        if (username == null || rawPassword == null) {
            log.warn("[AUTH] login reject: null param. usernameNull={}, passwordNull={}",
                    username == null, rawPassword == null);
            return null;
        }
    
        // 原始入参快照（不打印明文密码）
        final String usernameRaw = username;
        final String passwordRaw = rawPassword;
    
        // 入参特征：用于排查复制粘贴/空白字符等问题
        log.info("[AUTH] login attempt: usernameRaw='{}'(len={},leadingOrTrailingSpace={},nonAscii={}), pwdLen={}, pwdLeadingOrTrailingSpace={}",
                safe(usernameRaw),
                usernameRaw.length(),
                hasLeadingOrTrailingSpace(usernameRaw),
                containsNonAscii(usernameRaw),
                passwordRaw.length(),
                hasLeadingOrTrailingSpace(passwordRaw)
        );
    
        // ===== 1) 规范化（trim）=====
        username = username.trim();
        rawPassword = rawPassword.trim();
    
        if (!username.equals(usernameRaw)) {
            log.info("[AUTH] normalized username: raw='{}' -> norm='{}'",
                    safe(usernameRaw), safe(username));
        }
        if (rawPassword.length() != passwordRaw.length()) {
            log.info("[AUTH] normalized password length changed: rawLen={} -> normLen={}",
                    passwordRaw.length(), rawPassword.length());
        }
    
        // ===== 2) self-check：固定 hash 是否等于 "123456"（定位根因用）=====
        // 注意：这条日志建议只在 admin 登录尝试时打印，避免无意义刷屏
        final String fixedHash = "$2a$10$EqKcp1WFKVQISheBxkQJoOqFbsEV2B1gw/AU/BoSw.a/a1VvVHoDe";
        if ("admin".equalsIgnoreCase(username)) {
            boolean fixedHashIs123456 = PasswordEncoderUtil.matches("123456", fixedHash);
            log.info("[AUTH] self-check: fixedHash matches('123456') = {}", fixedHashIs123456);
            // 解释：
            // - 若 false：说明你数据库里这条固定 hash 本身就不是 123456，对不上是正常的
            // - 若 true ：说明 fixedHash 就是 123456 的 hash，那你实际输入的可能不是 123456（但从 pwdLen=6 看概率低）
        }
    
        // ===== 3) 查询用户 =====
        SysUser found = sysUserMapper.selectByUsername(username);
        if (found == null) {
            log.warn("[AUTH] login failed: user not found. username='{}'", safe(username));
            return null;
        }
    
        log.info("[AUTH] user loaded: id={}, username='{}', status={}, email={}, phone={}, dept={}",
                found.getId(),
                safe(found.getUsername()),
                found.getStatus(),
                safe(found.getEmail()),
                safe(found.getPhone()),
                safe(found.getDepartment())
        );
    
        // ===== 4) 数据库 hash 指纹（确认程序实际读到的 password）=====
        String dbHash = found.getPassword();
        if (dbHash == null) {
            log.error("[AUTH] login failed: db password is NULL. username='{}', userId={}",
                    safe(username), found.getId());
            return null;
        }
    
        log.info("[AUTH] dbHash fingerprint: len={}, prefix='{}', tail='{}', hasWhitespace={}, startsWithBcrypt={}",
                dbHash.length(),
                head(dbHash, 7),        // e.g. "$2a$10$"
                tail(dbHash, 10),       // 方便你核对是否是那条 /a1VvVHoDe
                containsWhitespace(dbHash),
                dbHash.startsWith("$2a$") || dbHash.startsWith("$2b$") || dbHash.startsWith("$2y$")
        );
    
        // ===== 5) 密码匹配 =====
        boolean ok;
        try {
            ok = PasswordEncoderUtil.matches(rawPassword, dbHash);
        } catch (Exception e) {
            log.error("[AUTH] password match threw exception. username='{}', userId={}, dbHashPrefix='{}'",
                    safe(username), found.getId(), head(dbHash, 4), e);
            return null;
        }
    
        log.info("[AUTH] password match result: username='{}', userId={}, match={}",
                safe(username), found.getId(), ok);
    
        // ===== 6) 状态校验 =====
        Integer status = found.getStatus();
        boolean enabled = (status == null || status.intValue() == 1);
        if (!enabled) {
            log.warn("[AUTH] login failed: account disabled. username='{}', userId={}, status={}",
                    safe(username), found.getId(), status);
            return null;
        }
    
        // ===== 7) 失败分支：admin 不匹配时给出“可复制的修复 hash”=====
        if (!ok) {
            if ("admin".equalsIgnoreCase(username)) {
                // 仅在 admin 失败时输出一个“重置为 123456”的新 hash
                String newHash = PasswordEncoderUtil.encode("123456");
                log.warn("[AUTH] admin password mismatch. To reset admin password to '123456', run SQL:");
                log.warn("[AUTH] UPDATE sys_user SET password='{}', update_time=NOW() WHERE username='admin';", newHash);
            }
    
            log.warn("[AUTH] login failed: password mismatch. username='{}', userId={}, dbHashFingerprint(len={},prefix='{}',tail='{}')",
                    safe(username), found.getId(), dbHash.length(), head(dbHash, 7), tail(dbHash, 10));
            return null;
        }
    
        // ===== 8) 加载角色（成功分支）=====
        try {
            List<String> roles = sysRoleMapper.selectRoleCodesByUserId(found.getId());
            found.setRoleCodes(roles);
            log.info("[AUTH] roles loaded: username='{}', userId={}, roles={}",
                    safe(username), found.getId(), roles);
        } catch (Exception e) {
            log.error("[AUTH] roles load failed. username='{}', userId={}",
                    safe(username), found.getId(), e);
        }
    
        log.info("[AUTH] login success: username='{}', userId={}", safe(username), found.getId());
        return found;
    }
    

    /**
     * 注册（Registration）：
     * - 用户名唯一性校验
     * - BCrypt 加密存储
     * - 分配默认角色 ROLE_USER
     * - 事务保证：用户插入与角色绑定要么都成功，要么都回滚
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void register(String username, String password, String realName,
                         String email, String phone, String department) {

        SysUser existing = sysUserMapper.selectByUsername(username);
        if (existing != null) {
            throw new IllegalArgumentException("用户名已存在");
        }

        SysUser newUser = new SysUser();
        newUser.setUsername(username);
        newUser.setPassword(PasswordEncoderUtil.encode(password)); // BCrypt
        newUser.setRealName(realName);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setDepartment(department);
        newUser.setStatus(1);
        newUser.setCreateTime(LocalDateTime.now());
        newUser.setUpdateTime(LocalDateTime.now());

        sysUserMapper.insert(newUser);

        Long roleId = sysRoleMapper.selectIdByCode("ROLE_USER");
        if (roleId != null) {
            sysUserRoleMapper.insert(newUser.getId(), roleId);
        }
    }

    /* ====================== 辅助方法：必须在类的大括号内部 ====================== */

    // 避免日志被换行/控制字符污染：把 \r \n \t 可视化
    private String safe(String s) {
        if (s == null) return "null";
        return s.replace("\r", "\\r").replace("\n", "\\n").replace("\t", "\\t");
    }

    private boolean hasLeadingOrTrailingSpace(String s) {
        if (s == null || s.isEmpty()) return false;
        return Character.isWhitespace(s.charAt(0)) || Character.isWhitespace(s.charAt(s.length() - 1));
    }

    private boolean containsNonAscii(String s) {
        if (s == null) return false;
        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) > 127) return true;
        }
        return false;
    }

    private boolean containsWhitespace(String s) {
        if (s == null) return false;
        for (int i = 0; i < s.length(); i++) {
            if (Character.isWhitespace(s.charAt(i))) return true;
        }
        return false;
    }

    private String head(String s, int n) {
        if (s == null) return "null";
        return s.substring(0, Math.min(n, s.length()));
    }

    private String tail(String s, int n) {
        if (s == null) return "null";
        int start = Math.max(0, s.length() - n);
        return s.substring(start);
    }
}
