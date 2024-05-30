package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.ReservationDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.SpotDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.UserDao;

import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.VehiclesDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.ReservationRequestDto;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ReservationBl {
    private static final Logger LOG = LoggerFactory.getLogger(ReservationBl.class);
    private final ReservationDao reservationDao;
    private final UserDao userDao;
    private final VehiclesDao vehiclesDao;
    private final SpotDao spotDao;

    public void createReservation(ReservationRequestDto reservationRequestDto) {
        UserEntity userEntity = userDao.findById(reservationRequestDto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        VehicleEntity vehicleEntity = vehiclesDao.findById(reservationRequestDto.getVehicleId())
                .orElseThrow(() -> new RuntimeException("Vehicle not found"));

        SpotEntity spotEntity = spotDao.findById(reservationRequestDto.getSpotId())
                .orElseThrow(() -> new RuntimeException("Spot not found"));

        ReservationEntity reservationEntity = ReservationEntity.builder()
                .userEntity(userEntity)
                .vehicleEntity(vehicleEntity)
                .spotEntity(spotEntity)
                .scheduledEntry(reservationRequestDto.getScheduledEntry())
                .scheduledExit(reservationRequestDto.getScheduledExit())
                .status("CONFIRMED")
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        reservationDao.save(reservationEntity);
    }
}
