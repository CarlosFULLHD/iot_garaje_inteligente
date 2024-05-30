package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.UserDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.VehiclesDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UnsuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterVehicleRequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class VehiclesBl {

    private final VehiclesDao vehiclesDao;
    private final UserDao userDao;

    private static final Logger LOG = LoggerFactory.getLogger(VehiclesBl.class);

    public VehiclesBl(VehiclesDao vehiclesDao, UserDao userDao) {
        this.vehiclesDao = vehiclesDao;
        this.userDao = userDao;
    }

    @Transactional
    public Object registerVehicle(RegisterVehicleRequest request) {
        try{
            LOG.info("Iniciando el registro del vehículo: {}", request.getLicensePlate());
            if(vehiclesDao.findByLicensePlate(request.getLicensePlate()).isPresent()){
                LOG.warn("La placa ya está en uso: {}", request.getLicensePlate());
                return new UnsuccessfulResponse(Globals.httpBadRequest[0], Globals.httpBadRequest[1], "License plate is already in use");
            }

            VehicleEntity vehicleEntity = new VehicleEntity();

            vehicleEntity.setLicensePlate(request.getLicensePlate());
            vehicleEntity.setCarBranch(request.getCarBranch());
            vehicleEntity.setCarModel(request.getCarModel());
            vehicleEntity.setCarColor(request.getCarColor());
            vehicleEntity.setCarManufacturingDate(request.getCarManufacturingDate());
            vehicleEntity.setCreatedAt(LocalDateTime.now());
            vehicleEntity.setUpdatedAt(LocalDateTime.now());
            vehicleEntity.setUserEntity(userDao.findById(Long.valueOf(request.getIdUsers())).get());

            // Guardar vehículo y obtener el ID generado
            vehicleEntity = vehiclesDao.save(vehicleEntity);
            LOG.info("Vehículo guardado con éxito: {}", vehicleEntity.getLicensePlate());
            LOG.info("ID del vehículo guardado: {}", vehicleEntity.getIdVehicles());

            // Asociar vehículo con usuario
//            UserEntity userEntity = new UserEntity();
//            vehicleEntity.setUserEntity(userEntity);
//

            // Guardar vehículo

            vehiclesDao.save(vehicleEntity);
            LOG.info("Vehículo guardado con éxito: {}", vehicleEntity.getLicensePlate());
            LOG.info("ID del vehículo guardado: {}", vehicleEntity.getIdVehicles());

            return new SuccessfulResponse(Globals.httpOkStatus[0], Globals.httpOkStatus[1], "Vehicle registered successfully");
        }catch (Exception e){
            LOG.error("Error al registrar el vehículo: {}", e.getMessage());
            return new UnsuccessfulResponse(Globals.httpInternalServerErrorStatus[0], Globals.httpInternalServerErrorStatus[1], "Internal server error");
        }
    }
}