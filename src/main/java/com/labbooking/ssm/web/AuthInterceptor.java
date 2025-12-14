package com.labbooking.ssm.web;

import com.labbooking.ssm.domain.SysUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 权限拦截器
 * - 游客：只能访问登录、注册、首页、设备列表/详情
 * - 学生：可访问个人预约、设备预约等学生功能
 * - 管理员：可访问后台管理功能（/admin/*）
 */
public class AuthInterceptor implements HandlerInterceptor {
    private static final Logger log = LoggerFactory.getLogger(AuthInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        // 移除上下文路径，获取相对路径
        String path = uri.substring(contextPath.length());
        
        log.debug("AuthInterceptor: path={}", path);
        
        // 游客可访问的路径（公开路径）
        if (isPublicPath(path)) {
            return true;
        }
        
        // 检查登录状态
        HttpSession session = request.getSession(false);
        if (session == null) {
            log.debug("未登录，重定向到登录页");
            response.sendRedirect(contextPath + "/login");
            return false;
        }
        
        SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
        if (user == null) {
            log.debug("Session中无用户信息，重定向到登录页");
            response.sendRedirect(contextPath + "/login");
            return false;
        }
        
        // 检查管理员路径的权限
        if (path.startsWith("/admin/")) {
            @SuppressWarnings("unchecked")
            List<String> roles = (List<String>) session.getAttribute("LOGIN_ROLES");
            boolean isAdmin = roles != null && 
                (roles.contains("ROLE_LAB_ADMIN") || roles.contains("ROLE_SYS_ADMIN"));
            
            if (!isAdmin) {
                log.warn("非管理员尝试访问管理路径: user={}, path={}", user.getUsername(), path);
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足：需要管理员权限");
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * 判断是否为游客可访问的公开路径
     */
    private boolean isPublicPath(String path) {
        // 首页和登录注册相关
        if (path.equals("/") || path.equals("/index.jsp") || 
            path.startsWith("/login") || path.startsWith("/logout") || 
            path.startsWith("/register")) {
            return true;
        }
        
        // 静态资源
        if (path.startsWith("/static") || path.startsWith("/uploads")) {
            return true;
        }
        
        // 设备公开列表和详情（游客可查看）
        if (path.equals("/equipment") || path.startsWith("/equipment/") && isNumericId(path)) {
            return true;
        }
        
        return false;
    }
    
    /**
     * 检查路径是否为设备详情页（/equipment/{id}）
     */
    private boolean isNumericId(String path) {
        try {
            String[] parts = path.split("/");
            if (parts.length == 3 && parts[1].equals("equipment")) {
                Long.parseLong(parts[2]);
                return true;
            }
        } catch (NumberFormatException e) {
            // ignore
        }
        return false;
    }
}



