package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;

import bo.edu.ucb.smartpark.Smart.Park.UCB.Entity.*;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dao.*;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.SuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.UnsuccessfulResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.request.RegisterUserRequest;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.ActivityUserResponse;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.VehiclesActivityResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.dto.response.VehiclesResponseDto;
import bo.edu.ucb.smartpark.Smart.Park.UCB.util.Globals;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UsersBl {

    private final UserDao userDao;
    private final VehiclesDao vehiclesDao;
    private final RolesDao rolesDao;
    private final RolesHasUsersDao rolesHasUsersDao;
    private final PasswordEncoder passwordEncoder;
    private final ReservationDao reservationDao;
    private static final Logger LOG = LoggerFactory.getLogger(UsersBl.class);

    public UsersBl(UserDao userDao, VehiclesDao vehiclesDao, RolesDao rolesDao, RolesHasUsersDao rolesHasUsersDao, PasswordEncoder passwordEncoder, ReservationDao reservationDao) {
        this.userDao = userDao;
        this.vehiclesDao = vehiclesDao;
        this.rolesDao = rolesDao;
        this.rolesHasUsersDao = rolesHasUsersDao;
        this.passwordEncoder = passwordEncoder;
        this.reservationDao = reservationDao;
    }

    @Transactional
    public Object registerUser(RegisterUserRequest request) {
        try {
            LOG.info("Iniciando registro de usuario: {}", request.getEmail());
            if (userDao.findByEmail(request.getEmail()).isPresent()) {
                LOG.warn("El email ya está en uso: {}", request.getEmail());
                return new UnsuccessfulResponse(Globals.httpBadRequest[0], Globals.httpBadRequest[1], "Email is already in use");
            }

            // Crear nueva entidad de usuario
            UserEntity userEntity = new UserEntity();
            userEntity.setName(request.getName());
            userEntity.setLastName(request.getLastName());
            userEntity.setEmail(request.getEmail());
            userEntity.setPassword(passwordEncoder.encode(request.getPassword()));
            userEntity.setPinCode(request.getPinCode());
            userEntity.setCreatedAt(LocalDateTime.now());
            userEntity.setUpdatedAt(LocalDateTime.now());

            // Guardar usuario y obtener el ID generado
            userEntity = userDao.save(userEntity);
            LOG.info("Usuario guardado con éxito: {}", userEntity.getEmail());
            LOG.info("ID del usuario guardado: {}", userEntity.getIdUsers());

            // Asignar rol "USER" al nuevo usuario
            RoleEntity userRole = rolesDao.findByUserRole("USER")
                    .orElseThrow(() -> new IllegalStateException("Rol USER no encontrado"));

            RolesHasUsersEntity rolesHasUsersEntity = new RolesHasUsersEntity();
            rolesHasUsersEntity.setUserEntity(userEntity);
            rolesHasUsersEntity.setRoleEntity(userRole);
            rolesHasUsersEntity.setStatus((short) 1);
            rolesHasUsersEntity.setCreatedAt(LocalDateTime.now());
            rolesHasUsersDao.save(rolesHasUsersEntity);
            LOG.info("Rol USER asignado con éxito al usuario: {}", userEntity.getEmail());

            // Crear nueva entidad de vehículo
            VehicleEntity vehicleEntity = new VehicleEntity();
            vehicleEntity.setLicensePlate(request.getLicensePlate());
            vehicleEntity.setCarBranch(request.getCarBranch());
            vehicleEntity.setCarModel(request.getCarModel());
            vehicleEntity.setCarColor(request.getCarColor());
            vehicleEntity.setCarManufacturingDate(request.getCarManufacturingDate());
            vehicleEntity.setUserEntity(userEntity);
            vehicleEntity.setCreatedAt(LocalDateTime.now());
            vehicleEntity.setUpdatedAt(LocalDateTime.now());

            // Guardar vehículo
            vehiclesDao.save(vehicleEntity);
            LOG.info("Vehículo guardado con éxito para el usuario: {}", userEntity.getEmail());
            LOG.info("ID del usuario asociado al vehículo: {}", vehicleEntity.getUserEntity().getIdUsers());

            return new SuccessfulResponse(Globals.httpOkStatus[0], Globals.httpOkStatus[1], "User registered successfully");
        } catch (Exception e) {
            LOG.error("Error registrando usuario", e);
            return new UnsuccessfulResponse(Globals.httpInternalServerErrorStatus[0], Globals.httpInternalServerErrorStatus[1], "Error registering user");
        }
    }

    @Transactional
    public Object assignAdminRole(String email) {
        try {
            LOG.info("Asignando rol ADMIN al usuario: {}", email);
            Optional<UserEntity> userEntityOptional = userDao.findUsersEntityByEmail(email);
            if (userEntityOptional.isEmpty()) {
                LOG.warn("El usuario no se encontró: {}", email);
                return new UnsuccessfulResponse(Globals.httpBadRequest[0], Globals.httpBadRequest[1], "User not found");
            }

            UserEntity userEntity = userEntityOptional.get();

            Optional<RoleEntity> adminRole = rolesDao.findByUserRole("ADMIN");
            if (adminRole.isPresent()) {
                RolesHasUsersEntity rolesHasUsersEntity = new RolesHasUsersEntity();
                rolesHasUsersEntity.setUserEntity(userEntity);
                rolesHasUsersEntity.setRoleEntity(adminRole.get());
                rolesHasUsersEntity.setStatus((short) 1);
                rolesHasUsersEntity.setCreatedAt(LocalDateTime.now());
                rolesHasUsersDao.save(rolesHasUsersEntity);
                LOG.info("Rol ADMIN asignado con éxito al usuario: {}", userEntity.getEmail());
                return new SuccessfulResponse(Globals.httpOkStatus[0], Globals.httpOkStatus[1], "Admin role assigned successfully");
            } else {
                LOG.warn("El rol ADMIN no se encontró en la base de datos.");
                return new UnsuccessfulResponse(Globals.httpBadRequest[0], Globals.httpBadRequest[1], "Admin role not found");
            }
        } catch (Exception e) {
            LOG.error("Error asignando rol ADMIN al usuario", e);
            return new UnsuccessfulResponse(Globals.httpInternalServerErrorStatus[0], Globals.httpInternalServerErrorStatus[1], "Error assigning admin role");
        }
    }
    public boolean verifyPin(String pin) {
        return userDao.existsByPinCode(pin);
    }

    public List<ActivityUserResponse> getUserActivity(int userId) {
        List<ReservationEntity> reservations = reservationDao.findByUserEntity_IdUsers(userId);
        return reservations.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    private ActivityUserResponse convertToDto(ReservationEntity reservation) {
        ActivityUserResponse response = new ActivityUserResponse();
        response.setIdReservation(reservation.getIdRes());
        response.setUserId(reservation.getUserEntity().getIdUsers());
        response.setVehicleId(reservation.getVehicleEntity().getIdVehicles());
        response.setSpotId(reservation.getSpotEntity().getIdSpots());
        response.setScheduledEntry(reservation.getScheduledEntry());
        response.setScheduledExit(reservation.getScheduledExit());
        response.setActualEntry(reservation.getActualEntry());
        response.setActualExit(reservation.getActualExit());
        response.setStatus(reservation.getStatus());
        return response;
    }

    public List<VehiclesActivityResponseDto> getUserVehicles(int userId) {
        List<VehicleEntity> vehicles = vehiclesDao.findByUserEntity_IdUsers(userId);
        return vehicles.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    private VehiclesActivityResponseDto mapToDto(VehicleEntity vehicleEntity) {
        List<ReservationEntity> reservations = reservationDao.findByVehicleEntity_IdVehicles(Math.toIntExact(vehicleEntity.getIdVehicles()));
        int totalReservations = reservations.size();
        double totalHoursUsed = calculateTotalHoursUsed(reservations);

        return VehiclesActivityResponseDto.builder()
                .idVehicles(vehicleEntity.getIdVehicles())
                .licensePlate(vehicleEntity.getLicensePlate())
                .carBranch(vehicleEntity.getCarBranch())
                .carModel(vehicleEntity.getCarModel())
                .carColor(vehicleEntity.getCarColor())
                .carManufacturingDate(vehicleEntity.getCarManufacturingDate())
                .totalReservations(totalReservations)
                .totalHoursUsed(totalHoursUsed)
                .build();
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
