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
    @Size(min = 8, message = "Password should be at least 8 characters long")
    private String password;

    @NotBlank(message = "PIN code is mandatory")
    @Size(min = 4, max = 4, message = "PIN code should be 4 characters long")
    private String pinCode;

    @NotBlank(message = "License plate is mandatory")
    private String licensePlate;

    // Getters and Setters
}
