<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${lab.id == null ? '新增实验室' : '编辑实验室'}" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container">
    <div class="card app-card">
        <div class="card-header app-card-header">
            <h3 class="card-title app-card-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                    <path d="M8.186 1.113a.5.5 0 0 0-.372 0L1.846 3.5 8 5.961 14.154 3.5 8.186 1.113zM15 4.239l-6.5 2.6v7.922l6.5-2.6V4.24zM7.5 14.762V6.838L1 4.239v7.923l6.5 2.6zM7.443.184a1.5 1.5 0 0 1 1.114 0l7.129 2.852A.5.5 0 0 1 16 3.5v8.662a1 1 0 0 1-.629.928l-7.185 2.874a.5.5 0 0 1-.372 0L.63 13.09a1 1 0 0 1-.63-.928V3.5a.5.5 0 0 1 .314-.464L7.443.184z"/>
                </svg>
                ${lab.id == null ? '新增实验室' : '编辑实验室'}
            </h3>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>错误：</strong> ${error}
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/labs/save" method="post">
                <input type="hidden" name="id" value="${lab.id}">
                
                <div class="form-group">
                    <label for="labName" class="required">实验室名称</label>
                    <input type="text" class="form-control" id="labName" name="labName" value="${lab.labName}" 
                           placeholder="如：电子工程实验室" required maxlength="100">
                </div>
                
                <div class="form-group">
                    <label for="location" class="required">位置</label>
                    <input type="text" class="form-control" id="location" name="location" value="${lab.location}" 
                           placeholder="如：A栋305" required maxlength="200">
                </div>
                
                <div class="form-group">
                    <label for="managerId">负责人</label>
                    <select class="form-control" id="managerId" name="managerId">
                        <option value="">无负责人</option>
                        <c:forEach var="admin" items="${adminUsers}">
                            <option value="${admin.id}" ${lab.managerId == admin.id ? 'selected' : ''}>
                                ${admin.realName != null ? admin.realName : admin.username} (${admin.username})
                            </option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">选择实验室负责人（系统管理员或实验室管理员）</small>
                </div>
                
                <div class="form-group">
                    <label for="status">状态</label>
                    <select class="form-control" id="status" name="status">
                        <option value="NORMAL" ${lab.status == 'NORMAL' ? 'selected' : ''}>正常</option>
                        <option value="CLOSED" ${lab.status == 'CLOSED' ? 'selected' : ''}>关闭</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="description">描述</label>
                    <textarea class="form-control" id="description" name="description" rows="4" 
                              placeholder="实验室简介" maxlength="500">${lab.description}</textarea>
                </div>
                
                <div class="form-actions">
                    <div></div>
                    <div style="display: flex; gap: 1rem;">
                        <a href="${pageContext.request.contextPath}/admin/labs" class="btn btn-secondary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
                            </svg>
                            取消
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
                            </svg>
                            保存
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
