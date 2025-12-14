<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="我的预约" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 页面标题 -->
    <div class="page-header">
        <h4>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
            </svg>
            我的预约
        </h4>
    </div>
    
    <!-- 提示信息 -->
    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
            </svg>
            ${msg}
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
            </svg>
            ${error}
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    </c:if>
    
    <!-- 筛选表单 -->
    <div class="search-form">
        <form method="get" class="form-inline" action="${pageContext.request.contextPath}/booking/my">
            <label style="margin-right: 8px;">状态筛选：</label>
            <select class="form-control" name="status" style="width: 200px; margin-right: 8px;">
                <option value="">全部</option>
                <option value="PENDING" <c:if test="${status=='PENDING'}">selected</c:if>>待审批</option>
                <option value="APPROVED" <c:if test="${status=='APPROVED'}">selected</c:if>>已通过</option>
                <option value="REJECTED" <c:if test="${status=='REJECTED'}">selected</c:if>>已拒绝</option>
                <option value="CANCELLED" <c:if test="${status=='CANCELLED'}">selected</c:if>>已取消</option>
                <option value="FINISHED" <c:if test="${status=='FINISHED'}">selected</c:if>>已完成</option>
            </select>
            <button class="btn btn-primary" type="submit">筛选</button>
        </form>
    </div>
    
    <!-- 预约列表 -->
    <c:choose>
        <c:when test="${empty page.list}">
            <div class="card text-center" style="padding: 3rem;">
                <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" viewBox="0 0 16 16" style="margin: 0 auto 1rem; opacity: 0.3;">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                    <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                </svg>
                <h5 class="text-muted">暂无预约记录</h5>
                <p class="text-muted">去<a href="${pageContext.request.contextPath}/equipment">设备列表</a>预约设备吧</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>设备</th>
                                <th>实验室</th>
                                <th>开始时间</th>
                                <th>结束时间</th>
                                <th style="width: 120px; text-align: center;">状态</th>
                                <th>提交时间</th>
                                <th style="width: 100px; text-align: center;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${page.list}">
                                <tr>
                                    <td>${b.id}</td>
                                    <td>
                                        <strong><c:out value="${b.equipmentName}"/></strong>
                                        <br><small class="text-muted">${b.equipmentCode} / #${b.equipmentId}</small>
                                    </td>
                                    <td><c:out value="${b.labName}"/></td>
                                    <td>${b.startTime}</td>
                                    <td>${b.endTime}</td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${b.status == 'PENDING'}">
                                                <span class="badge badge-outline-warning">待审批</span>
                                            </c:when>
                                            <c:when test="${b.status == 'APPROVED'}">
                                                <span class="badge badge-outline-success">已通过</span>
                                            </c:when>
                                            <c:when test="${b.status == 'REJECTED'}">
                                                <span class="badge badge-outline-danger">已拒绝</span>
                                            </c:when>
                                            <c:when test="${b.status == 'CANCELLED'}">
                                                <span class="badge badge-outline-secondary">已取消</span>
                                            </c:when>
                                            <c:when test="${b.status == 'FINISHED'}">
                                                <span class="badge badge-outline-info">已完成</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-outline-secondary">${b.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${b.status == 'REJECTED' && not empty b.approveComment}">
                                            <br><small class="text-danger">拒绝原因：${b.approveComment}</small>
                                        </c:if>
                                        <c:if test="${b.status == 'APPROVED' && not empty b.approveComment}">
                                            <br><small class="text-muted">审批意见：${b.approveComment}</small>
                                        </c:if>
                                    </td>
                                    <td>${b.applyTime}</td>
                                    <td style="text-align: center;">
                                        <c:if test="${b.status == 'PENDING' || b.status == 'APPROVED'}">
                                            <form action="${pageContext.request.contextPath}/booking/${b.id}/cancel" method="post" style="display: inline;">
                                                <button class="btn btn-outline-secondary btn-sm" type="submit" 
                                                        onclick="return confirm('确定取消此预约？');"
                                                        title="取消预约">
                                                    取消
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
            
            <!-- 分页 -->
            <nav aria-label="页码导航">
                <ul class="pagination">
                    <c:if test="${page.hasPreviousPage}">
                        <li class="page-item">
                            <a class="page-link" href="?status=${status}&pageNum=${page.prePage}&pageSize=${page.pageSize}">上一页</a>
                        </li>
                    </c:if>
                    <li class="page-item disabled">
                        <a class="page-link" href="#">第 ${page.pageNum} / ${page.pages} 页（共 ${page.total} 条）</a>
                    </li>
                    <c:if test="${page.hasNextPage}">
                        <li class="page-item">
                            <a class="page-link" href="?status=${status}&pageNum=${page.nextPage}&pageSize=${page.pageSize}">下一页</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
