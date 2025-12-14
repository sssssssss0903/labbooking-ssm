<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="待审批预约" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <!-- 页面标题 -->
    <div class="page-header">
        <h4>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8 4a.905.905 0 0 0-.9.995l.35 3.507a.552.552 0 0 0 1.1 0l.35-3.507A.905.905 0 0 0 8 4zm.002 6a1 1 0 1 0 0 2 1 1 0 0 0 0-2z"/>
            </svg>
            待审批预约
        </h4>
        <div>
            <form action="${pageContext.request.contextPath}/booking/finish-batch" method="post" style="display: inline;">
                <button class="btn btn-outline-info btn-sm" type="submit" onclick="return confirm('确定批量完成所有到期预约？');">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom;">
                        <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                    </svg>
                    批量完成到期预约
                </button>
            </form>
        </div>
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
    
    <!-- 实验室筛选 -->
    <c:if test="${not empty labs}">
        <div class="search-form">
            <form method="get" action="${pageContext.request.contextPath}/booking/pending">
                <label style="margin-right: 8px;">实验室筛选：</label>
                <select class="form-control" name="labId" style="width: 260px; display: inline-block; margin-right: 8px;">
                    <option value="">全部实验室</option>
                    <c:forEach var="lab" items="${labs}">
                        <option value="${lab.id}" <c:if test="${labId == lab.id}">selected</c:if>>${lab.labName}</option>
                    </c:forEach>
                </select>
                <button class="btn btn-primary" type="submit">筛选</button>
            </form>
        </div>
    </c:if>
    
    <!-- 预约列表 -->
    <div class="card">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th style="width: 60px;">ID</th>
                        <th>设备</th>
                        <th>实验室</th>
                        <th>申请人</th>
                        <th>开始时间</th>
                        <th>结束时间</th>
                        <th>用途</th>
                        <th style="width: 400px; text-align: center;">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty page.list}">
                        <tr>
                            <td colspan="8" class="text-center text-muted" style="padding: 3rem;">暂无待审批预约</td>
                        </tr>
                    </c:if>
                    <c:forEach var="b" items="${page.list}">
                        <tr>
                            <td>${b.id}</td>
                            <td>
                                <strong><c:out value="${b.equipmentName}"/></strong>
                                <br><small class="text-muted">${b.equipmentCode} / #${b.equipmentId}</small>
                            </td>
                            <td><c:out value="${b.labName}"/></td>
                            <td>
                                <c:out value="${b.applicantName}"/>
                                <br><small class="text-muted">${b.applicantPhone} / #${b.userId}</small>
                            </td>
                            <td>${b.startTime}</td>
                            <td>${b.endTime}</td>
                            <td><c:out value="${b.purpose}"/></td>
                            <td style="text-align: left;">
                                <div style="display: flex; flex-direction: column; gap: 4px;">
                                    <form action="${pageContext.request.contextPath}/booking/${b.id}/approve" method="post" style="display: flex; align-items: center; gap: 4px;">
                                        <input class="form-control form-control-sm" type="text" name="comment" placeholder="审批意见（可选）" style="width: 140px;">
                                        <input type="hidden" name="pass" value="true">
                                        <button class="btn btn-sm btn-success" type="submit" onclick="return confirm('确定通过此预约？');">通过</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/booking/${b.id}/approve" method="post" style="display: flex; align-items: center; gap: 4px;">
                                        <input class="form-control form-control-sm" type="text" name="comment" placeholder="拒绝原因" style="width: 140px;">
                                        <input type="hidden" name="pass" value="false">
                                        <button class="btn btn-sm btn-outline-danger" type="submit" onclick="return confirm('确定拒绝此预约？');">拒绝</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/booking/${b.id}/finish" method="post" style="display: flex; align-items: center;">
                                        <button class="btn btn-sm btn-outline-info" type="submit" onclick="return confirm('确定完成此预约？');">完成</button>
                                    </form>
                                </div>
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
                        <a class="page-link" href="?labId=${labId}&pageNum=${page.prePage}&pageSize=${page.pageSize}">上一页</a>
                    </li>
                </c:if>
                <li class="page-item disabled">
                    <a class="page-link" href="#">第 ${page.pageNum} / ${page.pages} 页（共 ${page.total} 条）</a>
                </li>
                <c:if test="${page.hasNextPage}">
                    <li class="page-item">
                        <a class="page-link" href="?labId=${labId}&pageNum=${page.nextPage}&pageSize=${page.pageSize}">下一页</a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
