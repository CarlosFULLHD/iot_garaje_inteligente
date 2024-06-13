package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VehicleUsageStatsResponse {
    private int totalReservations;
    private double totalHoursUsed;
}
