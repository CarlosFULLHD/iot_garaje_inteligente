package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;

import lombok.*;

@Getter
@Setter
public class ParkingResponse {
    private Long idPar;
    private String name;
    private String location;
    private int totalSpots;
}
