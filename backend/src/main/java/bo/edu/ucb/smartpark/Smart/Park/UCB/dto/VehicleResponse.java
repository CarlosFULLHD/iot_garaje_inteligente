package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VehicleResponse {
    private Long idVehicles;
    private Long userId;
    private String licensePlate;
    private String carBranch;
    private String carModel;
    private String carColor;
    private String carManufacturingDate;
    private String createdAt;
    private String updatedAt;
}
