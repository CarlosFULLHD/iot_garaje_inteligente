package bo.edu.ucb.smartpark.Smart.Park.UCB.api;

import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.UsersBl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UnsuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterUserRequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;

import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(Globals.apiVersion + "users")
//API - Usuarios
//Endpoint para la creación de usuarios e ingreso al sistema
public class UsersApi {

    private final UsersBl usersBl;
    private static final Logger LOG = LoggerFactory.getLogger(UsersApi.class);

    public UsersApi(UsersBl usersBl) {
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
}
