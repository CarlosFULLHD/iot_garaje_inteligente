package bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;


public record AuthLoginrequest(@Getter @NotBlank String username,
                               @Getter @NotBlank String password) {
}
