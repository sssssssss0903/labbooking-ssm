<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="设备列表" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 页面标题 -->
    <div class="page-header">
        <h4>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                <path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zm8 0A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm-8 8A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm8 0A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3z"/>
            </svg>
            设备列表
        </h4>
    </div>
    
    <!-- 成功消息提示 -->
    <c:if test="${not empty sessionScope.passwordChangeSuccess}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
            </svg>
            ${sessionScope.passwordChangeSuccess}
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
        <c:remove var="passwordChangeSuccess" scope="session"/>
    </c:if>
    
    <!-- 搜索表单 -->
    <div class="search-form">
        <form class="form-inline" method="get" action="${pageContext.request.contextPath}/equipment">
            <input class="form-control" type="text" name="q" placeholder="关键字搜索" 
                   value="${q}" style="width: 260px; margin-right: 8px; margin-bottom: 8px;">
            <input class="form-control" type="text" name="type" placeholder="设备类型" 
                   value="${type}" style="width: 160px; margin-right: 8px; margin-bottom: 8px;">
            <input class="form-control" type="text" name="status" placeholder="设备状态" 
                   value="${status}" style="width: 160px; margin-right: 8px; margin-bottom: 8px;">
            <button class="btn btn-primary" type="submit" style="margin-bottom: 8px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                    <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                </svg>
                搜索
            </button>
            <select class="form-control" name="pageSize" onchange="changePageSize(this.value)" style="width: 100px; margin-left: 8px; margin-bottom: 8px;">
                <option value="5" ${page.pageSize == 5 ? 'selected' : ''}>每页5条</option>
                <option value="10" ${page.pageSize == 10 ? 'selected' : ''}>每页10条</option>
                <option value="20" ${page.pageSize == 20 ? 'selected' : ''}>每页20条</option>
                <option value="50" ${page.pageSize == 50 ? 'selected' : ''}>每页50条</option>
            </select>
            <input type="hidden" name="pageNum" id="pageNumInput" value="1">

            <script>
                function changePageSize(pageSize) {
                    // 重置到第1页并设置新的pageSize
                    document.getElementById('pageNumInput').value = '1';
                    // 构建URL参数
                    var params = new URLSearchParams(window.location.search);
                    params.set('pageSize', pageSize);
                    params.set('pageNum', '1');
                    // 跳转到新URL
                    window.location.href = window.location.pathname + '?' + params.toString();
                }
            </script>
            <c:if test="${not empty q or not empty type or not empty labId or not empty status}">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/equipment?pageSize=${page.pageSize}" style="margin-left: 8px; margin-bottom: 8px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                        <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8 2.146 2.854Z"/>
                    </svg>
                    清除筛选
                </a>
            </c:if>
        </form>
    </div>
    
    <!-- 设备列表 -->
    <c:if test="${empty page.list}">
        <div class="equipment-card text-center" style="padding: 3rem;">
            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" viewBox="0 0 16 16" style="margin: 0 auto 1rem; opacity: 0.3;">
                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
            </svg>
            <h5 class="text-muted">暂无设备数据</h5>
            <p class="text-muted">请尝试调整搜索条件或联系管理员添加设备</p>
        </div>
    </c:if>
    
    <c:forEach var="item" items="${page.list}">
        <div class="equipment-card">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div style="flex: 1;">
                    <div class="equipment-card-title">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                            <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                            <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                        </svg>
                        ${item.equipmentName}
                        <small class="text-muted">(${item.model})</small>
                    </div>
                    <div class="equipment-card-meta">
                        <span style="margin-right: 1rem;">
                            <strong>编码：</strong>${item.equipmentCode}
                        </span>
                        <span style="margin-right: 1rem;">
                            <strong>类型：</strong>${item.type}
                        </span>
                        <span>
                            <strong>状态：</strong>
                            <c:choose>
                                <c:when test="${item.status == 'AVAILABLE'}">
                                    <span class="badge badge-outline-success">可用</span>
                                </c:when>
                                <c:when test="${item.status == 'MAINTAINING'}">
                                    <span class="badge badge-outline-warning">维修中</span>
                                </c:when>
                                <c:when test="${item.status == 'SCRAPPED'}">
                                    <span class="badge badge-outline-secondary">已报废</span>
                                </c:when>
                                <c:when test="${item.status == 'DISABLED'}">
                                    <span class="badge badge-outline-secondary">停用</span>
                                </c:when>
                                <c:when test="${item.status == 'RESERVED'}">
                                    <span class="badge badge-outline-info">已预约</span>
                                </c:when>
                                <c:when test="${item.status == 'IN_USE'}">
                                    <span class="badge badge-outline-primary">使用中</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-outline-secondary">${item.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <c:if test="${not empty item.labLocation}">
                        <div class="equipment-card-meta" style="margin-top: 0.5rem;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                                <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10zm0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6z"/>
                            </svg>
                            <strong>位置：</strong>${item.labLocation}
                        </div>
                    </c:if>
                </div>
                <div>
                    <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/equipment/${item.id}">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                            <path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8zM1.173 8a13.133 13.133 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13.133 13.133 0 0 1 14.828 8c-.058.087-.122.183-.195.288-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5c-2.12 0-3.879-1.168-5.168-2.457A13.134 13.134 0 0 1 1.172 8z"/>
                            <path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5zM4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0z"/>
                        </svg>
                        查看详情
                    </a>
                </div>
            </div>
        </div>
    </c:forEach>
    
    <!-- 分页 -->
    <c:if test="${not empty page}">
        <nav aria-label="页码导航">
            <ul class="pagination">
                <c:if test="${page.hasPreviousPage}">
                    <li class="page-item">
                        <a class="page-link" href="?q=${q}&type=${type}&labId=${labId}&status=${status}&pageNum=${page.prePage}&pageSize=${page.pageSize}">
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
                        <a class="page-link" href="?q=${q}&type=${type}&labId=${labId}&status=${status}&pageNum=${page.nextPage}&pageSize=${page.pageSize}">
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
