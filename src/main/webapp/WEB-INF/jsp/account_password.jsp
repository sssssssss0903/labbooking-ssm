<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="修改密码" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <div class="form-container" style="max-width: 600px;">
        <!-- 页面标题 -->
        <div class="page-header">
            <h3>
                <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                    <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
                </svg>
                修改密码
            </h3>
        </div>

        <!-- 提示信息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                </svg>
                <strong>错误：</strong>${error}
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

        <!-- 修改密码表单 -->
        <form action="${pageContext.request.contextPath}/account/password" method="post" id="changePasswordForm">
            <div class="form-group">
                <label for="oldPwd" class="required">原密码</label>
                <input class="form-control" type="password" id="oldPwd" name="oldPwd" 
                       placeholder="请输入原密码" required>
                <small class="help-text">请输入您当前的密码以验证身份</small>
            </div>
            
            <div class="form-group">
                <label for="newPwd" class="required">新密码</label>
                <input class="form-control" type="password" id="newPwd" name="newPwd" 
                       placeholder="请输入新密码" required minlength="6" maxlength="32">
                <small class="help-text">密码长度至少6位，最多32位</small>
            </div>
            
            <div class="form-group">
                <label for="confirmPwd" class="required">确认新密码</label>
                <input class="form-control" type="password" id="confirmPwd" name="confirmPwd" 
                       placeholder="请再次输入新密码" required minlength="6" maxlength="32">
                <small class="help-text">请再次输入相同的密码以确认</small>
            </div>
            
            <div class="form-actions">
                <div></div>
                <div style="display: flex; gap: 1rem;">
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/account/profile">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
                        </svg>
                        返回个人资料
                    </a>
                    <button class="btn btn-primary" type="submit">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                        </svg>
                        提交修改
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // 前端密码确认验证
    document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
        var newPwd = document.getElementById('newPwd').value;
        var confirmPwd = document.getElementById('confirmPwd').value;
        
        if (newPwd !== confirmPwd) {
            e.preventDefault();
            alert('两次输入的新密码不一致，请重新输入');
            return false;
        }
        
        if (newPwd.length < 6) {
            e.preventDefault();
            alert('新密码长度至少6位');
            return false;
        }
    });
</script>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
