package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.ReservationDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.SpotDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.UserDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.VehiclesDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.ReservationDetailsDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.ReservationRequestDto;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReservationBl {
    private static final Logger LOG = LoggerFactory.getLogger(ReservationBl.class);
    private final ReservationDao reservationDao;
    private final UserDao userDao;
    private final VehiclesDao vehiclesDao;
    private final SpotDao spotDao;

    public ReservationDetailsDto getReservationDetails(Long reservationId) {
        ReservationEntity reservationEntity = reservationDao.findById(reservationId)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));

        return ReservationDetailsDto.builder()
                .idRes(reservationEntity.getIdRes())
                .userId(reservationEntity.getUserEntity().getIdUsers())
                .vehicleId(reservationEntity.getVehicleEntity().getIdVehicles())
                .spotId(reservationEntity.getSpotEntity().getIdSpots())
                .scheduledEntry(reservationEntity.getScheduledEntry())
                .scheduledExit(reservationEntity.getScheduledExit())
                .status(reservationEntity.getStatus())
                .createdAt(reservationEntity.getCreatedAt())
                .updatedAt(reservationEntity.getUpdatedAt())
                .build();
    }

    public void cancelReservation(Long reservationId) {
        ReservationEntity reservationEntity = reservationDao.findById(reservationId)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));
        reservationDao.delete(reservationEntity);
    }

    public List<ReservationDetailsDto> getUserReservations(Long userId) {
        List<ReservationEntity> reservations = reservationDao.findByUserEntity_IdUsers(userId);
        return reservations.stream()
                .map(this::mapToReservationDetailsDto)
                .collect(Collectors.toList());
    }



    public void createReservation(ReservationRequestDto reservationRequestDto) {
        UserEntity userEntity = userDao.findById(reservationRequestDto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        VehicleEntity vehicleEntity = vehiclesDao.findById(reservationRequestDto.getVehicleId())
                .orElseThrow(() -> new RuntimeException("Vehicle not found"));

        SpotEntity spotEntity = spotDao.findById(reservationRequestDto.getSpotId())
                .orElseThrow(() -> new RuntimeException("Spot not found"));

        // Actualizar el estado del spot a reservado
        spotEntity.setStatus(2);
        spotDao.save(spotEntity);

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
    private ReservationDetailsDto mapToReservationDetailsDto(ReservationEntity reservationEntity) {
        return ReservationDetailsDto.builder()
                .idRes(reservationEntity.getIdRes())
                .userId(reservationEntity.getUserEntity().getIdUsers())
                .vehicleId(reservationEntity.getVehicleEntity().getIdVehicles())
                .spotId(reservationEntity.getSpotEntity().getIdSpots())
                .scheduledEntry(reservationEntity.getScheduledEntry())
                .scheduledExit(reservationEntity.getScheduledExit())
                .status(reservationEntity.getStatus())
                .createdAt(reservationEntity.getCreatedAt())
                .updatedAt(reservationEntity.getUpdatedAt())
                .build();
    }


}
