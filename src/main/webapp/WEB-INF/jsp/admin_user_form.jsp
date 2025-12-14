<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="创建用户" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <div class="form-container">
        <!-- 页面标题 -->
        <div class="page-header">
            <h3>
                <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                    <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
                    <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
                </svg>
                创建新用户
            </h3>
        </div>

        <!-- 提示信息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                </svg>
                <strong>错误：</strong> ${error}
            </div>
        </c:if>

        <c:if test="${not empty msg}">
            <div class="alert alert-success" role="alert">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                </svg>
                ${msg}
            </div>
        </c:if>

        <!-- 创建用户表单 -->
        <form action="${pageContext.request.contextPath}/admin/users/create" method="post" id="createUserForm">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="username" class="required">用户名</label>
                        <input class="form-control" type="text" id="username" name="username" 
                               placeholder="请输入用户名" required maxlength="64" 
                               pattern="[a-zA-Z0-9_]{3,64}" 
                               title="用户名只能包含字母、数字和下划线，长度3-64位">
                        <small class="help-text">用户名将用于登录系统，长度3-64位</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="password" class="required">密码</label>
                        <input class="form-control" type="password" id="password" name="password" 
                               placeholder="请输入密码" required minlength="6" maxlength="32">
                        <small class="help-text">密码长度至少6位</small>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="realName">真实姓名</label>
                        <input class="form-control" type="text" id="realName" name="realName" 
                               placeholder="请输入真实姓名" maxlength="64">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="email">邮箱</label>
                        <input class="form-control" type="email" id="email" name="email" 
                               placeholder="example@university.edu" maxlength="100">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="phone">联系电话</label>
                        <input class="form-control" type="tel" id="phone" name="phone" 
                               placeholder="请输入联系电话" maxlength="30">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="department">所属学院/部门</label>
                        <input class="form-control" type="text" id="department" name="department" 
                               placeholder="例如：计算机学院" maxlength="100">
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="required">用户角色</label>
                <div class="role-checkbox-group">
                    <c:if test="${empty roles}">
                        <div class="alert alert-warning" role="alert" style="margin: 0;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                                <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                            </svg>
                            系统中暂无可用角色，请联系管理员配置角色
                        </div>
                    </c:if>
                    <c:forEach var="role" items="${roles}">
                        <div class="role-checkbox">
                            <label>
                                <input type="checkbox" name="roles" value="${role.roleCode}">
                                <strong>${role.roleName}</strong> 
                                <span class="badge badge-secondary" style="font-size: 0.75rem;">${role.roleCode}</span>
                            </label>
                            <c:if test="${not empty role.description}">
                                <div class="role-description">${role.description}</div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
                <small class="help-text">至少选择一个角色，用户权限由角色决定</small>
            </div>

            <!-- 按钮组 -->
            <div class="form-actions">
                <div></div>
                <div style="display: flex; gap: 1rem;">
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
                        </svg>
                        返回列表
                    </a>
                    <button class="btn btn-primary" type="submit">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                        </svg>
                        创建用户
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>

<script>
    // 表单验证
    document.getElementById('createUserForm').addEventListener('submit', function(e) {
        const checkboxes = document.querySelectorAll('input[name="roles"]:checked');
        if (checkboxes.length === 0) {
            e.preventDefault();
            alert('请至少选择一个用户角色！');
            return false;
        }
    });
    
    // 用户名输入实时验证提示
    document.getElementById('username').addEventListener('input', function(e) {
        const value = e.target.value;
        const pattern = /^[a-zA-Z0-9_]{3,64}$/;
        
        if (value && !pattern.test(value)) {
            e.target.setCustomValidity('用户名只能包含字母、数字和下划线，长度3-64位');
        } else {
            e.target.setCustomValidity('');
        }
    });
</script>
