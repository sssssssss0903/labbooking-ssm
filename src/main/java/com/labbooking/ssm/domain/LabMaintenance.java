package com.labbooking.ssm.domain;

import java.io.Serializable;
import java.time.LocalDateTime;

public class LabMaintenance implements Serializable {
    private Long id;
    private Long equipmentId;
    private Long reportUserId;
    private String description;
    private String status; // REPORTED/IN_PROGRESS/DONE
    private LocalDateTime createTime;
    private LocalDateTime completeTime;
    private Long handlerId;
    private String result;
    private LocalDateTime updateTime;
    // 关联字段
    private String equipmentName;
    private String equipmentCode;
    private String reportUserName;
    private String handlerName;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getEquipmentId() { return equipmentId; }
    public void setEquipmentId(Long equipmentId) { this.equipmentId = equipmentId; }
    public Long getReportUserId() { return reportUserId; }
    public void setReportUserId(Long reportUserId) { this.reportUserId = reportUserId; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    public LocalDateTime getCompleteTime() { return completeTime; }
    public void setCompleteTime(LocalDateTime completeTime) { this.completeTime = completeTime; }
    public Long getHandlerId() { return handlerId; }
    public void setHandlerId(Long handlerId) { this.handlerId = handlerId; }
    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }
    public LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(LocalDateTime updateTime) { this.updateTime = updateTime; }
    public String getEquipmentName() { return equipmentName; }
    public void setEquipmentName(String equipmentName) { this.equipmentName = equipmentName; }
    public String getEquipmentCode() { return equipmentCode; }
    public void setEquipmentCode(String equipmentCode) { this.equipmentCode = equipmentCode; }
    public String getReportUserName() { return reportUserName; }
    public void setReportUserName(String reportUserName) { this.reportUserName = reportUserName; }
    public String getHandlerName() { return handlerName; }
    public void setHandlerName(String handlerName) { this.handlerName = handlerName; }
}



