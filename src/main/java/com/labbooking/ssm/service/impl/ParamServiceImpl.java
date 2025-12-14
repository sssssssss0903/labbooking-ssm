package com.labbooking.ssm.service.impl;

import com.labbooking.ssm.domain.SysParam;
import com.labbooking.ssm.mapper.SysParamMapper;
import com.labbooking.ssm.service.ParamService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Optional;

@Service
public class ParamServiceImpl implements ParamService {

    @Resource
    private SysParamMapper sysParamMapper;

    @Value("${booking.defaultMinutes:60}")
    private Integer defaultMinutesProp;
    @Value("${booking.maxAdvanceDays:14}")
    private Integer maxAdvanceDaysProp;

    @Override
    public String getString(String key, String fallback) {
        SysParam p = sysParamMapper.selectByKey(key);
        if (p != null && p.getParamValue() != null) return p.getParamValue();
        return fallback;
    }

    @Override
    public int getInt(String key, int fallback) {
        SysParam p = sysParamMapper.selectByKey(key);
        if (p != null) {
            try {
                return Integer.parseInt(p.getParamValue());
            } catch (Exception ignore) {}
        }
        // fallback to application.properties defaults for known keys
        if ("booking.defaultMinutes".equals(key)) return Optional.ofNullable(defaultMinutesProp).orElse(fallback);
        if ("booking.maxAdvanceDays".equals(key)) return Optional.ofNullable(maxAdvanceDaysProp).orElse(fallback);
        return fallback;
    }

    @Override
    public void set(String key, String value, String remark) {
        sysParamMapper.upsert(key, value, remark);
    }

    @Override
    public List<SysParam> listAll() {
        return sysParamMapper.selectAll();
    }
}



