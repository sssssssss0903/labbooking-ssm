<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.labbooking.ssm.domain.SysUser" %>
<%@ page import="java.util.List" %>
<%
    SysUser user = (SysUser) session.getAttribute("LOGIN_USER");
    List<String> roles = (List<String>) session.getAttribute("LOGIN_ROLES");
    boolean isLabAdmin = roles != null && roles.contains("ROLE_LAB_ADMIN");
    boolean isSysAdmin = roles != null && roles.contains("ROLE_SYS_ADMIN");
    boolean isAdmin = isLabAdmin || isSysAdmin;
%>
<nav class="navbar navbar-expand-lg navbar-light bg-light" style="margin-bottom: 20px; border-bottom: 1px solid #dee2e6;">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/equipment'/>"><strong>LabBooking</strong></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/equipment'/>">设备列表</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/booking/my'/>">我的预约</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/usage/my'/>">使用记录</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/maintenance/my'/>">我的报修</a>
                </li>
                <% if (isAdmin) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-toggle="dropdown">
                        管理员功能
                    </a>
                    <div class="dropdown-menu">
                        <% if (isLabAdmin || isSysAdmin) { %>
                        <a class="dropdown-item" href="<c:url value='/booking/pending'/>">审批预约</a>
                        <a class="dropdown-item" href="<c:url value='/maintenance/all'/>">维护记录</a>
                        <% } %>
                        <% if (isLabAdmin) { %>
                        <a class="dropdown-item" href="<c:url value='/admin/equipment'/>">设备管理</a>
                        <% } %>
                        <% if (isSysAdmin) { %>
                        <a class="dropdown-item" href="<c:url value='/admin/users'/>">用户管理</a>
                        <a class="dropdown-item" href="<c:url value='/admin/labs'/>">实验室管理</a>
                        <a class="dropdown-item" href="<c:url value='/admin/params'/>">系统参数</a>
                        <% } %>
                    </div>
                </li>
                <% } %>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <span class="navbar-text">
                        <c:out value="${user.realName != null ? user.realName : user.username}"/>
                        <% if (isAdmin) { %>
                            <span class="badge badge-primary">管理员</span>
                        <% } else { %>
                            <span class="badge badge-secondary">普通用户</span>
                        <% } %>
                    </span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/logout'/>">退出</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

