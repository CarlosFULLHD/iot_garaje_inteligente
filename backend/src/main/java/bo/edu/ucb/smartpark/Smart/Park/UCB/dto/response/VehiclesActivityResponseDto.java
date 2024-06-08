package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class VehiclesActivityResponseDto {
    private Long idVehicles;
    private String licensePlate;
    private String carBranch;
    private String carModel;
    private String carColor;
    private String carManufacturingDate;
    private int totalReservations;
    private double totalHoursUsed;
}
