package bo.edu.ucb.smartpark.Smart.Park.UCB.api;

import bo.edu.ucb.smartpark.Smart.Park.UCB.bl.VehiclesBl;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UsersAndVehiclesResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterVehicleRequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.VehicleUsageStatsResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.VehiclesResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

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

    @GetMapping
    public ResponseEntity<List<UsersAndVehiclesResponseDto>> getAllVehicles(){
        LOG.info("Obteniendo todos los vehículos");
        List<UsersAndVehiclesResponseDto> response = vehiclesBl.getAllVehicles();
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{userId}/vehicles")
    public ResponseEntity<List<VehiclesResponseDto>> getVehiclesByUserId(@PathVariable Long userId){
        LOG.info("Obteniendo vehículos del usuario con id: {}", userId);
        List<VehiclesResponseDto> response = vehiclesBl.getVehiclesByUserId(userId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{vehicleId}/stats")
    public ResponseEntity<VehicleUsageStatsResponse> getVehicleUsageStats(@PathVariable int vehicleId) {
        LOG.info("Obteniendo estadísticas de uso para el vehículo con ID: {}", vehicleId);
        VehicleUsageStatsResponse stats = vehiclesBl.getVehicleUsageStats(vehicleId);
        return ResponseEntity.ok(stats);
    }

}
