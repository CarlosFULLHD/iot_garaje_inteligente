package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VehiclesResponseDto {

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
