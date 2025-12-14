<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="修改用户密码" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container">
    <div class="card app-card">
        <div class="card-header app-card-header">
            <h3 class="card-title app-card-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                    <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 1 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2H8z"/>
                </svg>
                修改用户密码
            </h3>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>错误：</strong> ${error}
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>成功：</strong> ${success}
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            </c:if>

            <div class="user-info-box mb-4">
                <div class="info-item">
                    <strong>用户ID：</strong><span>${user.id}</span>
                </div>
                <div class="info-item">
                    <strong>用户名：</strong><span>${user.username}</span>
                </div>
                <div class="info-item">
                    <strong>姓名：</strong><span>${user.realName != null && !user.realName.isEmpty() ? user.realName : '未填写'}</span>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/admin/users/${user.id}/password" method="post" id="changePasswordForm">
                <div class="form-group">
                    <label for="newPassword" class="required">新密码</label>
                    <input class="form-control" type="password" id="newPassword" name="newPassword" 
                           placeholder="请输入新密码" required minlength="6" maxlength="32">
                    <small class="form-text text-muted">密码长度至少6位，最多32位</small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="required">确认新密码</label>
                    <input class="form-control" type="password" id="confirmPassword" name="confirmPassword" 
                           placeholder="请再次输入新密码" required minlength="6" maxlength="32">
                    <small class="form-text text-muted">请再次输入相同的密码以确认</small>
                </div>

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
                            修改密码
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // 表单验证
    document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('两次输入的密码不一致，请重新输入！');
            return false;
        }
        
        if (newPassword.length < 6) {
            e.preventDefault();
            alert('密码长度至少为6位！');
            return false;
        }
    });
</script>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
