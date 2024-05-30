package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class RegisterVehicleRequest {

    @NotBlank (message = "vehicle branch is mandatory")
    private String carBranch;

    @NotBlank (message = "vehicle model is mandatory")
    private String carModel;

    @NotBlank (message = "vehicle color is mandatory")
    private String carColor;

    @NotBlank (message = "vehicle manufacturing date is mandatory")
    private String carManufacturingDate;

    @NotBlank (message = "license plate is mandatory")
    private String licensePlate;

    @NotBlank (message = "user id is mandatory")
    private Integer idUsers;
}
