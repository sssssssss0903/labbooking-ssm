<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="设备维护记录" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 页面标题 -->
    <div class="page-header">
        <h4>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
                <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319z"/>
            </svg>
            <c:if test="${not empty equipment}">
                ${equipment.equipmentName} - 维护/报修记录
            </c:if>
            <c:if test="${empty equipment}">
                设备 #${equipmentId} - 维护/报修记录
            </c:if>
        </h4>
        <div>
            <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/equipment/${equipmentId}">返回设备</a>
            <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/maintenance/all">所有维护记录</a>
        </div>
    </div>
    
    <!-- 提示信息 -->
    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${msg}
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    </c:if>
    
    <!-- 发起报修表单 -->
    <div class="card" style="margin-bottom: 2rem;">
        <div class="card-header">
            <h5 style="margin: 0;">发起报修/维护</h5>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/maintenance/report" method="post">
                <input type="hidden" name="equipmentId" value="${equipmentId}">
                <div class="form-group">
                    <label for="description" class="required">问题描述</label>
                    <textarea class="form-control" id="description" name="description" rows="4" 
                              placeholder="请详细描述设备问题或维护需求，以便管理员快速处理" required></textarea>
                </div>
                <button class="btn btn-primary" type="submit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z"/>
                    </svg>
                    提交报修
                </button>
            </form>
        </div>
    </div>
    
    <!-- 维护记录列表 -->
    <c:choose>
        <c:when test="${empty list}">
            <div class="card text-center" style="padding: 3rem;">
                <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" viewBox="0 0 16 16" style="margin: 0 auto 1rem; opacity: 0.3;">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                    <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                </svg>
                <h5 class="text-muted">暂无维护/报修记录</h5>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>报修人</th>
                                <th>问题描述</th>
                                <th style="width: 100px; text-align: center;">状态</th>
                                <th>创建时间</th>
                                <th>完成时间</th>
                                <th>处理人</th>
                                <th style="width: 120px; text-align: center;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${list}">
                                <tr>
                                    <td>${m.id}</td>
                                    <td>
                                        <c:out value="${m.reportUserName}"/>
                                        <br><small class="text-muted">#${m.reportUserId}</small>
                                    </td>
                                    <td><c:out value="${m.description}"/></td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${m.status == 'REPORTED'}">
                                                <span class="badge badge-outline-warning">已报修</span>
                                            </c:when>
                                            <c:when test="${m.status == 'IN_PROGRESS'}">
                                                <span class="badge badge-outline-info">处理中</span>
                                            </c:when>
                                            <c:when test="${m.status == 'DONE'}">
                                                <span class="badge badge-outline-success">已完成</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-outline-secondary">${m.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${m.createTime}</td>
                                    <td>${m.completeTime}</td>
                                    <td>
                                        <c:if test="${not empty m.handlerName}">
                                            <c:out value="${m.handlerName}"/>
                                            <br><small class="text-muted">#${m.handlerId}</small>
                                        </c:if>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:if test="${m.status != 'DONE'}">
                                            <form action="${pageContext.request.contextPath}/maintenance/${m.id}/done" method="post" style="display: inline;">
                                                <input type="hidden" name="equipmentId" value="${equipmentId}">
                                                <button class="btn btn-outline-success btn-sm" type="submit" 
                                                        onclick="return confirm('确定标记为已完成？设备状态将恢复为可用');"
                                                        title="标记完成">
                                                    标记完成
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
