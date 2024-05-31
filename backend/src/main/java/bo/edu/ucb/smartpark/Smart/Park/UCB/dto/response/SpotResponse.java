package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;
import lombok.*;

@Getter
@Setter
public class SpotResponse {
    private Long idSpots;
    private Long parkingId;
    private int spotNumber;
    private int status;
}
