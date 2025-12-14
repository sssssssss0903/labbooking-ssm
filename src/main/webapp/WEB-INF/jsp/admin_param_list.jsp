<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="系统参数配置" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container">
    <div class="card app-card">
        <div class="card-header app-card-header">
            <h3 class="card-title app-card-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                    <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
                    <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319z"/>
                </svg>
                系统参数配置
            </h3>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/params/save" method="post">
                <div class="form-group">
                    <label for="defaultMinutes" class="required">默认预约时长（分钟）</label>
                    <input class="form-control" type="number" id="defaultMinutes" name="defaultMinutes" 
                           value="${defaultMinutes}" min="15" step="5" required>
                    <small class="form-text text-muted">建议设置为15的倍数（如：15、30、60、120）</small>
                </div>
                
                <div class="form-group">
                    <label for="maxAdvanceDays" class="required">最大可提前预约天数</label>
                    <input class="form-control" type="number" id="maxAdvanceDays" name="maxAdvanceDays" 
                           value="${maxAdvanceDays}" min="1" step="1" required>
                    <small class="form-text text-muted">用户最多可提前多少天进行预约（建议：7-30天）</small>
                </div>
                
                <div class="form-actions">
                    <div></div>
                    <div style="display: flex; gap: 1rem;">
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/equipment">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
                            </svg>
                            返回
                        </a>
                        <button class="btn btn-primary" type="submit">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                            </svg>
                            保存配置
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
