package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ParkingEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.ParkingDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.ReservationDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.SpotDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.GroupedSpotsDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.ParkingAndSpotsResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SpaceStatusUpdateDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SpotResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.ParkingSpotsUsageStats;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.SpotUsageStatsResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ParkingBl {
    private static final Logger LOG = LoggerFactory.getLogger(ParkingBl.class);
    private final ParkingDao parkingDao;
    private final SpotDao spotDao;
    private final ReservationDao reservationDao;

    public ParkingBl(ParkingDao parkingDao, SpotDao spotDao, ReservationDao reservationDao) {
        this.parkingDao = parkingDao;
        this.spotDao = spotDao;
        this.reservationDao = reservationDao;
    }

    public GroupedSpotsDto getSpotsGrouped(Long parkingId) {
        LOG.info("Obteniendo spots para el parking ID: {}", parkingId);

        // Ejecutar consulta para obtener los primeros 10 spots y limitar los resultados
        List<SpotEntity> leftEntities = spotDao.findFirst10ByParkingId(parkingId)
                .stream().limit(10)
                .collect(Collectors.toList());
        LOG.info("Left Spot Entities (primeros 10): {}", leftEntities);

        // Ejecutar consulta para obtener los siguientes 6 spots y limitar los resultados
        List<SpotEntity> rightEntities = spotDao.findNext6ByParkingId(parkingId)
                .stream().skip(10).limit(6)
                .collect(Collectors.toList());
        LOG.info("Right Spot Entities (siguientes 6): {}", rightEntities);

        List<SpotResponseDto> leftSpots = leftEntities.stream()
                .map(this::mapToSpotResponseDto)
                .collect(Collectors.toList());

        List<SpotResponseDto> rightSpots = rightEntities.stream()
                .map(this::mapToSpotResponseDto)
                .collect(Collectors.toList());

        return new GroupedSpotsDto(leftSpots, rightSpots);
    }


    public List<ParkingAndSpotsResponseDto> getAllParkingsWithSpots() {
        List<ParkingEntity> parkingEntities = parkingDao.findAll();
        return parkingEntities.stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    public List<SpotResponseDto> getSpotsByParkingId(Long parkingId) {
        List<SpotEntity> spotEntities = spotDao.findByParkingEntity_IdParOrderBySpotNumberAsc(parkingId);
        return spotEntities.stream()
                .map(this::mapToSpotResponseDto)
                .collect(Collectors.toList());
    }

    public void updateSpaceStatus(SpaceStatusUpdateDto spaceStatusUpdateDto) {
        SpotEntity spotEntity = spotDao.findById(spaceStatusUpdateDto.getSpaceId())
                .orElseThrow(() -> new RuntimeException("Spot not found"));

        // If the spot is being occupied, record the entry time
        if (spaceStatusUpdateDto.getStatus() == 0) { // "ocupado"
            Optional<ReservationEntity> reservationEntityOptional = reservationDao.findBySpotEntityAndStatus(spotEntity, "CONFIRMED");
            if (reservationEntityOptional.isPresent()) {
                ReservationEntity reservationEntity = reservationEntityOptional.get();
                reservationEntity.setActualEntry(LocalDateTime.now());
                reservationEntity.setStatus("IN_USE");
                reservationDao.save(reservationEntity);
            }
        }
        // If the spot is becoming available, record the exit time
        else if (spaceStatusUpdateDto.getStatus() == 1) { // "disponible"
            Optional<ReservationEntity> reservationEntityOptional = reservationDao.findBySpotEntityAndStatus(spotEntity, "IN_USE");
            if (reservationEntityOptional.isPresent()) {
                ReservationEntity reservationEntity = reservationEntityOptional.get();
                reservationEntity.setActualExit(LocalDateTime.now());
                reservationEntity.setStatus("COMPLETED");
                reservationDao.save(reservationEntity);
            }
        }

        spotEntity.setStatus(spaceStatusUpdateDto.getStatus());
        spotDao.save(spotEntity);
    }

    private ParkingAndSpotsResponseDto mapToDto(ParkingEntity parkingEntity) {
        List<SpotEntity> spotEntities = spotDao.findByParkingEntity_IdParOrderBySpotNumberAsc(parkingEntity.getIdPar());
        List<ParkingAndSpotsResponseDto.SpotDto> spots = spotEntities.stream()
                .map(this::mapToSpotDto)
                .collect(Collectors.toList());

        return ParkingAndSpotsResponseDto.builder()
                .idPar(parkingEntity.getIdPar())
                .name(parkingEntity.getName())
                .location(parkingEntity.getLocation())
                .totalSpots(parkingEntity.getTotalSpots())
                .createdAt(parkingEntity.getCreatedAt())
                .updatedAt(parkingEntity.getUpdatedAt())
                .spots(spots)
                .build();
    }

    private ParkingAndSpotsResponseDto.SpotDto mapToSpotDto(SpotEntity spotEntity) {
        return ParkingAndSpotsResponseDto.SpotDto.builder()
                .idSpots(spotEntity.getIdSpots())
                .spotNumber(spotEntity.getSpotNumber())
                .status(spotEntity.getStatus())
                .createdAt(spotEntity.getCreatedAt())
                .updatedAt(spotEntity.getUpdatedAt())
                .build();
    }

    private SpotResponseDto mapToSpotResponseDto(SpotEntity spotEntity) {
        return SpotResponseDto.builder()
                .idSpots(spotEntity.getIdSpots())
                .parkingId(spotEntity.getParkingEntity().getIdPar())
                .spotNumber(spotEntity.getSpotNumber())
                .status(spotEntity.getStatus())
                .updatedAt(spotEntity.getUpdatedAt())
                .build();
    }



    public SpotUsageStatsResponse getSpotUsageStats(int spotId) {
        List<ReservationEntity> reservations = reservationDao.findBySpotEntity_IdSpots(spotId);
        SpotUsageStatsResponse stats = new SpotUsageStatsResponse();
        stats.setTotalReservations(reservations.size());
        stats.setTotalHoursOccupied(calculateTotalHoursOccupied(reservations));
        return stats;
    }

    private double calculateTotalHoursOccupied(List<ReservationEntity> reservations) {
        double totalHours = 0;
        for (ReservationEntity reservation : reservations) {
            if (reservation.getActualEntry() != null && reservation.getActualExit() != null) {
                long diffInMillies = Math.abs(reservation.getActualExit().getHour() - reservation.getActualEntry().getHour());
                double diffInHours = diffInMillies / (1000.0 * 60 * 60);
                totalHours += diffInHours;
            }
        }
        return totalHours;
    }
    public List<ParkingSpotsUsageStats> getAllSpotsUsageStats() {
        List<ParkingEntity> parkings = parkingDao.findAll();
        return parkings.stream().map(this::mapToParkingSpotsUsageStats).collect(Collectors.toList());
    }

    private ParkingSpotsUsageStats mapToParkingSpotsUsageStats(ParkingEntity parking) {
        List<SpotEntity> spots = spotDao.findByParkingEntity_IdParOrderBySpotNumberAsc(parking.getIdPar());
        List<SpotUsageStatsResponse> spotUsageStats = spots.stream().map(this::mapToSpotUsageStats).collect(Collectors.toList());

        ParkingSpotsUsageStats stats = new ParkingSpotsUsageStats();
        stats.setParkingId(parking.getIdPar());
        stats.setParkingName(parking.getName());
        stats.setSpotUsageStats(spotUsageStats);

        return stats;
    }

    private SpotUsageStatsResponse mapToSpotUsageStats(SpotEntity spot) {
        List<ReservationEntity> reservations = reservationDao.findBySpotEntity_IdSpots(spot.getIdSpots());
        SpotUsageStatsResponse stats = new SpotUsageStatsResponse();
        stats.setTotalReservations(reservations.size());
        stats.setTotalHoursOccupied(calculateTotalHoursOccupied(reservations));
        return stats;
    }

}
