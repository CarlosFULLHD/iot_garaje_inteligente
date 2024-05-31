package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Duration;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EntryExitDifferenceDto {
    private Long reservationId;
    private Duration entryDifference;
    private Duration exitDifference;
}
