<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="${equipment.id == null ? '新增设备' : '编辑设备'}" scope="request"/>
<%@ include file="/WEB-INF/jsp/common/_header.jspf" %>

<div class="container app-main-container" style="margin-top: 2rem; margin-bottom: 2rem;">
    <div class="form-container">
        <!-- 页面标题 -->
        <div class="page-header">
            <h3>
                <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 8px;">
                    <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                    <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                </svg>
                ${equipment.id == null ? '新增设备' : '编辑设备'}
            </h3>
        </div>

        <!-- 提示信息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                </svg>
                <strong>错误：</strong> ${error}
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

        <!-- 设备表单 -->
        <form action="${pageContext.request.contextPath}/admin/equipment/save" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${equipment.id}">
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="equipmentName" class="required">设备名称</label>
                        <input class="form-control" type="text" id="equipmentName" name="equipmentName" 
                               value="${equipment.equipmentName}" required placeholder="请输入设备名称">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="equipmentCode" class="required">设备编码</label>
                        <input class="form-control" type="text" id="equipmentCode" name="equipmentCode" 
                               value="${equipment.equipmentCode}" required placeholder="请输入设备编码（唯一）">
                        <small class="help-text">设备编码必须唯一，用于标识设备</small>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="model">型号</label>
                        <input class="form-control" type="text" id="model" name="model" 
                               value="${equipment.model}" placeholder="请输入设备型号">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="type">设备类型</label>
                        <input class="form-control" type="text" id="type" name="type" 
                               value="${equipment.type}" placeholder="如：示波器、电源、机械臂等">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="labId" class="required">所属实验室</label>
                        <c:choose>
                            <c:when test="${not empty labs}">
                                <select class="form-control" id="labId" name="labId" required>
                                    <option value="">-- 请选择实验室 --</option>
                                    <c:forEach var="lab" items="${labs}">
                                        <option value="${lab.id}" <c:if test="${equipment.labId == lab.id}">selected</c:if>>
                                            ${lab.labName} <c:if test="${not empty lab.location}">(${lab.location})</c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="help-text">选择设备所属的实验室</small>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning" role="alert" style="margin-bottom: 0.5rem;">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align: text-bottom; margin-right: 4px;">
                                        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                                    </svg>
                                    暂无可用实验室，请联系系统管理员创建实验室
                                </div>
                                <input class="form-control" type="number" id="labId" name="labId" 
                                       value="${equipment.labId}" required placeholder="请输入实验室ID">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="status" class="required">设备状态</label>
                        <select class="form-control" id="status" name="status" required>
                            <option value="AVAILABLE" <c:if test="${equipment.status==null || equipment.status=='AVAILABLE'}">selected</c:if>>可用</option>
                            <option value="MAINTAINING" <c:if test="${equipment.status=='MAINTAINING'}">selected</c:if>>维修中</option>
                            <option value="DISABLED" <c:if test="${equipment.status=='DISABLED'}">selected</c:if>>停用</option>
                            <option value="RESERVED" <c:if test="${equipment.status=='RESERVED'}">selected</c:if>>已预约</option>
                            <option value="IN_USE" <c:if test="${equipment.status=='IN_USE'}">selected</c:if>>使用中</option>
                            <option value="SCRAPPED" <c:if test="${equipment.status=='SCRAPPED'}">selected</c:if>>已报废</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="image">设备图片</label>
                <input class="form-control" type="file" id="image" name="image" 
                       accept="image/jpeg,image/jpg,image/png,image/gif">
                <small class="help-text">支持格式：JPG、PNG、GIF，文件大小不超过10MB</small>
                <c:if test="${not empty equipment.imagePath}">
                    <div style="margin-top: 1rem;">
                        <p class="text-muted mb-2">当前图片：</p>
                        <img src="${pageContext.request.contextPath}${equipment.imagePath}" alt="设备图片" 
                             style="max-width: 400px; border: 1px solid #dee2e6; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                    </div>
                </c:if>
            </div>

            <div class="form-group">
                <label for="usageNotice">使用须知</label>
                <textarea class="form-control" id="usageNotice" name="usageNotice" rows="6" 
                          placeholder="请输入设备使用须知、注意事项等">${equipment.usageNotice}</textarea>
                <small class="help-text">详细说明设备的使用方法、注意事项等</small>
            </div>

            <!-- 按钮组 -->
            <div class="form-actions">
                <div></div>
                <div style="display: flex; gap: 1rem;">
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/equipment">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
                        </svg>
                        返回列表
                    </a>
                    <button class="btn btn-primary" type="submit">
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

<%@ include file="/WEB-INF/jsp/common/_footer.jspf" %>
