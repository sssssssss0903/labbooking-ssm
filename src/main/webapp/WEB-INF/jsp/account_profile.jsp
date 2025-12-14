<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="个人资料" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 页面标题 -->
    <div class="page-header">
        <h4>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4Zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
            </svg>
            个人资料
        </h4>
    </div>

    <!-- 用户信息卡片 -->
    <div class="card">
        <div class="card-body">
            <div class="profile-row">
                <div class="profile-label"><strong>用户名：</strong></div>
                <div class="profile-value"><code>${user.username}</code></div>
            </div>

            <div class="profile-row">
                <div class="profile-label"><strong>真实姓名：</strong></div>
                <div class="profile-value">${user.realName != null ? user.realName : '<span class="text-muted">未设置</span>'}</div>
            </div>

            <div class="profile-row">
                <div class="profile-label"><strong>邮箱：</strong></div>
                <div class="profile-value">
                    <c:choose>
                        <c:when test="${not empty user.email}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                                <path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555ZM0 4.697v7.104l5.803-3.558L0 4.697ZM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757Zm3.436-.586L16 11.801V4.697l-5.803 3.546Z"/>
                            </svg>
                            ${user.email}
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">未设置</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="profile-row">
                <div class="profile-label"><strong>手机号：</strong></div>
                <div class="profile-value">
                    <c:choose>
                        <c:when test="${not empty user.phone}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                                <path fill-rule="evenodd" d="M1.885.511a1.745 1.745 0 0 1 2.61.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
                            </svg>
                            ${user.phone}
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">未设置</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="profile-row">
                <div class="profile-label"><strong>所属学院/部门：</strong></div>
                <div class="profile-value">${user.department != null ? user.department : '<span class="text-muted">未设置</span>'}</div>
            </div>

            <div class="profile-row">
                <div class="profile-label"><strong>账户状态：</strong></div>
                <div class="profile-value">
                    <c:choose>
                        <c:when test="${user.status == 1}">
                            <span class="badge badge-success">正常</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-secondary">已禁用</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
            
            <!-- 操作按钮 -->
            <div class="card mt-3">
                <div class="card-header">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                        <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
                        <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319z"/>
                    </svg>
                    账户设置
                </div>
                <div class="card-body">
                    <a class="btn btn-warning" href="${pageContext.request.contextPath}/account/password">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                            <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
                        </svg>
                        修改密码
                    </a>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/equipment">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
                        </svg>
                        返回首页
                    </a>
                </div>
            </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
