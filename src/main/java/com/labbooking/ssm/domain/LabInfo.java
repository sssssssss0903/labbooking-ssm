package com.labbooking.ssm.domain;

import java.io.Serializable;

public class LabInfo implements Serializable {
    private Long id;
    private String labName;
    private String location;
    private Long managerId;
    private String description;
    private String status;
    // 关联字段
    private String managerName;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getLabName() { return labName; }
    public void setLabName(String labName) { this.labName = labName; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public Long getManagerId() { return managerId; }
    public void setManagerId(Long managerId) { this.managerId = managerId; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }
}



