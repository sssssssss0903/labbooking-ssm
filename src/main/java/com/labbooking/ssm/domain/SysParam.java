package com.labbooking.ssm.domain;

import java.io.Serializable;

public class SysParam implements Serializable {
    private Long id;
    private String paramKey;
    private String paramValue;
    private String remark;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getParamKey() { return paramKey; }
    public void setParamKey(String paramKey) { this.paramKey = paramKey; }
    public String getParamValue() { return paramValue; }
    public void setParamValue(String paramValue) { this.paramValue = paramValue; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}



