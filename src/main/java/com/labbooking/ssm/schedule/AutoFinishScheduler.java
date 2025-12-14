package com.labbooking.ssm.schedule;

import com.labbooking.ssm.service.BookingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Component
public class AutoFinishScheduler {
    private static final Logger log = LoggerFactory.getLogger(AutoFinishScheduler.class);

    @Resource
    private BookingService bookingService;

    // 每5分钟执行一次，将到期的预约置为 FINISHED 并写入使用记录
    @Scheduled(fixedDelay = 300000L, initialDelay = 120000L)
    public void finishExpiredBookings() {
        try {
            int n = bookingService.finishBatchEnded();
            if (n > 0) {
                log.info("Auto finished {} bookings that have ended.", n);
            }
        } catch (Exception e) {
            log.error("Auto finish job failed", e);
        }
    }
}




