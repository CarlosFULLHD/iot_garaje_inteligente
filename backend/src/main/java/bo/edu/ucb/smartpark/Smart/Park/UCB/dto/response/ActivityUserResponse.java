package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ActivityUserResponse {
    private Long idReservation;
    private Long userId;
    private Long vehicleId;
    private Long spotId;
    private LocalDateTime scheduledEntry;
    private LocalDateTime scheduledExit;
    private LocalDateTime actualEntry;
    private LocalDateTime actualExit;
    private String status;
}
