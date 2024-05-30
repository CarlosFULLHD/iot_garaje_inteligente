package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;

@Getter
public class RegisterUserRequest {
    @NotBlank(message = "Name is mandatory")
    private String name;

    @NotBlank(message = "Last name is mandatory")
    private String lastName;

    @NotBlank(message = "Email is mandatory")
    @Email(message = "Email should be valid")
    private String email;

    @NotBlank(message = "Password is mandatory")
    @Size(min = 5, message = "Password should be at least 8 characters long")
    private String password;

    @NotBlank(message = "PIN code is mandatory")
    @Size(min = 4, max = 8, message = "PIN code should be 4 characters long")
    private String pinCode;

    @NotBlank(message = "License plate is mandatory")
    private String licensePlate;

    @NotBlank(message = "Vehicle brand is mandatory")
    private String carBranch;

    @NotBlank(message = "Vehicle model is mandatory")
    private String carModel;

    @NotBlank(message = "Vehicle color is mandatory")
    private String carColor;

    @NotBlank(message = "Vehicle manufacturing date is mandatory")
    private String carManufacturingDate;

    // Getters and Setters
}
