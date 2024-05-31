package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ParkingEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ParkingAndSpotsResponseDto {
    private Long idPar;
    private String name;
    private String location;
    private int totalSpots;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<SpotDto> spots;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class SpotDto {
        private Long idSpots;
        private int spotNumber;
        private int status; // 1 for available, 0 for occupied, 2 for reserved
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }
    public ParkingAndSpotsResponseDto ParkingAndSpotsResponseDtoToResponse(ParkingEntity entity){
        ParkingAndSpotsResponseDto responseDto = new ParkingAndSpotsResponseDto();
        responseDto.setIdPar(entity.getIdPar());
        responseDto.setName(entity.getName());
        responseDto.setLocation(entity.getLocation());
        responseDto.setTotalSpots(entity.getTotalSpots());
        responseDto.setCreatedAt(entity.getCreatedAt());
        responseDto.setUpdatedAt(entity.getUpdatedAt());
        return responseDto;

    }

}
