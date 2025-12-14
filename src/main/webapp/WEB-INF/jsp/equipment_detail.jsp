<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="设备详情 - ${equipment.equipmentName}" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<!-- Flatpickr CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 返回按钮 -->
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/equipment" class="btn btn-link">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
            </svg>
            返回设备列表
        </a>
    </div>
    
    <!-- 设备基本信息 -->
    <div class="card">
        <div class="card-body">
            <h4 class="mb-3">${equipment.equipmentName}</h4>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>型号：</strong>${equipment.model}</p>
                    <p><strong>编码：</strong><code>${equipment.equipmentCode}</code></p>
                    <p><strong>类型：</strong>${equipment.type}</p>
                    <p>
                        <strong>状态：</strong>
                        <c:choose>
                            <c:when test="${equipment.status == 'AVAILABLE'}">
                                <span class="badge badge-success">可用</span>
                            </c:when>
                            <c:when test="${equipment.status == 'MAINTAINING'}">
                                <span class="badge badge-warning">维修中</span>
                            </c:when>
                            <c:when test="${equipment.status == 'SCRAPPED'}">
                                <span class="badge badge-secondary">已报废</span>
                            </c:when>
                            <c:when test="${equipment.status == 'DISABLED'}">
                                <span class="badge badge-secondary">停用</span>
                            </c:when>
                            <c:when test="${equipment.status == 'RESERVED'}">
                                <span class="badge badge-info">已预约</span>
                            </c:when>
                            <c:when test="${equipment.status == 'IN_USE'}">
                                <span class="badge badge-primary">使用中</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-info">${equipment.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <c:if test="${not empty equipment.imagePath}">
                    <div class="col-md-6 text-center">
                        <img src="${pageContext.request.contextPath}${equipment.imagePath}" 
                             alt="设备图片" 
                             style="max-width: 100%; max-height: 300px; border: 1px solid #dee2e6; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- 使用须知 -->
    <div class="card mt-3">
        <div class="card-header">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
            </svg>
            使用须知
        </div>
        <div class="card-body">
            <pre style="white-space: pre-wrap; background: #f8f9fa; padding: 1rem; border-radius: 4px; margin: 0;">${equipment.usageNotice}</pre>
        </div>
    </div>
    
    <!-- 提交预约 -->
    <div class="card mt-3">
        <div class="card-header">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
            </svg>
            提交预约
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                    </svg>
                    ${error}
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
            
            <c:choose>
                <c:when test="${empty sessionScope.LOGIN_USER}">
                    <div class="alert alert-info" role="alert">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                            <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
                        </svg>
                        请先 <a href="${pageContext.request.contextPath}/login" class="alert-link">登录</a> 后才能预约设备。
                        还没有账号？<a href="${pageContext.request.contextPath}/register" class="alert-link">立即注册</a>
                    </div>
                </c:when>
                <c:when test="${equipment.status != 'AVAILABLE'}">
                    <div class="alert alert-warning" role="alert">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                            <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                        </svg>
                        设备当前状态为 ${equipment.status}，暂时无法预约
                    </div>
                </c:when>
                <c:otherwise>
                    <form method="post" action="${pageContext.request.contextPath}/booking/submit">
                        <input type="hidden" name="equipmentId" value="${equipment.id}">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="startTime" class="required">开始时间</label>
                                    <input id="startTime" class="form-control" type="text" name="start" placeholder="选择开始时间" required>
                                    <small class="help-text">请选择预约开始时间（不能早于当前时间）</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="endTime" class="required">结束时间</label>
                                    <input id="endTime" class="form-control" type="text" name="end" placeholder="选择结束时间" required>
                                    <small class="help-text">请选择预约结束时间（必须晚于开始时间）</small>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="purpose" class="required">用途说明</label>
                            <input id="purpose" class="form-control" type="text" name="purpose" placeholder="如：课程实验/科研项目" required>
                            <small class="help-text">请简要说明预约用途</small>
                        </div>
                        <button class="btn btn-primary" type="submit">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                                <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                            </svg>
                            提交预约
                        </button>
                        <a class="btn btn-link" href="${pageContext.request.contextPath}/booking/my">查看我的预约</a>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- 设备维护/报修 -->
    <c:if test="${not empty sessionScope.LOGIN_USER}">
        <div class="card mt-3">
            <div class="card-header">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                    <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
                    <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319z"/>
                </svg>
                设备维护/报修
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <a class="btn btn-outline-warning" href="${pageContext.request.contextPath}/maintenance/${equipment.id}">查看维护记录</a>
                    <a class="btn btn-outline-info" href="${pageContext.request.contextPath}/maintenance/my">我的报修记录</a>
                </div>
                <c:choose>
                    <c:when test="${equipment.status == 'AVAILABLE'}">
                        <form action="${pageContext.request.contextPath}/maintenance/report" method="post">
                            <input type="hidden" name="equipmentId" value="${equipment.id}">
                            <div class="form-group">
                                <label for="description" class="required">问题描述</label>
                                <textarea id="description" class="form-control" name="description" rows="3" placeholder="请详细描述设备问题或维护需求" required></textarea>
                            </div>
                            <button class="btn btn-warning" type="submit" onclick="return confirm('确定提交报修？设备状态将更新为维修中');">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                                    <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                                </svg>
                                提交报修
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info" role="alert">设备当前状态为 ${equipment.status}，如需报修请联系管理员</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>
</div>

<!-- Flatpickr JS -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/zh.js"></script>
<script>
(function() {
    var fmt = "Y-m-d H:i";
    var now = new Date();
    var defaultEnd = new Date(now.getTime() + 60 * 60000);
    
    var startTimePicker = flatpickr("#startTime", {
        enableTime: true,
        dateFormat: fmt,
        defaultDate: now,
        minDate: "today",
        time_24hr: true,
        locale: flatpickr.l10ns.zh,
        onChange: function(selectedDates) {
            if (selectedDates.length > 0) {
                var startTime = selectedDates[0].getTime();
                var minEndTime = new Date(startTime + 60 * 60000);
                endTimePicker.set('minDate', minEndTime);
                if (endTimePicker.selectedDates.length === 0 || endTimePicker.selectedDates[0] < minEndTime) {
                    endTimePicker.setDate(minEndTime);
                }
            }
        }
    });
    
    var endTimePicker = flatpickr("#endTime", {
        enableTime: true,
        dateFormat: fmt,
        defaultDate: defaultEnd,
        minDate: defaultEnd,
        time_24hr: true,
        locale: flatpickr.l10ns.zh
    });
})();
</script>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
