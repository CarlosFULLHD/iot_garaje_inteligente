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
public class ReservationRequestDto {
    private Long userId;
    private Long vehicleId;
    private Long spotId;
    private LocalDateTime scheduledEntry;
    private LocalDateTime scheduledExit;
}
