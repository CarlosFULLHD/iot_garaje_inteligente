package grado.ucb.edu.back_end_grado.dto.request;

import jakarta.validation.constraints.NotBlank;

public record AuthLoginrequest(@NotBlank String username,
                               @NotBlank String password) {
}
