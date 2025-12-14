<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="设备管理" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 页面标题 -->
    <div class="page-header">
        <h4>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
            </svg>
            设备管理
        </h4>
        <div>
            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/admin/equipment/form">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                    <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                </svg>
                新增设备
            </a>
        </div>
    </div>
    
    <!-- 提示信息 -->
    <c:if test="${not empty sessionScope.equipmentSuccessMsg}">
        <div class="alert alert-success" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
            </svg>
            ${sessionScope.equipmentSuccessMsg}
        </div>
        <c:remove var="equipmentSuccessMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.equipmentErrorMsg}">
        <div class="alert alert-danger" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
            </svg>
            ${sessionScope.equipmentErrorMsg}
        </div>
        <c:remove var="equipmentErrorMsg" scope="session"/>
    </c:if>
    
    <!-- 搜索表单 -->
    <div class="search-form">
        <form class="form-inline" method="get" action="${pageContext.request.contextPath}/admin/equipment">
            <input class="form-control" type="text" name="q" placeholder="关键字搜索" 
                   value="${q}" style="width: 240px; margin-right: 8px; margin-bottom: 8px;">
            <input class="form-control" type="text" name="type" placeholder="设备类型" 
                   value="${type}" style="width: 140px; margin-right: 8px; margin-bottom: 8px;">
            <input class="form-control" type="text" name="status" placeholder="设备状态" 
                   value="${status}" style="width: 140px; margin-right: 8px; margin-bottom: 8px;">
            <button class="btn btn-primary" type="submit" style="margin-bottom: 8px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                    <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                </svg>
                搜索
            </button>
        </form>
    </div>
    
    <!-- 设备列表表格 -->
    <div class="card">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th style="width: 60px;">ID</th>
                        <th>名称</th>
                        <th>型号</th>
                        <th>编码</th>
                        <th>类型</th>
                        <th style="width: 100px; text-align: center;">状态</th>
                        <th style="width: 180px; text-align: center;">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty page.list}">
                        <tr>
                            <td colspan="7" class="text-center text-muted" style="padding: 3rem;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" viewBox="0 0 16 16" style="opacity: 0.3; margin-bottom: 1rem;">
                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                    <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                                </svg>
                                <div>暂无设备数据</div>
                            </td>
                        </tr>
                    </c:if>
                    <c:forEach var="e" items="${page.list}">
                        <tr>
                            <td>${e.id}</td>
                            <td><strong>${e.equipmentName}</strong></td>
                            <td>${e.model}</td>
                            <td><code>${e.equipmentCode}</code></td>
                            <td>${e.type}</td>
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${e.status == 'AVAILABLE'}">
                                        <span class="badge badge-success">可用</span>
                                    </c:when>
                                    <c:when test="${e.status == 'MAINTAINING'}">
                                        <span class="badge badge-warning">维修中</span>
                                    </c:when>
                                    <c:when test="${e.status == 'SCRAPPED'}">
                                        <span class="badge badge-secondary">已报废</span>
                                    </c:when>
                                    <c:when test="${e.status == 'DISABLED'}">
                                        <span class="badge badge-secondary">停用</span>
                                    </c:when>
                                    <c:when test="${e.status == 'RESERVED'}">
                                        <span class="badge badge-info">已预约</span>
                                    </c:when>
                                    <c:when test="${e.status == 'IN_USE'}">
                                        <span class="badge badge-primary">使用中</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-info">${e.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: center;">
                                <a class="btn btn-sm btn-outline-primary" 
                                   href="${pageContext.request.contextPath}/admin/equipment/form?id=${e.id}"
                                   title="编辑设备">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                                        <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
                                    </svg>
                                    编辑
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/equipment/delete" 
                                      method="post" style="display: inline; margin-left: 4px;">
                                    <input type="hidden" name="id" value="${e.id}">
                                    <button class="btn btn-sm btn-outline-danger" 
                                            type="submit" 
                                            onclick="return confirm('确定要删除设备【${e.equipmentName}】吗？\n此操作不可恢复！');"
                                            title="删除设备">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                                            <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5Zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5Zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6Z"/>
                                            <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1ZM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118ZM2.5 3h11V2h-11v1Z"/>
                                        </svg>
                                        删除
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- 分页 -->
    <c:if test="${not empty page.list and page.pages > 1}">
        <nav aria-label="页码导航">
            <ul class="pagination">
                <c:if test="${page.hasPreviousPage}">
                    <li class="page-item">
                        <a class="page-link" href="?q=${q}&type=${type}&status=${status}&pageNum=${page.prePage}&pageSize=${page.pageSize}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                                <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
                            </svg>
                            上一页
                        </a>
                    </li>
                </c:if>
                <li class="page-item disabled">
                    <a class="page-link" href="#">第 ${page.pageNum} / ${page.pages} 页（共 ${page.total} 条）</a>
                </li>
                <c:if test="${page.hasNextPage}">
                    <li class="page-item">
                        <a class="page-link" href="?q=${q}&type=${type}&status=${status}&pageNum=${page.nextPage}&pageSize=${page.pageSize}">
                            下一页
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                                <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z"/>
                            </svg>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
