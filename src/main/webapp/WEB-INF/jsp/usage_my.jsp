<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="我的使用记录" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 页面标题 -->
    <div class="page-header">
        <h4>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
            </svg>
            我的使用记录
        </h4>
    </div>
    
    <!-- 使用记录列表 -->
    <c:choose>
        <c:when test="${empty page.list}">
            <div class="card text-center" style="padding: 3rem;">
                <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" viewBox="0 0 16 16" style="margin: 0 auto 1rem; opacity: 0.3;">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                    <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                </svg>
                <h5 class="text-muted">暂无使用记录</h5>
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
                                <th>实际开始</th>
                                <th>实际结束</th>
                                <th>用途</th>
                                <th>备注</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${page.list}">
                                <tr>
                                    <td>${log.id}</td>
                                    <td>
                                        <strong><c:out value="${log.equipmentName}"/></strong>
                                        <br><small class="text-muted">${log.equipmentCode} / #${log.equipmentId}</small>
                                    </td>
                                    <td><c:out value="${log.labName}"/></td>
                                    <td>${log.actualStartTime}</td>
                                    <td>${log.actualEndTime}</td>
                                    <td><c:out value="${log.purpose}"/></td>
                                    <td><c:out value="${log.remark}"/></td>
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
                            <a class="page-link" href="?pageNum=${page.prePage}&pageSize=${page.pageSize}">上一页</a>
                        </li>
                    </c:if>
                    <li class="page-item disabled">
                        <a class="page-link" href="#">第 ${page.pageNum} / ${page.pages} 页（共 ${page.total} 条）</a>
                    </li>
                    <c:if test="${page.hasNextPage}">
                        <li class="page-item">
                            <a class="page-link" href="?pageNum=${page.nextPage}&pageSize=${page.pageSize}">下一页</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
