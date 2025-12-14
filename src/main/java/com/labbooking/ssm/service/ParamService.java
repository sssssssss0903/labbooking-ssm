package com.labbooking.ssm.service;

public interface ParamService {
    String getString(String key, String fallback);
    int getInt(String key, int fallback);
    void set(String key, String value, String remark);
    java.util.List<com.labbooking.ssm.domain.SysParam> listAll();
}



