package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.ReservationEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.UserEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.VehicleEntity;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.ReservationDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.UserDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.VehiclesDao;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UnsuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UsersAndVehiclesResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterVehicleRequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.VehicleUsageStatsResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.VehiclesResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class VehiclesBl {

    private final VehiclesDao vehiclesDao;
    private final ReservationDao reservationDao;
    private final UserDao userDao;

    private static final Logger LOG = LoggerFactory.getLogger(VehiclesBl.class);

    public VehiclesBl(VehiclesDao vehiclesDao, ReservationDao reservationDao, UserDao userDao) {
        this.vehiclesDao = vehiclesDao;
        this.reservationDao = reservationDao;
        this.userDao = userDao;
    }

    public List<UsersAndVehiclesResponseDto> getAllVehicles(){
        List<VehicleEntity> vehicleEntities = vehiclesDao.findAll();
        return vehicleEntities.stream()
                .map(this::mapToDto)
                .collect(java.util.stream.Collectors.toList());

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
            UserEntity userEntity = new UserEntity();
            userEntity.setIdUsers(Long.valueOf(request.getIdUsers()));
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
            userEntity = userDao.findById(Long.valueOf(request.getIdUsers())).get();
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
    public List<VehiclesResponseDto>getVehiclesByUserId(Long userId){
        List<VehicleEntity> vehicleEntities = vehiclesDao.findByUserEntityIdUsers(userId);
        return vehicleEntities.stream()
                .map(this::mapToDtoResponseDto)
                .collect(java.util.stream.Collectors.toList());
    }
    private UsersAndVehiclesResponseDto mapToDto(VehicleEntity vehicleEntity){
        List<VehicleEntity> vehicleEntities = vehiclesDao.findByUserEntityIdUsers(vehicleEntity.getIdVehicles());
        List<UsersAndVehiclesResponseDto.VehiclesDto> vehicles = vehicleEntities.stream()
                .map(this::mapVehiclesDto)
                .toList();
        return  UsersAndVehiclesResponseDto.builder()
                .idUser(vehicleEntity.getUserEntity().getIdUsers())
                //.idUser(vehicleEntity.getUserEntity().getIdUsers())
                .name(vehicleEntity.getUserEntity().getName())
                .lastName(vehicleEntity.getUserEntity().getLastName())
                .carBranch(vehicleEntity.getCarBranch())
                .carModel(vehicleEntity.getCarModel())
                .carColor(vehicleEntity.getCarColor())
                .carManufacturingDate(vehicleEntity.getCarManufacturingDate())
                .build();
    }

    private UsersAndVehiclesResponseDto.VehiclesDto mapVehiclesDto(VehicleEntity vehicleEntity) {
        return UsersAndVehiclesResponseDto.VehiclesDto.builder()
                .idVehicles(vehicleEntity.getIdVehicles())
                .licensePlate(vehicleEntity.getLicensePlate())
                .carBranch(vehicleEntity.getCarBranch())
                .carModel(vehicleEntity.getCarModel())
                .carColor(vehicleEntity.getCarColor())
                .carManufacturingDate(vehicleEntity.getCarManufacturingDate())
                .build();
    }

    private VehiclesResponseDto mapToDtoResponseDto(VehicleEntity vehicleEntity){
        return VehiclesResponseDto.builder()
                .idVehicles(vehicleEntity.getIdVehicles())
                .licensePlate(vehicleEntity.getLicensePlate())
                .carBranch(vehicleEntity.getCarBranch())
                .carModel(vehicleEntity.getCarModel())
                .carColor(vehicleEntity.getCarColor())
                .carManufacturingDate(vehicleEntity.getCarManufacturingDate())
                .build();
    }

    public VehicleUsageStatsResponse getVehicleUsageStats(int vehicleId) {
        List<ReservationEntity> reservations = reservationDao.findByVehicleEntity_IdVehicles(vehicleId);
        VehicleUsageStatsResponse stats = new VehicleUsageStatsResponse();
        stats.setTotalReservations(reservations.size());
        stats.setTotalHoursUsed(calculateTotalHoursUsed(reservations));
        return stats;
    }

    private double calculateTotalHoursUsed(List<ReservationEntity> reservations) {
        double totalHours = 0;
        for (ReservationEntity reservation : reservations) {
            if (reservation.getActualEntry() != null && reservation.getActualExit() != null) {
                long diffInMillies = Math.abs(reservation.getActualExit().getHour() - reservation.getActualEntry().getHour());
                double diffInHours = diffInMillies / (1000.0 * 60 * 60);
                totalHours += diffInHours;
            }
        }
        return totalHours;
    }

}
