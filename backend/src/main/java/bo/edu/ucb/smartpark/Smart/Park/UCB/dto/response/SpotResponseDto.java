package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SpotResponseDto {
    private Long idSpots;
    private Long parkingId;
    private int spotNumber;
    private int status; // 1 for available, 0 for occupied, 2 for reserved
    private LocalDateTime updatedAt;
}
