package bo.edu.ucb.smartpark.Smart.Park.UCB.api;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.UserDetailServiceImpl;
import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.UsersBl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UnsuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.AuthLoginrequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterUserRequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.VerifyPinRequestDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.ActivityUserResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.AuthResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.VerifyPinResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(Globals.apiVersion + "users")
//API - Usuarios
//Endpoint para la creación de usuarios e ingreso al sistema
public class UsersApi {
    private final UserDetailServiceImpl userDetailServiceImpl;
    private final UsersBl usersBl;
    private static final Logger LOG = LoggerFactory.getLogger(UsersApi.class);

    public UsersApi(UserDetailServiceImpl userDetailServiceImpl, UsersBl usersBl) {
        this.userDetailServiceImpl = userDetailServiceImpl;
        this.usersBl = usersBl;
    }

    //Registrar un nuevo usuario
    //Registrar un nuevo usuario con sus datos y su vehículo
    @PostMapping("/register")
    public ResponseEntity<Object> registerUser(@Valid @RequestBody RegisterUserRequest request) {
        LOG.info("Registrando nuevo usuario con email: {}", request.getEmail());
        Object response = usersBl.registerUser(request);
        return ResponseEntity.status(response instanceof SuccessfulResponse ? HttpStatus.CREATED : HttpStatus.BAD_REQUEST).body(response);
    }
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> loginUser(@RequestBody AuthLoginrequest request, HttpServletResponse response) {
        LOG.info("Intentando login para usuario: {}", request.getUsername());
        AuthResponse authResponse = userDetailServiceImpl.loginUser(request, response);
        return ResponseEntity.ok(authResponse);
    }
    @PostMapping("/assign-admin-role")
    public ResponseEntity<Object> assignAdminRole(@RequestParam String email) {
        LOG.info("Asignando rol ADMIN al usuario con email: {}", email);
        Object response = usersBl.assignAdminRole(email);
        return ResponseEntity.status(response instanceof SuccessfulResponse ? HttpStatus.OK : HttpStatus.BAD_REQUEST).body(response);
    }
    @PostMapping("/verify-pin")
    public ResponseEntity<VerifyPinResponseDto> verifyPin(@RequestBody VerifyPinRequestDto verifyPinRequestDto) {
        boolean isValid = usersBl.verifyPin(verifyPinRequestDto.getPin());
        return ResponseEntity.ok(new VerifyPinResponseDto(isValid));
    }
    // Obtener la actividad del usuario
    @GetMapping("/activity/{userId}")
    public ResponseEntity<List<ActivityUserResponse>> getUserActivity(@PathVariable int userId) {
        LOG.info("Obteniendo actividad para el usuario con ID: {}", userId);
        List<ActivityUserResponse> activity = usersBl.getUserActivity(userId);
        return ResponseEntity.ok(activity);
    }

}
