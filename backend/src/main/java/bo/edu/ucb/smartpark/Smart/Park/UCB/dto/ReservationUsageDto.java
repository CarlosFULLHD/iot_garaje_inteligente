package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReservationUsageDto {
    private Long totalReservations;
    private Long unutilizedReservations;
    private Double lateExitsPercentage;
}
