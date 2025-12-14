package com.labbooking.ssm.mapper;

import com.labbooking.ssm.domain.LabBooking;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface LabBookingMapper {
    int insert(LabBooking booking);
    LabBooking selectById(@Param("id") Long id);

    int countConflict(@Param("equipmentId") Long equipmentId,
                      @Param("startTime") LocalDateTime startTime,
                      @Param("endTime") LocalDateTime endTime,
                      @Param("excludeId") Long excludeId);

    List<LabBooking> listByUser(@Param("userId") Long userId,
                                @Param("status") String status);

    List<LabBooking> listPending();
    List<LabBooking> listPendingFiltered(@Param("managerId") Long managerId,
                                         @Param("labId") Long labId);
    List<LabBooking> listFinishedByUser(@Param("userId") Long userId);

    int approve(@Param("id") Long id,
                @Param("approverId") Long approverId,
                @Param("approveTime") LocalDateTime approveTime,
                @Param("status") String status,
                @Param("approveComment") String approveComment);

    int updateStatus(@Param("id") Long id, @Param("status") String status);

    int finishIfEnded(@Param("now") LocalDateTime now);
    java.util.List<com.labbooking.ssm.domain.LabBooking> listEndedApproved(@Param("now") LocalDateTime now);
}


