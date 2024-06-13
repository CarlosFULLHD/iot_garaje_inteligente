package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
public class SpotUsageStatsResponse {
    private int totalReservations;
    private double totalHoursOccupied;
}
