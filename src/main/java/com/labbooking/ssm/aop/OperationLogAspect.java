package com.labbooking.ssm.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class OperationLogAspect {
    private static final Logger log = LoggerFactory.getLogger(OperationLogAspect.class);

    @AfterReturning("execution(* com.labbooking.ssm.controller.AuthController.doLogin(..))")
    public void afterLogin(JoinPoint jp) {
        log.info("User login processed");
    }

    @AfterReturning("execution(* com.labbooking.ssm.controller.BookingController.approve(..))")
    public void afterApprove(JoinPoint jp) {
        log.info("Booking approval processed");
    }

    @AfterReturning("execution(* com.labbooking.ssm.controller.MaintenanceController.*(..))")
    public void afterMaintenanceOps(JoinPoint jp) {
        log.info("Maintenance operation: {}", jp.getSignature().getName());
    }

    @AfterReturning("execution(* com.labbooking.ssm.controller.EquipmentAdminController.save(..))")
    public void afterEquipmentSave(JoinPoint jp) {
        log.info("Equipment create/update processed");
    }
}



