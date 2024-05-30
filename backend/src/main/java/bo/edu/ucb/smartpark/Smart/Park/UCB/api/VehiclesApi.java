package bo.edu.ucb.smartpark.Smart.Park.UCB.api;

import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.VehiclesBl;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterVehicleRequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
@RestController
@RequestMapping(Globals.apiVersion + "vehicles")
public class VehiclesApi {

    private final VehiclesBl vehiclesBl;

    private static final Logger LOG = LoggerFactory.getLogger(VehiclesApi.class);

    public VehiclesApi(VehiclesBl vehiclesBl) {
        this.vehiclesBl = vehiclesBl;
    }

    @PostMapping("/register")
    public ResponseEntity<Object> registerVehicle(@RequestBody RegisterVehicleRequest request){
        LOG.info("Registrando nuevo vehículo con placa: {}", request.getLicensePlate());
        Object response = vehiclesBl.registerVehicle(request);
        return ResponseEntity.status(response instanceof SuccessfulResponse ? HttpStatus.CREATED : HttpStatus.BAD_REQUEST).body(response);
    }
}