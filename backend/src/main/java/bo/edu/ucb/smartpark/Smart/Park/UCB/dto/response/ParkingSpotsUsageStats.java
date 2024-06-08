package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
public class ParkingSpotsUsageStats {
    private Long parkingId;
    private String parkingName;
    private List<SpotUsageStatsResponse> spotUsageStats;

}





