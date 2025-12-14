<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>用户注册 - LabBooking 实验室预约系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/app.css">
</head>
<body>
    <div class="auth-card" style="max-width: 560px;">
        <div class="brand">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
                <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/>
            </svg>
            用户注册
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                </svg>
                <strong>注册失败：</strong>${error}
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
        
        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="username" class="required">用户名（学号/工号）</label>
                        <input type="text" class="form-control" id="username" name="username" 
                               placeholder="请输入用户名" required maxlength="64"
                               pattern="[a-zA-Z0-9_]{3,64}"
                               title="用户名只能包含字母、数字和下划线，长度3-64位">
                        <small class="help-text">将用于登录系统</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="realName">真实姓名</label>
                        <input type="text" class="form-control" id="realName" name="realName" 
                               placeholder="请输入真实姓名" maxlength="64">
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="password" class="required">密码</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="请输入密码" required minlength="6" maxlength="32">
                        <small class="help-text">密码长度至少6位</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="passwordConfirm" class="required">确认密码</label>
                        <input type="password" class="form-control" id="passwordConfirm" name="passwordConfirm" 
                               placeholder="请再次输入密码" required>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="email">邮箱</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="example@university.edu" maxlength="100">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="phone">手机号</label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               placeholder="请输入手机号" maxlength="30">
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="department">所属学院/单位</label>
                <input type="text" class="form-control" id="department" name="department" 
                       placeholder="例如：计算机学院" maxlength="100">
            </div>
            
            <div class="form-actions">
                <div></div>
                <div style="display: flex; gap: 1rem;">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">已有账号？立即登录</a>
                    <button type="submit" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                        </svg>
                        注册
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- JavaScript依赖 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 客户端密码确认验证
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var password = document.getElementById('password').value;
            var passwordConfirm = document.getElementById('passwordConfirm').value;
            
            if (password !== passwordConfirm) {
                e.preventDefault();
                alert('两次输入的密码不一致，请重新输入');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('密码长度至少6位');
                return false;
            }
        });
    </script>
</body>
</html>
