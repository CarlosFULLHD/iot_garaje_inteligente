package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ParkingEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.SpotEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.ParkingDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.SpotDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.ParkingAndSpotsResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SpotResponseDto;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ParkingBl {
    private static final Logger LOG = LoggerFactory.getLogger(ParkingBl.class);
    private final ParkingDao parkingDao;
    private final SpotDao spotDao;

    public ParkingBl(ParkingDao parkingDao, SpotDao spotDao) {
        this.parkingDao = parkingDao;
        this.spotDao = spotDao;
    }

    public List<ParkingAndSpotsResponseDto> getAllParkingsWithSpots() {
        List<ParkingEntity> parkingEntities = parkingDao.findAll();
        return parkingEntities.stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    public List<SpotResponseDto> getSpotsByParkingId(Long parkingId) {
        List<SpotEntity> spotEntities = spotDao.findByParkingEntity_IdPar(parkingId);
        return spotEntities.stream()
                .map(this::mapToSpotResponseDto)
                .collect(Collectors.toList());
    }

    private ParkingAndSpotsResponseDto mapToDto(ParkingEntity parkingEntity) {
        List<SpotEntity> spotEntities = spotDao.findByParkingEntity_IdPar(parkingEntity.getIdPar());
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
}
