package com.labbooking.ssm.service;

import com.github.pagehelper.PageInfo;
import com.labbooking.ssm.domain.LabBooking;

import java.time.LocalDateTime;

public interface BookingService {
    LabBooking submit(Long userId, Long equipmentId, LocalDateTime start, LocalDateTime end, String purpose);
    boolean approve(Long bookingId, Long approverId, boolean pass, String comment);
    boolean finish(Long bookingId);
    int finishBatchEnded();
    boolean cancel(Long bookingId, Long userId);

    PageInfo<LabBooking> myBookings(Long userId, String status, int pageNum, int pageSize);
    PageInfo<LabBooking> pendingList(int pageNum, int pageSize);
    PageInfo<LabBooking> pendingListFiltered(Long managerId, Long labId, int pageNum, int pageSize);
    LabBooking getById(Long id);
}


