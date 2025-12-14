package com.labbooking.ssm.util;

import javax.servlet.http.HttpSession;
import java.util.List;

public class AuthzUtil {
    public static boolean hasRole(HttpSession session, String roleCode) {
        if (session == null) return false;
        Object rolesObj = session.getAttribute("LOGIN_ROLES");
        if (rolesObj instanceof List) {
            @SuppressWarnings("unchecked")
            List<String> roles = (List<String>) rolesObj;
            return roles.contains(roleCode);
        }
        return false;
    }
}



